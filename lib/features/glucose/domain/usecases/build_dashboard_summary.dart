import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/utils/local_date.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/dashboard_summary.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/glucose_reading.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

/// Bahan mentah untuk beranda, dibaca sekali dari database.
@immutable
class DashboardInput {
  const new({
    required this.windowReadings,
    required this.recentReadings,
    this.lastRandom,
  });

  /// Seluruh pembacaan aktif dalam 14 hari lokal terakhir.
  ///
  /// 14 hari, bukan 7, karena rata-rata mingguan perlu dibandingkan dengan
  /// minggu sebelumnya (PRD F-04 AC2).
  final List<GlucoseReading> windowReadings;

  /// Lima catatan terakhir, tanpa batas umur.
  final List<GlucoseReading> recentReadings;

  /// Pembacaan sewaktu terakhir, juga tanpa batas umur: kartu "Sewaktu
  /// terakhir" tetap harus terisi walau pengukuran terakhirnya sebulan lalu.
  final GlucoseReading? lastRandom;
}

/// Menyusun isi beranda dari data mentah (PRD F-04).
///
/// Murni dan sinkron: seluruh aritmetikanya bisa diuji tanpa database, dan
/// pembulatan hanya terjadi di satu tempat.
@injectable
class BuildDashboardSummary {
  const new();

  /// Panjang periode perbandingan (PRD F-04 AC2).
  static const int periodDays = 7;

  DashboardSummary call(DashboardInput input, {required DateTime now}) {
    final currentDates = _lastDates(now, periodDays);
    final previousDates = _lastDates(_shiftDays(now, -periodDays), periodDays);
    final todayKey = LocalDate.ofLocal(now);

    return DashboardSummary(
      today: todayKey,
      todayFasting: _firstWhereOrNull(
        input.windowReadings,
        (r) => r.type == ReadingType.fasting && r.localDate == todayKey,
      ),
      lastRandom: input.lastRandom,
      fastingAverage: _periodAverage(
        input.windowReadings,
        ReadingType.fasting,
        currentDates,
        previousDates,
      ),
      randomAverage: _periodAverage(
        input.windowReadings,
        ReadingType.random,
        currentDates,
        previousDates,
      ),
      fastingSparkline: _sparkline(
        input.windowReadings,
        ReadingType.fasting,
        currentDates,
      ),
      randomSparkline: _sparkline(
        input.windowReadings,
        ReadingType.random,
        currentDates,
      ),
      recentReadings: input.recentReadings,
    );
  }

  PeriodAverage _periodAverage(
    List<GlucoseReading> readings,
    ReadingType type,
    List<String> currentDates,
    List<String> previousDates,
  ) {
    final current = <int>[];
    final previous = <int>[];

    for (final reading in readings) {
      if (reading.type != type) continue;
      if (currentDates.contains(reading.localDate)) {
        current.add(reading.valueMgDl);
      } else if (previousDates.contains(reading.localDate)) {
        previous.add(reading.valueMgDl);
      }
    }

    return PeriodAverage(
      type: type,
      count: current.length,
      average: _mean(current),
      previousAverage: _mean(previous),
    );
  }

  List<DailyPoint> _sparkline(
    List<GlucoseReading> readings,
    ReadingType type,
    List<String> dates,
  ) {
    final buckets = <String, List<int>>{for (final d in dates) d: <int>[]};

    for (final reading in readings) {
      if (reading.type != type) continue;
      buckets[reading.localDate]?.add(reading.valueMgDl);
    }

    return [
      for (final date in dates)
        DailyPoint(localDate: date, average: _mean(buckets[date]!)),
    ];
  }

  /// `null` untuk daftar kosong, supaya "belum ada data" tidak berubah jadi 0.
  double? _mean(List<int> values) {
    if (values.isEmpty) return null;
    var total = 0;
    for (final v in values) {
      total += v;
    }
    return total / values.length;
  }

  /// Daftar `YYYY-MM-DD` sepanjang [count] hari yang berakhir di [end].
  ///
  /// Memakai aritmetika kalender, bukan `Duration`, agar pergeseran jam
  /// (mis. DST di zona waktu selain Indonesia) tidak memindahkan batas hari.
  List<String> _lastDates(DateTime end, int count) => [
    for (var i = count - 1; i >= 0; i--) LocalDate.ofLocal(_shiftDays(end, -i)),
  ];

  DateTime _shiftDays(DateTime date, int days) =>
      DateTime(date.year, date.month, date.day + days);

  T? _firstWhereOrNull<T>(List<T> items, bool Function(T) test) {
    for (final item in items) {
      if (test(item)) return item;
    }
    return null;
  }
}
