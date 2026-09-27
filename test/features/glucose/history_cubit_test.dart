import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/features/glucose/data/repositories/glucose_repository_impl.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/reading_group.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/delete_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/presentation/cubit/history_cubit.dart';
import 'package:flutter_gluko_apps/features/glucose/presentation/cubit/history_state.dart';
import 'package:flutter_gluko_apps/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/test_database.dart';

String fmt(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

void main() {
  late AppDatabase db;
  late GlucoseRepositoryImpl repository;
  late HistoryCubit cubit;

  setUp(() {
    db = createTestDatabase();
    repository = GlucoseRepositoryImpl(db.glucoseDao);
    cubit = HistoryCubit(
      repository,
      ProfileRepositoryImpl(db.profileDao),
      DeleteReading(repository),
      RestoreReading(repository),
    );
  });

  tearDown(() async {
    await cubit.close();
    await db.close();
  });

  /// Menyisipkan satu pembacaan pada [localDate].
  ///
  /// `measured_at` diturunkan dari [localDate] agar konsisten dengan kolom
  /// `local_date`. Ini penting karena entity mengekspos `localDate` sebagai
  /// getter turunan dari `measuredAt + tzOffset`, sementara query database
  /// memakai kolomnya; data uji yang tidak konsisten akan menguji perilaku
  /// yang tidak mungkin terjadi lewat AddReading.
  Future<int> seed({
    required String localDate,
    int value = 98,
    ReadingType type = ReadingType.fasting,
    GlucoseStatus status = GlucoseStatus.normal,
    int localHour = 6,
  }) {
    final date = DateTime.parse(localDate);
    final measuredAt = DateTime.utc(
      date.year,
      date.month,
      date.day,
      localHour,
    ).subtract(const Duration(minutes: 420));

    return db.glucoseDao.insertReading(
      readingCompanion(
        localDate: localDate,
        valueMgDl: value,
        type: type,
        status: status,
        measuredAt: measuredAt,
      ),
      [],
    );
  }

  /// Menunggu state yang memenuhi [predicate].
  ///
  /// State saat ini diperiksa lebih dulu: emisi yang memenuhi syarat bisa
  /// terjadi sebelum `firstWhere` sempat berlangganan, dan menunggu emisi
  /// berikutnya akan menggantung selamanya.
  Future<HistoryState> waitFor(bool Function(HistoryState) predicate) async {
    if (predicate(cubit.state)) return cubit.state;
    return await cubit.stream
        .firstWhere(predicate)
        .timeout(const Duration(seconds: 5));
  }

  group('Pengelompokan per tanggal (PRD F-05 AC1)', () {
    test('mengelompokkan per local_date, terbaru di atas', () async {
      await seed(localDate: '2026-09-24');
      await seed(localDate: '2026-09-26');
      await seed(localDate: '2026-09-26', type: ReadingType.random, value: 150);

      cubit.start();
      final state = await waitFor((s) => s.groups.length == 2);

      expect(state.groups.first.localDate, '2026-09-26');
      expect(state.groups.first.readings.length, 2);
      expect(state.groups.last.localDate, '2026-09-24');
      expect(state.totalReadings, 3);
    });

    test('judul kelompok memakai Hari ini dan Kemarin', () {
      final now = DateTime(2026, 9, 27, 10);

      expect(
        ReadingGrouper.headerLabel('2026-09-27', now: now, formatDate: fmt),
        startsWith('Hari ini'),
      );
      expect(
        ReadingGrouper.headerLabel('2026-09-26', now: now, formatDate: fmt),
        startsWith('Kemarin'),
      );
      expect(
        ReadingGrouper.headerLabel('2026-09-20', now: now, formatDate: fmt),
        '2026-09-20',
      );
    });
  });

  group('Filter tipe (PRD F-05 AC2)', () {
    test('menyaring satu tipe saja', () async {
      await seed(localDate: '2026-09-26');
      await seed(localDate: '2026-09-26', type: ReadingType.random, value: 150);

      cubit.start();
      await waitFor((s) => s.totalReadings == 2);

      cubit.setTypeFilter(ReadingType.random);
      final filtered = await waitFor(
        (s) => !s.isLoading && s.typeFilter == ReadingType.random,
      );

      expect(filtered.totalReadings, 1);
      expect(filtered.groups.single.readings.single.type, ReadingType.random);
      expect(filtered.hasActiveFilter, isTrue);
    });

    test('kembali ke Semua memulihkan seluruh catatan', () async {
      await seed(localDate: '2026-09-26');
      await seed(localDate: '2026-09-26', type: ReadingType.random, value: 150);

      cubit.start();
      await waitFor((s) => s.totalReadings == 2);

      cubit.setTypeFilter(ReadingType.random);
      await waitFor((s) => s.typeFilter == ReadingType.random && !s.isLoading);

      cubit.setTypeFilter(null);
      final all = await waitFor((s) => s.typeFilter == null && !s.isLoading);

      expect(all.totalReadings, 2);
      expect(all.hasActiveFilter, isFalse);
    });
  });

  group('Paginasi (PRD F-05 AC1)', () {
    test('memuat 30 item lalu menandai masih ada lanjutannya', () async {
      for (var day = 1; day <= 35; day++) {
        await seed(
          localDate: '2026-08-${day.toString().padLeft(2, '0')}',
          type: ReadingType.random,
          value: 100 + day,
        );
      }

      cubit.start();
      final first = await waitFor((s) => !s.isLoading && s.totalReadings > 0);

      expect(first.totalReadings, HistoryState.pageSize);
      expect(first.hasMore, isTrue);

      cubit.loadMore();
      final second = await waitFor((s) => s.totalReadings > 30);

      expect(second.totalReadings, 35);
      expect(second.hasMore, isFalse);
    });
  });

  group('Hapus dan Undo (PRD F-05 AC3)', () {
    test('hapus menyembunyikan catatan, Undo mengembalikannya', () async {
      final id = await seed(localDate: '2026-09-26');

      cubit.start();
      await waitFor((s) => s.totalReadings == 1);

      expect(await cubit.delete(id), isNull);
      await waitFor((s) => s.totalReadings == 0);

      expect(await cubit.undoDelete(id), isNull);
      final restored = await waitFor((s) => s.totalReadings == 1);
      expect(restored.groups.single.readings.single.id, id);
    });

    test('Undo gagal dengan pesan jelas bila slot GDP sudah terisi lagi', () async {
      final first = await seed(localDate: '2026-09-26');

      cubit.start();
      await waitFor((s) => s.totalReadings == 1);

      await cubit.delete(first);
      await waitFor((s) => s.totalReadings == 0);

      // Pengguna mencatat GDP baru pada tanggal yang sama sebelum menekan Undo.
      await seed(localDate: '2026-09-26', value: 101);
      await waitFor((s) => s.totalReadings == 1);

      final error = await cubit.undoDelete(first);
      expect(error, isNotNull);
      expect(error, contains('catatan puasa lain'));
    });
  });

  group('Kalender (PRD F-05 AC4)', () {
    test('memuat status terburuk per hari', () async {
      await seed(localDate: '2026-09-10');
      await seed(
        localDate: '2026-09-10',
        type: ReadingType.random,
        value: 260,
        status: GlucoseStatus.high,
      );
      await seed(localDate: '2026-09-11');

      await cubit.loadCalendar(month: DateTime(2026, 9));

      expect(cubit.state.calendarStatuses['2026-09-10'], GlucoseStatus.high);
      expect(cubit.state.calendarStatuses['2026-09-11'], GlucoseStatus.normal);
      expect(cubit.state.calendarStatuses['2026-09-12'], isNull);
    });

    test('hanya memuat bulan yang diminta', () async {
      await seed(localDate: '2026-08-31');
      await seed(localDate: '2026-09-01');

      await cubit.loadCalendar(month: DateTime(2026, 9));

      expect(cubit.state.calendarStatuses.containsKey('2026-08-31'), isFalse);
      expect(cubit.state.calendarStatuses.containsKey('2026-09-01'), isTrue);
    });
  });
}
