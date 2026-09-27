import 'package:meta/meta.dart';

/// Satu notifikasi berulang mingguan yang harus terjadwal di OS.
///
/// Setiap pengingat dipecah per hari aktif karena Android hanya mengenal
/// pengulangan "harian" atau "hari-X-setiap-minggu", bukan daftar hari.
@immutable
class ScheduledNotification {
  const new({
    required this.id,
    required this.reminderId,
    required this.weekday,
    required this.firstFireAt,
    required this.title,
    required this.body,
    required this.payload,
  });

  /// ID notifikasi di OS: `reminderId * 10 + weekday`, stabil antar sinkronisasi.
  final int id;

  final int reminderId;

  /// 1 = Senin … 7 = Minggu.
  final int weekday;

  /// Waktu lokal pertama notifikasi berbunyi; setelahnya berulang tiap minggu
  /// pada hari dan jam yang sama.
  final DateTime firstFireAt;

  final String title;
  final String body;

  /// Lokasi go_router yang dibuka saat notifikasi di-tap (PRD F-07 AC3).
  final String payload;

  static int idFor(int reminderId, int weekday) => reminderId * 10 + weekday;

  @override
  bool operator ==(Object other) =>
      other is ScheduledNotification &&
      other.id == id &&
      other.reminderId == reminderId &&
      other.weekday == weekday &&
      other.firstFireAt == firstFireAt &&
      other.title == title &&
      other.body == body &&
      other.payload == payload;

  @override
  int get hashCode =>
      Object.hash(id, reminderId, weekday, firstFireAt, title, body, payload);

  @override
  String toString() => 'ScheduledNotification($id, $firstFireAt)';
}
