import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/features/glucose/data/repositories/glucose_repository_impl.dart';
import 'package:flutter_gluko_apps/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_gluko_apps/features/target/data/repositories/target_repository_impl.dart';
import 'package:flutter_gluko_apps/features/trend/domain/entities/trend_summary.dart';
import 'package:flutter_gluko_apps/features/trend/domain/usecases/build_trend_summary.dart';
import 'package:flutter_gluko_apps/features/trend/presentation/cubit/trend_cubit.dart';
import 'package:flutter_gluko_apps/features/trend/presentation/cubit/trend_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late TrendCubit cubit;

  final now = DateTime(2026, 9, 27, 8);

  setUp(() {
    db = createTestDatabase();
    cubit = TrendCubit(
      GlucoseRepositoryImpl(db.glucoseDao),
      TargetRepositoryImpl(db.targetDao),
      ProfileRepositoryImpl(db.profileDao),
      const BuildTrendSummary(),
    );
  });

  tearDown(() async {
    await cubit.close();
    await db.close();
  });

  /// Menyisipkan satu pembacaan pada [localDate], jam 06.00 WIB.
  Future<int> seed({
    required String localDate,
    int value = 98,
    ReadingType type = ReadingType.fasting,
    GlucoseStatus status = GlucoseStatus.normal,
  }) {
    final date = DateTime.parse(localDate);
    final measuredAt = DateTime.utc(
      date.year,
      date.month,
      date.day,
      6,
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

  /// Menunggu state yang memenuhi [predicate]; state saat ini diperiksa dulu
  /// supaya emisi yang sudah terjadi tidak membuat test menggantung.
  Future<TrendState> waitFor(bool Function(TrendState) predicate) async {
    if (predicate(cubit.state)) return cubit.state;
    return await cubit.stream
        .firstWhere(predicate)
        .timeout(const Duration(seconds: 5));
  }

  test('hanya memuat pembacaan aktif di dalam periode', () async {
    await seed(localDate: '2026-09-27', value: 90);
    await seed(localDate: '2026-09-14', value: 110); // hari pertama 14 hari
    await seed(localDate: '2026-09-13', value: 300); // di luar periode
    final deleted = await seed(localDate: '2026-09-20', value: 250);
    await db.glucoseDao.softDelete(deleted, DateTime.utc(2026, 9, 21));

    cubit.start(now: now);
    final state = await waitFor((s) => s.summary != null);

    final stats = state.summary!.fastingStats;
    expect(stats.count, 2);
    expect(stats.average, 100);
    expect(stats.max, 110);
    expect(state.summary!.fromLocalDate, '2026-09-14');
    expect(state.summary!.toLocalDate, '2026-09-27');
    expect(state.isLoading, isFalse);
  });

  test('pembacaan baru langsung masuk tanpa muat ulang manual', () async {
    cubit.start(now: now);
    await waitFor((s) => s.summary != null);
    expect(cubit.state.summary!.isEmpty, isTrue);

    await seed(localDate: '2026-09-26', value: 180, type: ReadingType.random);

    final state = await waitFor((s) => s.summary?.randomStats.count == 1);
    expect(state.summary!.randomStats.average, 180);
  });

  test('mengganti periode memperluas jendela data', () async {
    await seed(localDate: '2026-09-27', value: 90);
    await seed(localDate: '2026-08-01', value: 130);

    cubit.start(now: now);
    await waitFor((s) => s.summary?.fastingStats.count == 1);

    cubit.setPeriod(TrendPeriod.quarter);
    final state = await waitFor(
      (s) =>
          s.period == TrendPeriod.quarter && s.summary?.fastingStats.count == 2,
    );
    expect(state.summary!.fromLocalDate, '2026-06-30');
    expect(state.summary!.fastingStats.average, 110);
  });

  test('pita target mengikuti target puasa yang aktif', () async {
    cubit.start(now: now);
    final state = await waitFor((s) => s.summary?.bandLow != null);

    final targets = await TargetRepositoryImpl(db.targetDao).getTargets();
    final fasting = targets
        .getOrElse((_) => throw StateError('target tidak terbaca'))
        .forType(ReadingType.fasting);

    expect(state.summary!.bandLow, fasting.lowMax);
    expect(state.summary!.bandHigh, fasting.normalMax);
  });

  test('toggle tipe tidak pernah menyembunyikan semua garis', () {
    expect(cubit.state.visibleTypes, {ReadingType.fasting, ReadingType.random});

    cubit.toggleType(ReadingType.random);
    expect(cubit.state.visibleTypes, {ReadingType.fasting});

    cubit.toggleType(ReadingType.fasting);
    expect(cubit.state.visibleTypes, {
      ReadingType.fasting,
    }, reason: 'minimal satu tipe harus tetap tampil');

    cubit.toggleType(ReadingType.postprandial2h);
    expect(cubit.state.visibleTypes, {
      ReadingType.fasting,
      ReadingType.postprandial2h,
    });
  });
}
