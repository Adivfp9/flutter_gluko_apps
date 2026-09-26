import 'package:flutter_gluko_apps/core/utils/local_date.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/glucose_reading.dart';
import 'package:meta/meta.dart';

/// Sekelompok pembacaan pada satu tanggal lokal (PRD F-05 AC1).
@immutable
class ReadingGroup {
  const new({required this.localDate, required this.readings});

  /// `YYYY-MM-DD`.
  final String localDate;

  /// Isi kelompok, terbaru di atas.
  final List<GlucoseReading> readings;

  @override
  bool operator ==(Object other) =>
      other is ReadingGroup &&
      other.localDate == localDate &&
      _sameIds(other.readings, readings);

  static bool _sameIds(List<GlucoseReading> a, List<GlucoseReading> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id) return false;
    }
    return true;
  }

  @override
  int get hashCode =>
      Object.hash(localDate, Object.hashAll([for (final r in readings) r.id]));
}

/// Mengelompokkan pembacaan per tanggal lokal, terbaru di atas.
///
/// Memakai `localDate` yang tersimpan bersama pembacaan, bukan menghitung ulang
/// dari zona waktu perangkat saat ini — kalau tidak, riwayat pengguna yang
/// pernah bepergian akan berpindah hari setiap kali dibuka (PRD 5.5).
@immutable
abstract final class ReadingGrouper {
  static List<ReadingGroup> byLocalDate(List<GlucoseReading> readings) {
    final buckets = <String, List<GlucoseReading>>{};

    for (final reading in readings) {
      buckets.putIfAbsent(reading.localDate, () => []).add(reading);
    }

    final dates = buckets.keys.toList()..sort((a, b) => b.compareTo(a));

    return [
      for (final date in dates)
        ReadingGroup(
          localDate: date,
          readings: buckets[date]!
            ..sort((a, b) => b.measuredAt.compareTo(a.measuredAt)),
        ),
    ];
  }

  /// Judul kelompok: "Hari ini", "Kemarin", atau tanggal singkat.
  static String headerLabel(
    String localDate, {
    required DateTime now,
    required String Function(DateTime) formatDate,
  }) {
    final today = LocalDate.ofLocal(now);
    final yesterday = LocalDate.ofLocal(
      DateTime(now.year, now.month, now.day - 1),
    );

    final formatted = formatDate(DateTime.parse(localDate));
    if (localDate == today) return 'Hari ini · $formatted';
    if (localDate == yesterday) return 'Kemarin · $formatted';
    return formatted;
  }
}
