import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/utils/local_date.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/entities/reminder.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/entities/scheduled_notification.dart';
import 'package:injectable/injectable.dart';

/// Menerjemahkan daftar pengingat menjadi notifikasi yang harus terjadwal.
///
/// Murni dan sinkron: seluruh aturan jadwal (hari aktif, lewati puasa) diuji
/// tanpa plugin notifikasi.
///
/// PRD F-07 AC4 — pengingat puasa dilewati bila GDP hari itu sudah tercatat.
/// OS tidak bisa memeriksa database saat notifikasi akan tampil, jadi aturan
/// ini diwujudkan dengan menggeser kemunculan pertama ke minggu berikutnya;
/// pengulangan mingguan setelahnya tidak berubah.
@injectable
class PlanReminderSchedule {
  const new();

  List<ScheduledNotification> call({
    required List<Reminder> reminders,
    required DateTime now,
    Set<String> fastingLoggedDates = const {},
  }) {
    final result = <ScheduledNotification>[];

    for (final reminder in reminders) {
      final reminderId = reminder.id;
      if (reminderId == null || !reminder.isActive) continue;

      for (final weekday in reminder.activeWeekdays) {
        var fireAt = _nextOccurrence(now, weekday, reminder);

        final skipsWhenLogged = reminder.readingType == ReadingType.fasting;
        if (skipsWhenLogged &&
            fastingLoggedDates.contains(LocalDate.ofLocal(fireAt))) {
          fireAt = _addDays(fireAt, 7);
        }

        result.add(
          ScheduledNotification(
            id: ScheduledNotification.idFor(reminderId, weekday),
            reminderId: reminderId,
            weekday: weekday,
            firstFireAt: fireAt,
            title: _titleFor(reminder),
            body: _bodyFor(reminder),
            payload: payloadFor(reminder.readingType),
          ),
        );
      }
    }

    result.sort((a, b) => a.firstFireAt.compareTo(b.firstFireAt));
    return result;
  }

  /// Lokasi form catat, dengan tipe terisi bila pengingat punya tipe.
  static String payloadFor(ReadingType? type) =>
      type == null ? '/catat' : '/catat?type=${type.dbValue}';

  /// Kemunculan berikutnya yang masih di masa depan.
  ///
  /// Jam yang sama persis dengan [now] dianggap sudah lewat: menjadwalkannya
  /// akan membuat notifikasi berbunyi seketika saat pengguna menyimpan.
  DateTime _nextOccurrence(DateTime now, int weekday, Reminder reminder) {
    final daysAhead = (weekday - now.weekday) % 7;
    final candidate = DateTime(
      now.year,
      now.month,
      now.day + daysAhead,
      reminder.hour,
      reminder.minute,
    );
    return candidate.isAfter(now) ? candidate : _addDays(candidate, 7);
  }

  /// Menambah hari kalender, bukan 24 jam, agar jam dinding tetap sama.
  DateTime _addDays(DateTime at, int days) =>
      DateTime(at.year, at.month, at.day + days, at.hour, at.minute);

  String _titleFor(Reminder reminder) => switch (reminder.readingType) {
    ReadingType.fasting => 'Waktunya cek gula darah puasa',
    ReadingType.random => 'Waktunya cek gula darah sewaktu',
    ReadingType.postprandial2h => 'Waktunya cek gula 2 jam setelah makan',
    null => reminder.label,
  };

  String _bodyFor(Reminder reminder) {
    final label = reminder.label.trim();
    return label.isEmpty || label == _titleFor(reminder)
        ? 'Ketuk untuk langsung mencatat hasilnya.'
        : '$label · ketuk untuk mencatat.';
  }
}
