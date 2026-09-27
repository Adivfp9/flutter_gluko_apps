import 'dart:async';

import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/features/glucose/data/repositories/glucose_repository_impl.dart';
import 'package:flutter_gluko_apps/features/reminder/data/repositories/reminder_repository_impl.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/entities/scheduled_notification.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/services/notification_scheduler.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/usecases/plan_reminder_schedule.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/usecases/reminder_sync.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/test_database.dart';

/// Mencatat jadwal terakhir yang diminta, tanpa menyentuh plugin Android.
class FakeScheduler implements NotificationScheduler {
  List<ScheduledNotification>? last;

  @override
  Future<void> replaceAll(List<ScheduledNotification> notifications) async {
    last = notifications;
  }

  @override
  Future<void> initialize() async {}

  @override
  Future<NotificationPermissionStatus> permissionStatus() async =>
      const NotificationPermissionStatus(
        notificationsEnabled: true,
        exactAlarms: true,
      );

  @override
  Future<NotificationPermissionStatus> requestPermissions() =>
      permissionStatus();

  @override
  Future<String?> takeLaunchPayload() async => null;

  @override
  Stream<String> get taps => const Stream.empty();
}

void main() {
  late AppDatabase db;
  late FakeScheduler scheduler;
  late ReminderSync sync;
  late DateTime now;

  setUp(() {
    db = createTestDatabase();
    scheduler = FakeScheduler();
    // Minggu, 27 September 2026 pukul 05.00 — sebelum pengingat puasa
    // bawaan (06.00) berbunyi.
    now = DateTime(2026, 9, 27, 5);
    sync = ReminderSync(
      ReminderRepositoryImpl(db.reminderDao),
      GlucoseRepositoryImpl(db.glucoseDao),
      scheduler,
      const PlanReminderSchedule(),
    )..clock = () => now;
  });

  tearDown(() async {
    await sync.stop();
    await db.close();
  });

  /// Menunggu sampai jadwal terakhir memenuhi [condition].
  Future<void> eventually(
    bool Function(List<ScheduledNotification>) condition,
  ) async {
    final deadline = DateTime.now().add(const Duration(seconds: 5));
    while (DateTime.now().isBefore(deadline)) {
      await sync.idle;
      final last = scheduler.last;
      if (last != null && condition(last)) return;
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    fail('Jadwal tidak mencapai kondisi yang diharapkan: ${scheduler.last}');
  }

  DateTime? fireOn(List<ScheduledNotification> plan, int weekday) => plan
      .where((n) => n.weekday == weekday)
      .map((n) => n.firstFireAt)
      .firstOrNull;

  DateTime? sundayFire(List<ScheduledNotification> plan) =>
      fireOn(plan, DateTime.sunday);

  /// GDP pukul 04.30 WIB pada [localDate].
  Future<int> seedFasting(String localDate) {
    final date = DateTime.parse(localDate);
    return db.glucoseDao.insertReading(
      readingCompanion(
        localDate: localDate,
        measuredAt: DateTime.utc(
          date.year,
          date.month,
          date.day,
          4,
          30,
        ).subtract(const Duration(minutes: 420)),
      ),
      [],
    );
  }

  test('pengingat puasa bawaan terjadwal setiap hari', () async {
    sync.start();
    await eventually((plan) => plan.length == 7);

    expect(sundayFire(scheduler.last!), DateTime(2026, 9, 27, 6));
    expect(scheduler.last!.first.payload, '/catat?type=fasting');
  });

  test('GDP tersimpan melewati pengingat puasa hari ini (F-07 AC4)', () async {
    sync.start();
    await eventually((plan) => sundayFire(plan) == DateTime(2026, 9, 27, 6));

    await seedFasting('2026-09-27');

    await eventually((plan) => sundayFire(plan) == DateTime(2026, 10, 4, 6));
  });

  test('GDP dihapus mengembalikan pengingat hari ini', () async {
    final id = await seedFasting('2026-09-27');
    sync.start();
    await eventually((plan) => sundayFire(plan) == DateTime(2026, 10, 4, 6));

    await db.glucoseDao.softDelete(id, DateTime.utc(2026, 9, 26, 22));

    await eventually((plan) => sundayFire(plan) == DateTime(2026, 9, 27, 6));
  });

  test('GDP kemarin tidak memengaruhi pengingat hari ini', () async {
    await seedFasting('2026-09-26');
    sync.start();

    await eventually((plan) => sundayFire(plan) == DateTime(2026, 9, 27, 6));
  });

  test('menonaktifkan pengingat mengosongkan jadwal', () async {
    sync.start();
    await eventually((plan) => plan.isNotEmpty);

    final reminders = await db.reminderDao.all();
    await db.reminderDao.setActive(reminders.first.id, isActive: false);

    await eventually((plan) => plan.isEmpty);
  });

  test('refresh setelah ganti hari memakai tanggal baru', () async {
    await seedFasting('2026-09-27');
    sync.start();
    await eventually((plan) => sundayFire(plan) == DateTime(2026, 10, 4, 6));

    // Senin pagi: jadwal Senin 06.00 hari ini, dan GDP Minggu tidak lagi
    // menggeser apa pun karena kemunculan Minggu berikutnya sudah seminggu
    // lagi.
    now = DateTime(2026, 9, 28, 5);
    sync.refresh();

    await eventually(
      (plan) => fireOn(plan, DateTime.monday) == DateTime(2026, 9, 28, 6),
    );
    expect(sundayFire(scheduler.last!), DateTime(2026, 10, 4, 6));
  });
}
