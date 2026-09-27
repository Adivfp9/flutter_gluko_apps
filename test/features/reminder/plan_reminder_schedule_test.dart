import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/entities/reminder.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/entities/scheduled_notification.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/usecases/plan_reminder_schedule.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const plan = PlanReminderSchedule();

  // Minggu, 27 September 2026 pukul 08.00.
  final sundayMorning = DateTime(2026, 9, 27, 8);

  Reminder fasting({int minutes = 6 * 60, int daysMask = Reminder.everyDay}) =>
      Reminder(
        id: 1,
        label: 'Cek gula darah puasa',
        timeOfMinutes: minutes,
        readingType: ReadingType.fasting,
        daysMask: daysMask,
      );

  ScheduledNotification onWeekday(
    List<ScheduledNotification> result,
    int weekday,
  ) => result.singleWhere((n) => n.weekday == weekday);

  group('Hari aktif (PRD F-07 AC1)', () {
    test('pengingat harian dipecah menjadi 7 jadwal mingguan', () {
      final result = plan(reminders: [fasting()], now: sundayMorning);

      expect(result, hasLength(7));
      expect(result.map((n) => n.weekday).toSet(), {1, 2, 3, 4, 5, 6, 7});
      expect(
        result.map((n) => n.id).toSet(),
        hasLength(7),
        reason: 'ID notifikasi tidak boleh bertabrakan',
      );
    });

    test('hanya hari yang dipilih di days_mask yang dijadwalkan', () {
      // Bit 0 = Senin, bit 2 = Rabu.
      final result = plan(
        reminders: [fasting(daysMask: 0x05)],
        now: sundayMorning,
      );

      expect(result.map((n) => n.weekday), [1, 3]);
      expect(result.map((n) => n.id), [11, 13]);
    });

    test('jam yang sudah lewat hari ini digeser ke minggu depan', () {
      final result = plan(reminders: [fasting()], now: sundayMorning);

      expect(
        onWeekday(result, DateTime.sunday).firstFireAt,
        DateTime(2026, 10, 4, 6),
      );
      expect(
        onWeekday(result, DateTime.monday).firstFireAt,
        DateTime(2026, 9, 28, 6),
      );
    });

    test('jam yang belum lewat hari ini tetap berbunyi hari ini', () {
      final result = plan(
        reminders: [fasting(minutes: 9 * 60)],
        now: sundayMorning,
      );

      expect(
        onWeekday(result, DateTime.sunday).firstFireAt,
        DateTime(2026, 9, 27, 9),
      );
    });

    test('jam yang sama persis dengan sekarang dianggap sudah lewat', () {
      final result = plan(
        reminders: [fasting(minutes: 8 * 60)],
        now: sundayMorning,
      );

      expect(
        onWeekday(result, DateTime.sunday).firstFireAt,
        DateTime(2026, 10, 4, 8),
      );
    });

    test('pergantian bulan dan tahun tetap benar', () {
      final result = plan(
        reminders: [fasting()],
        now: DateTime(2026, 12, 31, 7), // Kamis
      );

      expect(
        onWeekday(result, DateTime.friday).firstFireAt,
        DateTime(2027, 1, 1, 6),
      );
      expect(
        onWeekday(result, DateTime.thursday).firstFireAt,
        DateTime(2027, 1, 7, 6),
      );
    });

    test('pengingat nonaktif atau belum tersimpan tidak dijadwalkan', () {
      final result = plan(
        reminders: [
          fasting().copyWith(isActive: false),
          const Reminder(label: 'Belum disimpan', timeOfMinutes: 600),
        ],
        now: sundayMorning,
      );

      expect(result, isEmpty);
    });

    test('hasil diurutkan dari yang paling dekat', () {
      final result = plan(reminders: [fasting()], now: sundayMorning);

      for (var i = 1; i < result.length; i++) {
        expect(
          result[i].firstFireAt.isAfter(result[i - 1].firstFireAt),
          isTrue,
        );
      }
    });
  });

  group('Lewati pengingat puasa (PRD F-07 AC4)', () {
    test('GDP hari ini sudah tercatat → kemunculan hari ini dilewati', () {
      final result = plan(
        reminders: [fasting(minutes: 9 * 60)],
        now: sundayMorning,
        fastingLoggedDates: {'2026-09-27'},
      );

      expect(
        onWeekday(result, DateTime.sunday).firstFireAt,
        DateTime(2026, 10, 4, 9),
      );
      expect(
        onWeekday(result, DateTime.monday).firstFireAt,
        DateTime(2026, 9, 28, 9),
        reason: 'hari lain tidak terpengaruh',
      );
    });

    test('pengingat selain puasa tidak dilewati', () {
      final result = plan(
        reminders: [
          const Reminder(
            id: 2,
            label: 'Cek sewaktu',
            timeOfMinutes: 9 * 60,
            readingType: ReadingType.random,
          ),
        ],
        now: sundayMorning,
        fastingLoggedDates: {'2026-09-27'},
      );

      expect(
        onWeekday(result, DateTime.sunday).firstFireAt,
        DateTime(2026, 9, 27, 9),
      );
    });
  });

  group('Deep link (PRD F-07 AC3)', () {
    test('payload membuka form catat dengan tipe terisi', () {
      final result = plan(reminders: [fasting()], now: sundayMorning);

      expect(result.first.payload, '/catat?type=fasting');
      expect(result.first.title, contains('puasa'));
    });

    test('pengingat tanpa tipe membuka form catat biasa', () {
      final result = plan(
        reminders: [
          const Reminder(id: 3, label: 'Cek malam', timeOfMinutes: 21 * 60),
        ],
        now: sundayMorning,
      );

      expect(result.first.payload, '/catat');
      expect(result.first.title, 'Cek malam');
    });

    test('payload 2 jam PP memakai nilai database', () {
      expect(
        PlanReminderSchedule.payloadFor(ReadingType.postprandial2h),
        '/catat?type=postprandial_2h',
      );
    });
  });
}
