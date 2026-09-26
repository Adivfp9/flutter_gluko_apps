import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/glucose_reading.dart';
import 'package:meta/meta.dart';

/// Satu titik pada mini chart 7 hari di beranda.
///
/// [average] bernilai `null` bila hari itu tidak ada pengukuran — dibedakan
/// dari nilai 0 supaya garis grafik terputus, bukan terjun ke dasar.
@immutable
class DailyPoint {
  const new({required this.localDate, this.average});

  /// `YYYY-MM-DD`.
  final String localDate;
  final double? average;

  bool get isEmpty => average == null;

  @override
  bool operator ==(Object other) =>
      other is DailyPoint &&
      other.localDate == localDate &&
      other.average == average;

  @override
  int get hashCode => Object.hash(localDate, average);
}

/// Rata-rata satu tipe pengukuran pada periode 7 hari, beserta perubahannya
/// terhadap 7 hari sebelumnya (PRD F-04 AC2).
@immutable
class PeriodAverage {
  const new({
    required this.type,
    required this.count,
    this.average,
    this.previousAverage,
  });

  final ReadingType type;

  /// Jumlah pembacaan pada periode berjalan.
  final int count;

  /// `null` bila belum ada pembacaan pada periode berjalan.
  final double? average;

  /// `null` bila periode sebelumnya kosong, sehingga perbandingan tidak punya
  /// dasar.
  final double? previousAverage;

  bool get hasData => average != null;

  /// Selisih terhadap periode sebelumnya, dibulatkan ke mg/dL bulat.
  ///
  /// `null` bila salah satu periode kosong — menampilkan "turun 101" padahal
  /// minggu lalu tidak ada data akan menyesatkan.
  int? get delta {
    final current = average;
    final previous = previousAverage;
    if (current == null || previous == null) return null;
    return (current - previous).round();
  }

  /// Angka rata-rata siap tampil (dibulatkan), `null` bila belum ada data.
  int? get roundedAverage => average?.round();

  @override
  bool operator ==(Object other) =>
      other is PeriodAverage &&
      other.type == type &&
      other.count == count &&
      other.average == average &&
      other.previousAverage == previousAverage;

  @override
  int get hashCode => Object.hash(type, count, average, previousAverage);
}

/// Isi layar Beranda (S-03 / PRD F-04).
@immutable
class DashboardSummary {
  const new({
    required this.today,
    required this.fastingAverage,
    required this.randomAverage,
    required this.fastingSparkline,
    required this.randomSparkline,
    required this.recentReadings,
    this.todayFasting,
    this.lastRandom,
  });

  /// Tanggal lokal acuan, `YYYY-MM-DD`.
  final String today;

  /// Kartu "Puasa hari ini"; `null` → ajakan "Catat sekarang" (F-04 AC1).
  final GlucoseReading? todayFasting;

  /// Kartu "Sewaktu terakhir", boleh berasal dari kapan pun.
  final GlucoseReading? lastRandom;

  final PeriodAverage fastingAverage;
  final PeriodAverage randomAverage;

  final List<DailyPoint> fastingSparkline;
  final List<DailyPoint> randomSparkline;

  /// Lima catatan terakhir (F-04 AC3).
  final List<GlucoseReading> recentReadings;

  /// Belum ada satu pun catatan: beranda menampilkan empty state (PRD 6.5).
  bool get isEmpty =>
      todayFasting == null && lastRandom == null && recentReadings.isEmpty;
}
