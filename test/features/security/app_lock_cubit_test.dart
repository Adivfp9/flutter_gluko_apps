import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/features/glucose/data/repositories/glucose_repository_impl.dart';
import 'package:flutter_gluko_apps/features/reminder/data/repositories/reminder_repository_impl.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/usecases/plan_reminder_schedule.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/usecases/reminder_sync.dart';
import 'package:flutter_gluko_apps/features/security/data/repositories/security_repository_impl.dart';
import 'package:flutter_gluko_apps/features/security/domain/services/pin_hasher.dart';
import 'package:flutter_gluko_apps/features/security/domain/usecases/reset_app_data.dart';
import 'package:flutter_gluko_apps/features/security/presentation/cubit/app_lock_cubit.dart';
import 'package:flutter_gluko_apps/features/security/presentation/cubit/app_lock_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/test_database.dart';
import 'security_fakes.dart';

void main() {
  late AppDatabase db;
  late FakeSecretStore secrets;
  late FakeBiometric biometric;
  late FakeSecureScreen secureScreen;
  late RecordingScheduler scheduler;
  late SecurityRepositoryImpl repository;
  late AppLockCubit cubit;

  final t0 = DateTime(2026, 9, 27, 10);

  setUp(() {
    db = createTestDatabase();
    secrets = FakeSecretStore();
    biometric = FakeBiometric();
    secureScreen = FakeSecureScreen();
    scheduler = RecordingScheduler();
    repository = SecurityRepositoryImpl(
      db.settingsDao,
      secrets,
      PinHasher.withIterations(1000),
    );
    final sync = ReminderSync(
      ReminderRepositoryImpl(db.reminderDao),
      GlucoseRepositoryImpl(db.glucoseDao),
      scheduler,
      const PlanReminderSchedule(),
    );
    cubit = AppLockCubit(
      repository,
      biometric,
      secureScreen,
      ResetAppData(db, repository, sync, scheduler),
    );
  });

  tearDown(() async {
    await cubit.close();
    await db.close();
  });

  group('Saat aplikasi dibuka (PRD F-08 AC2)', () {
    test('tanpa kunci langsung terbuka dan layar tidak diamankan', () async {
      await cubit.initialize();

      expect(cubit.state.status, LockStatus.unlocked);
      expect(secureScreen.secure, isFalse);
    });

    test('dengan kunci aktif mulai terkunci dan FLAG_SECURE menyala', () async {
      await repository.enableLock('123456');
      await cubit.initialize();

      expect(cubit.state.status, LockStatus.locked);
      expect(secureScreen.secure, isTrue, reason: 'PRD F-08 AC3');
    });
  });

  group('Membuka kunci', () {
    setUp(() async {
      await repository.enableLock('123456');
      await cubit.initialize();
    });

    test('PIN benar membuka kunci', () async {
      await cubit.submitPin('123456', now: t0);

      expect(cubit.state.status, LockStatus.unlocked);
      expect(cubit.state.errorMessage, isNull);
    });

    test('PIN salah tetap terkunci dengan pesan sisa percobaan', () async {
      await cubit.submitPin('000000', now: t0);

      expect(cubit.state.status, LockStatus.locked);
      expect(cubit.state.errorMessage, contains('Sisa 4 percobaan'));
    });

    test('kesalahan kelima menampilkan jeda', () async {
      for (var i = 0; i < 5; i++) {
        await cubit.submitPin('000000', now: t0);
      }

      expect(cubit.state.errorMessage, contains('30 detik'));
      expect(cubit.state.lockedUntil, isNotNull);
    });

    test('biometrik hanya dipakai bila diaktifkan di setelan', () async {
      await cubit.unlockWithBiometric();
      expect(biometric.prompts, 0);
      expect(cubit.state.status, LockStatus.locked);

      await repository.setBiometricEnabled(enabled: true);
      await cubit.reloadSettings();
      await cubit.unlockWithBiometric();

      expect(biometric.prompts, 1);
      expect(cubit.state.status, LockStatus.unlocked);
    });

    test('biometrik dibatalkan tetap terkunci', () async {
      await repository.setBiometricEnabled(enabled: true);
      await cubit.reloadSettings();
      biometric.succeed = false;

      await cubit.unlockWithBiometric();

      expect(cubit.state.status, LockStatus.locked);
    });
  });

  group('Auto-lock setelah di background (PRD F-08 AC2)', () {
    setUp(() async {
      await repository.enableLock('123456');
      await cubit.initialize();
      await cubit.submitPin('123456', now: t0);
    });

    test('kembali dalam 1 menit tetap terbuka', () {
      cubit
        ..onBackgrounded(t0)
        ..onForegrounded(t0.add(const Duration(seconds: 60)));

      expect(cubit.state.status, LockStatus.unlocked);
    });

    test('kembali setelah lebih dari 1 menit terkunci lagi', () {
      cubit
        ..onBackgrounded(t0)
        ..onForegrounded(t0.add(const Duration(seconds: 61)));

      expect(cubit.state.status, LockStatus.locked);
    });

    test('tanpa kunci aktif tidak pernah terkunci', () async {
      await repository.disableLock();
      await cubit.reloadSettings();

      cubit
        ..onBackgrounded(t0)
        ..onForegrounded(t0.add(const Duration(hours: 5)));

      expect(cubit.state.status, LockStatus.unlocked);
      expect(secureScreen.secure, isFalse);
    });
  });

  group('Lupa PIN (gate Sprint 4)', () {
    test('menghapus semua data, PIN, dan jadwal notifikasi', () async {
      await db.glucoseDao.insertReading(readingCompanion(), []);
      await repository.enableLock('123456');
      await cubit.initialize();

      await cubit.resetAppData();

      expect(cubit.state.status, LockStatus.unlocked);
      expect(cubit.state.resetDone, isTrue);
      expect(cubit.state.lockEnabled, isFalse);
      expect(secrets.values, isEmpty);
      expect(scheduler.last, isEmpty);
      expect(secureScreen.secure, isFalse);

      expect(await db.select(db.glucoseReadingsTable).get(), isEmpty);
      expect(await db.profileDao.find(), isNull, reason: 'onboarding diulang');
      expect((await repository.load()).lockEnabled, isFalse);
    });

    test('seed bawaan dibuat ulang seperti instalasi baru', () async {
      final seeded = await db.reminderDao.all();
      await db.reminderDao.deleteReminder(seeded.first.id);

      await cubit.resetAppData();

      expect(await db.reminderDao.all(), hasLength(1));
      expect(await db.select(db.targetRangesTable).get(), hasLength(3));
    });
  });
}
