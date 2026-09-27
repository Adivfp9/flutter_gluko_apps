import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/utils/local_date.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/features/glucose/data/repositories/glucose_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fixtures.dart';
import '../helpers/test_database.dart';

/// Rencana 3.7 / NFR-02–03: query beranda, riwayat, kalender, dan tren
/// ≤ 300 ms dengan 10.000 pembacaan.
///
/// Diukur di mesin test, bukan di ponsel; angka sebenarnya dicek ulang saat
/// profiling perangkat fisik (Sprint 5.4). Batas di sini sengaja sama agar
/// regresi besar (index hilang, N+1 query) langsung ketahuan di CI.
void main() {
  const total = 10000;
  const budget = Duration(milliseconds: 300);
  final now = DateTime(2026, 9, 27, 20);

  late AppDatabase db;
  late GlucoseRepositoryImpl repository;

  setUpAll(() async {
    db = createTestDatabase();
    repository = GlucoseRepositoryImpl(db.glucoseDao);

    // ~9 pembacaan per hari selama ~3 tahun; GDP hanya satu per hari karena
    // indeks unik ux_fasting_per_day.
    const perDay = 9;
    await db.batch((b) {
      for (var i = 0; i < total; i++) {
        final day = i ~/ perDay;
        final slot = i % perDay;
        final local = DateTime(now.year, now.month, now.day - day, 6 + slot);
        final type = slot == 0
            ? ReadingType.fasting
            : slot.isEven
            ? ReadingType.random
            : ReadingType.postprandial2h;
        final value = 70 + (i * 37) % 200;
        b.insert(
          db.glucoseReadingsTable,
          readingCompanion(
            localDate: LocalDate.ofLocal(local),
            measuredAt: local.toUtc(),
            type: type,
            valueMgDl: value,
            status: value < 140
                ? GlucoseStatus.normal
                : value < 200
                ? GlucoseStatus.warning
                : GlucoseStatus.high,
          ),
        );
      }
    });
  });

  tearDownAll(() => db.close());

  /// Waktu sampai emisi pertama stream, diambil yang tercepat dari tiga
  /// percobaan agar tidak terpengaruh JIT warm-up.
  Future<Duration> firstEmission<T>(Stream<T> Function() open) async {
    var best = const Duration(days: 1);
    for (var i = 0; i < 3; i++) {
      final sw = Stopwatch()..start();
      await open().first;
      sw.stop();
      if (sw.elapsed < best) best = sw.elapsed;
    }
    return best;
  }

  test('data uji benar-benar 10.000 baris', () async {
    final count = await db
        .customSelect('SELECT count(*) AS c FROM glucose_readings')
        .getSingle();
    expect(count.read<int>('c'), total);
  });

  test('beranda ≤ 300 ms', () async {
    final elapsed = await firstEmission(
      () => repository.watchDashboard(now: now),
    );
    expect(elapsed, lessThanOrEqualTo(budget), reason: '$elapsed');
  });

  test('riwayat halaman pertama ≤ 300 ms', () async {
    final elapsed = await firstEmission(
      () => repository.watchHistory(limit: 30, offset: 0),
    );
    expect(elapsed, lessThanOrEqualTo(budget), reason: '$elapsed');
  });

  test('riwayat terfilter dan halaman jauh ≤ 300 ms', () async {
    final elapsed = await firstEmission(
      () => repository.watchHistory(
        type: ReadingType.random,
        status: GlucoseStatus.high,
        limit: 30,
        offset: 300,
      ),
    );
    expect(elapsed, lessThanOrEqualTo(budget), reason: '$elapsed');
  });

  test('kalender satu bulan ≤ 300 ms', () async {
    final sw = Stopwatch()..start();
    final result = await repository.worstStatusPerDay(
      fromLocalDate: '2026-09-01',
      toLocalDate: '2026-09-30',
    );
    sw.stop();

    expect(result.isRight(), isTrue);
    expect(sw.elapsed, lessThanOrEqualTo(budget), reason: '${sw.elapsed}');
  });

  test('tren 90 hari ≤ 300 ms', () async {
    final elapsed = await firstEmission(
      () => repository.watchReadingsBetween(
        fromLocalDate: LocalDate.ofLocal(
          DateTime(now.year, now.month, now.day - 89),
        ),
        toLocalDate: LocalDate.ofLocal(now),
      ),
    );
    expect(elapsed, lessThanOrEqualTo(budget), reason: '$elapsed');
  });
}
