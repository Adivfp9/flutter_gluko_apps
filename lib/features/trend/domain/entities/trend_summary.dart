import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/glucose_reading.dart';
import 'package:meta/meta.dart';

/// Periode grafik tren (PRD F-06 AC1).
enum TrendPeriod {
  week(7, '7 hari'),
  twoWeeks(14, '14 hari'),
  month(30, '30 hari'),
  quarter(90, '90 hari');

  new(this.days, this.label);

  final int days;
  final String label;
}

/// Statistik satu tipe pengukuran pada satu periode (PRD F-06 AC4).
@immutable
class TrendStats {
  const new({
    required this.type,
    required this.count,
    required this.inTargetCount,
    this.average,
    this.min,
    this.max,
  });

  final ReadingType type;
  final int count;

  /// Jumlah pembacaan berstatus Normal — pembilang Time in Range.
  final int inTargetCount;

  final double? average;
  final int? min;
  final int? max;

  bool get hasData => count > 0;

  int? get roundedAverage => average?.round();

  /// PRD 5.4: Time in Range = pembacaan Normal ÷ total pembacaan tipe itu.
  ///
  /// `null` bila belum ada data, supaya UI tidak menampilkan "0% dalam target"
  /// untuk periode yang sebenarnya kosong.
  double? get timeInRange => count == 0 ? null : inTargetCount / count;

  int? get timeInRangePercent {
    final value = timeInRange;
    return value == null ? null : (value * 100).round();
  }

  @override
  bool operator ==(Object other) =>
      other is TrendStats &&
      other.type == type &&
      other.count == count &&
      other.inTargetCount == inTargetCount &&
      other.average == average &&
      other.min == min &&
      other.max == max;

  @override
  int get hashCode =>
      Object.hash(type, count, inTargetCount, average, min, max);
}

/// Satu titik pada grafik tren: pembacaan individual, bukan rata-rata harian,
/// supaya tap bisa menampilkan nilai dan jam aslinya (PRD F-06 AC3).
@immutable
class TrendPoint {
  const new({required this.reading});

  final GlucoseReading reading;

  int get valueMgDl => reading.valueMgDl;
  GlucoseStatus get status => reading.status;
  DateTime get measuredAt => reading.measuredAt;

  @override
  bool operator ==(Object other) =>
      other is TrendPoint && other.reading.id == reading.id;

  @override
  int get hashCode => reading.id.hashCode;
}

/// Rentang sumbu Y grafik.
///
/// Dihitung dari data, bukan dipatok 80–200 seperti pada berkas desain: nilai
/// nyata bisa 20–600 mg/dL, dan sumbu tetap akan memotong titik di luarnya.
@immutable
class ChartScale {
  const new({required this.min, required this.max, required this.step});

  final double min;
  final double max;

  /// Jarak antar garis bantu.
  final double step;

  double get span => max - min;

  /// Nilai garis bantu, dari [min] sampai [max].
  List<double> get gridLines {
    final lines = <double>[];
    for (var v = min; v <= max + 0.001; v += step) {
      lines.add(v);
    }
    return lines;
  }

  @override
  bool operator ==(Object other) =>
      other is ChartScale &&
      other.min == min &&
      other.max == max &&
      other.step == step;

  @override
  int get hashCode => Object.hash(min, max, step);
}

/// Isi layar Tren (S-08).
@immutable
class TrendSummary {
  const new({
    required this.period,
    required this.fastingPoints,
    required this.randomPoints,
    required this.postprandialPoints,
    required this.fastingStats,
    required this.randomStats,
    required this.postprandialStats,
    required this.scale,
    required this.fromLocalDate,
    required this.toLocalDate,
    this.bandLow,
    this.bandHigh,
  });

  final TrendPeriod period;

  final List<TrendPoint> fastingPoints;
  final List<TrendPoint> randomPoints;
  final List<TrendPoint> postprandialPoints;

  final TrendStats fastingStats;
  final TrendStats randomStats;
  final TrendStats postprandialStats;

  final ChartScale scale;

  /// `YYYY-MM-DD`.
  final String fromLocalDate;
  final String toLocalDate;

  /// Batas bawah dan atas pita target pada grafik (PRD F-06 AC2).
  ///
  /// `null` bila target tidak tersedia; grafik lalu digambar tanpa pita,
  /// bukan dengan pita di posisi asal yang menyesatkan.
  final double? bandLow;
  final double? bandHigh;

  bool get isEmpty =>
      fastingPoints.isEmpty &&
      randomPoints.isEmpty &&
      postprandialPoints.isEmpty;

  List<TrendPoint> pointsOf(ReadingType type) => switch (type) {
    ReadingType.fasting => fastingPoints,
    ReadingType.random => randomPoints,
    ReadingType.postprandial2h => postprandialPoints,
  };

  TrendStats statsOf(ReadingType type) => switch (type) {
    ReadingType.fasting => fastingStats,
    ReadingType.random => randomStats,
    ReadingType.postprandial2h => postprandialStats,
  };
}
