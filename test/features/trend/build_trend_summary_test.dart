import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/domain/target_presets.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_gluko_apps/features/trend/domain/entities/trend_summary.dart';
import 'package:flutter_gluko_apps/features/trend/domain/usecases/build_trend_summary.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const build = BuildTrendSummary();
  final now = DateTime(2026, 9, 27, 8);
  const tzOffset = 420;

  var nextId = 0;

  GlucoseReading reading({
    required int value,
    ReadingType type = ReadingType.fasting,
    GlucoseStatus status = GlucoseStatus.normal,
    int daysAgo = 0,
  }) {
    final wallClock = DateTime.utc(now.year, now.month, now.day - daysAgo, 6);
    return GlucoseReading(
      id: ++nextId,
      type: type,
      valueMgDl: value,
      measuredAt: wallClock.subtract(const Duration(minutes: tzOffset)),
      tzOffsetMinutes: tzOffset,
      status: status,
      isCritical: false,
    );
  }

  group('Statistik periode (PRD F-06 AC4)', () {
    test('menghitung rata-rata, min, maks, dan jumlah per tipe', () {
      final summary = build(
        readings: [
          reading(value: 90),
          reading(value: 100, daysAgo: 1),
          reading(value: 110, daysAgo: 2),
          reading(value: 200, type: ReadingType.random),
        ],
        period: TrendPeriod.week,
        now: now,
      );

      expect(summary.fastingStats.count, 3);
      expect(summary.fastingStats.average, 100);
      expect(summary.fastingStats.min, 90);
      expect(summary.fastingStats.max, 110);

      expect(summary.randomStats.count, 1);
      expect(summary.randomStats.average, 200);
      expect(summary.randomStats.min, 200);
      expect(summary.randomStats.max, 200);
    });

    test('tipe tanpa data melaporkan null, bukan nol', () {
      final summary = build(
        readings: [reading(value: 90)],
        period: TrendPeriod.week,
        now: now,
      );

      expect(summary.randomStats.hasData, isFalse);
      expect(summary.randomStats.average, isNull);
      expect(summary.randomStats.min, isNull);
      expect(summary.randomStats.max, isNull);
      expect(summary.randomStats.roundedAverage, isNull);
    });
  });

  group('Time in Range (PRD 5.4)', () {
    test('hanya status Normal yang dihitung sebagai dalam target', () {
      final summary = build(
        readings: [
          reading(value: 90),
          reading(value: 95, daysAgo: 1),
          reading(value: 130, status: GlucoseStatus.warning, daysAgo: 2),
          reading(value: 200, status: GlucoseStatus.high, daysAgo: 3),
        ],
        period: TrendPeriod.week,
        now: now,
      );

      expect(summary.fastingStats.inTargetCount, 2);
      expect(summary.fastingStats.timeInRange, 0.5);
      expect(summary.fastingStats.timeInRangePercent, 50);
    });

    test('status Rendah tidak dihitung dalam target', () {
      final summary = build(
        readings: [
          reading(value: 60, status: GlucoseStatus.low),
          reading(value: 90, daysAgo: 1),
        ],
        period: TrendPeriod.week,
        now: now,
      );

      expect(summary.fastingStats.timeInRangePercent, 50);
    });

    test('tanpa data, TIR null agar berbeda dari 0 persen', () {
      final summary = build(
        readings: const [],
        period: TrendPeriod.week,
        now: now,
      );

      expect(summary.fastingStats.timeInRange, isNull);
      expect(summary.fastingStats.timeInRangePercent, isNull);
      expect(summary.isEmpty, isTrue);
    });

    test('semua dalam target menghasilkan 100 persen', () {
      final summary = build(
        readings: [reading(value: 90), reading(value: 95, daysAgo: 1)],
        period: TrendPeriod.week,
        now: now,
      );

      expect(summary.fastingStats.timeInRangePercent, 100);
    });
  });

  group('Skala sumbu Y', () {
    test('mencakup seluruh nilai termasuk yang ekstrem', () {
      final summary = build(
        readings: [
          reading(value: 40, status: GlucoseStatus.low),
          reading(value: 480, status: GlucoseStatus.high, daysAgo: 1),
        ],
        period: TrendPeriod.week,
        now: now,
      );

      expect(summary.scale.min, lessThanOrEqualTo(40));
      expect(summary.scale.max, greaterThanOrEqualTo(480));
    });

    test('tidak pernah turun di bawah nol', () {
      final summary = build(
        readings: [reading(value: 21, status: GlucoseStatus.low)],
        period: TrendPeriod.week,
        now: now,
      );

      expect(summary.scale.min, greaterThanOrEqualTo(0));
    });

    test('data yang sangat rapat tetap punya rentang minimal', () {
      final summary = build(
        readings: [
          reading(value: 100),
          reading(value: 101, daysAgo: 1),
          reading(value: 99, daysAgo: 2),
        ],
        period: TrendPeriod.week,
        now: now,
      );

      expect(
        summary.scale.span,
        greaterThanOrEqualTo(40),
        reason: 'fluktuasi 2 mg/dL tidak boleh tampak dramatis',
      );
    });

    test('pita target tetap terlihat walau semua nilai jauh di atasnya', () {
      const band = TargetThresholds(lowMax: 70, normalMax: 99, warningMax: 125);
      final summary = build(
        readings: [
          reading(value: 260, status: GlucoseStatus.high),
          reading(value: 280, status: GlucoseStatus.high, daysAgo: 1),
        ],
        period: TrendPeriod.week,
        now: now,
        band: band,
      );

      expect(summary.scale.min, lessThanOrEqualTo(70));
      expect(summary.scale.max, greaterThanOrEqualTo(280));
    });

    test('periode kosong memakai skala bawaan yang masuk akal', () {
      final summary = build(
        readings: const [],
        period: TrendPeriod.month,
        now: now,
      );

      expect(summary.scale.min, 60);
      expect(summary.scale.max, 200);
      expect(summary.scale.gridLines, isNotEmpty);
    });

    test('garis bantu berjarak sama dan tidak melewati batas atas', () {
      final summary = build(
        readings: [reading(value: 100), reading(value: 180, daysAgo: 1)],
        period: TrendPeriod.week,
        now: now,
      );

      final lines = summary.scale.gridLines;
      expect(lines.first, summary.scale.min);
      expect(lines.last, lessThanOrEqualTo(summary.scale.max));
      for (var i = 1; i < lines.length; i++) {
        expect(lines[i] - lines[i - 1], closeTo(summary.scale.step, 0.001));
      }
    });
  });

  group('Rentang tanggal', () {
    test('periode 7 hari berakhir hari ini', () {
      final summary = build(
        readings: const [],
        period: TrendPeriod.week,
        now: now,
      );

      expect(summary.fromLocalDate, '2026-09-21');
      expect(summary.toLocalDate, '2026-09-27');
    });

    test('periode 90 hari dihitung lintas bulan', () {
      final summary = build(
        readings: const [],
        period: TrendPeriod.quarter,
        now: now,
      );

      expect(summary.fromLocalDate, '2026-06-30');
      expect(summary.toLocalDate, '2026-09-27');
    });
  });
}
