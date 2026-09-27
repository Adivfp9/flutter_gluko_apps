import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/domain/target_presets.dart';
import 'package:flutter_gluko_apps/core/utils/local_date.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_gluko_apps/features/trend/domain/entities/trend_summary.dart';
import 'package:injectable/injectable.dart';

/// Menyusun isi layar Tren (PRD F-06).
///
/// Murni dan sinkron supaya seluruh statistiknya bisa diuji tanpa database.
@injectable
class BuildTrendSummary {
  const new();

  /// Margin di atas dan di bawah data agar titik tidak menempel di tepi.
  static const double _padding = 20;

  TrendSummary call({
    required List<GlucoseReading> readings,
    required TrendPeriod period,
    required DateTime now,
    TargetThresholds? band,
  }) {
    final from = DateTime(now.year, now.month, now.day - (period.days - 1));

    List<TrendPoint> pointsFor(ReadingType type) => [
      for (final r in readings)
        if (r.type == type) TrendPoint(reading: r),
    ];

    final fasting = pointsFor(ReadingType.fasting);
    final random = pointsFor(ReadingType.random);
    final postprandial = pointsFor(ReadingType.postprandial2h);

    return TrendSummary(
      period: period,
      fastingPoints: fasting,
      randomPoints: random,
      postprandialPoints: postprandial,
      fastingStats: _stats(ReadingType.fasting, fasting),
      randomStats: _stats(ReadingType.random, random),
      postprandialStats: _stats(ReadingType.postprandial2h, postprandial),
      scale: buildScale([...fasting, ...random, ...postprandial], band: band),
      fromLocalDate: LocalDate.ofLocal(from),
      toLocalDate: LocalDate.ofLocal(now),
      bandLow: band?.lowMax.toDouble(),
      bandHigh: band?.normalMax.toDouble(),
    );
  }

  TrendStats _stats(ReadingType type, List<TrendPoint> points) {
    if (points.isEmpty) {
      return TrendStats(type: type, count: 0, inTargetCount: 0);
    }

    var total = 0;
    var min = points.first.valueMgDl;
    var max = points.first.valueMgDl;
    var inTarget = 0;

    for (final p in points) {
      final v = p.valueMgDl;
      total += v;
      if (v < min) min = v;
      if (v > max) max = v;
      if (p.status == GlucoseStatus.normal) inTarget++;
    }

    return TrendStats(
      type: type,
      count: points.length,
      inTargetCount: inTarget,
      average: total / points.length,
      min: min,
      max: max,
    );
  }

  /// Skala sumbu Y yang menampung seluruh titik dan pita target.
  ///
  /// Batasnya dibulatkan ke kelipatan yang mudah dibaca, dan rentangnya dijaga
  /// minimal agar data yang sangat rapat tidak tampak seperti garis datar
  /// tanpa skala.
  ChartScale buildScale(List<TrendPoint> points, {TargetThresholds? band}) {
    if (points.isEmpty) {
      return const ChartScale(min: 60, max: 200, step: 40);
    }

    var lowest = points.first.valueMgDl.toDouble();
    var highest = lowest;
    for (final p in points) {
      final v = p.valueMgDl.toDouble();
      if (v < lowest) lowest = v;
      if (v > highest) highest = v;
    }

    // Pita target harus ikut terlihat walau semua pembacaan berada di atasnya.
    if (band != null) {
      if (band.lowMax < lowest) lowest = band.lowMax.toDouble();
      if (band.normalMax > highest) highest = band.normalMax.toDouble();
    }

    var min = lowest - _padding;
    var max = highest + _padding;
    if (min < 0) min = 0;

    // Rentang minimal 40 mg/dL supaya fluktuasi kecil tidak tampak dramatis.
    if (max - min < 40) {
      final center = (max + min) / 2;
      min = center - 20;
      max = center + 20;
      if (min < 0) {
        max -= min;
        min = 0;
      }
    }

    final step = _niceStep((max - min) / 4);
    final niceMin = (min / step).floor() * step;
    final niceMax = (max / step).ceil() * step;

    return ChartScale(min: niceMin, max: niceMax, step: step);
  }

  /// Membulatkan jarak garis bantu ke angka yang enak dibaca.
  double _niceStep(double raw) {
    const candidates = <double>[10, 20, 25, 50, 100, 150, 200];
    for (final c in candidates) {
      if (raw <= c) return c;
    }
    return (raw / 100).ceil() * 100;
  }
}
