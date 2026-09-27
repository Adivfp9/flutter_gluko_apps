import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/features/security/data/repositories/security_repository_impl.dart';
import 'package:flutter_gluko_apps/features/security/domain/repositories/security_repository.dart';
import 'package:flutter_gluko_apps/features/security/domain/services/pin_hasher.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_database.dart';
import 'security_fakes.dart';

void main() {
  // Iterasi kecil: yang diuji alurnya, bukan kekuatan KDF.
  final hasher = PinHasher.withIterations(1000);

  group('PinHasher', () {
    test('PIN yang sama terverifikasi, PIN lain ditolak', () async {
      final stored = await hasher.hash('123456');

      expect(await hasher.verify('123456', stored), isTrue);
      expect(await hasher.verify('123457', stored), isFalse);
      expect(await hasher.verify('', stored), isFalse);
    });

    test('salt acak: PIN sama menghasilkan hash berbeda', () async {
      final a = await hasher.hash('123456');
      final b = await hasher.hash('123456');

      expect(a, isNot(b));
      expect(await hasher.verify('123456', b), isTrue);
    });

    test('PIN tidak pernah tersimpan sebagai teks biasa', () async {
      final stored = await hasher.hash('246810');

      expect(stored, isNot(contains('246810')));
      expect(stored, startsWith(r'pbkdf2-sha256$1000$'));
    });

    test('hash dengan iterasi berbeda tetap bisa diverifikasi', () async {
      final old = await PinHasher.withIterations(500).hash('111111');

      expect(await hasher.verify('111111', old), isTrue);
    });

    test('format rusak ditolak tanpa exception', () async {
      for (final corrupt in [
        '',
        'abc',
        r'md5$1000$AAAA$BBBB',
        r'pbkdf2-sha256$x$AAAA$BBBB',
        r'pbkdf2-sha256$1000$%%%$BBBB',
        r'pbkdf2-sha256$0$AAAA$BBBB',
      ]) {
        expect(
          await hasher.verify('123456', corrupt),
          isFalse,
          reason: corrupt,
        );
      }
    });

    test('hanya tepat 6 digit angka yang valid (PRD F-08 AC1)', () {
      expect(PinHasher.isValidPin('123456'), isTrue);
      expect(PinHasher.isValidPin('000000'), isTrue);
      expect(PinHasher.isValidPin('12345'), isFalse);
      expect(PinHasher.isValidPin('1234567'), isFalse);
      expect(PinHasher.isValidPin('12a456'), isFalse);
      expect(PinHasher.isValidPin('12 456'), isFalse);
    });
  });

  group('PinAttemptPolicy', () {
    test('lima kesalahan pertama tanpa jeda', () {
      for (var i = 0; i < 5; i++) {
        expect(PinAttemptPolicy.cooldownAfter(i), isNull);
      }
    });

    test('jeda 30 detik berlipat dua, maksimal 15 menit', () {
      expect(PinAttemptPolicy.cooldownAfter(5), const Duration(seconds: 30));
      expect(PinAttemptPolicy.cooldownAfter(6), const Duration(minutes: 1));
      expect(PinAttemptPolicy.cooldownAfter(7), const Duration(minutes: 2));
      expect(PinAttemptPolicy.cooldownAfter(10), const Duration(minutes: 15));
      expect(PinAttemptPolicy.cooldownAfter(100), const Duration(minutes: 15));
    });
  });

  group('SecurityRepository', () {
    late AppDatabase db;
    late FakeSecretStore secrets;
    late SecurityRepositoryImpl repository;
    final t0 = DateTime(2026, 9, 27, 10);

    setUp(() {
      db = createTestDatabase();
      secrets = FakeSecretStore();
      repository = SecurityRepositoryImpl(db.settingsDao, secrets, hasher);
    });

    tearDown(() => db.close());

    test('kunci mati secara bawaan', () async {
      expect(await repository.load(), LockSettings.disabled);
    });

    test(
      'mengaktifkan kunci menyimpan hash di Keystore, bukan di DB',
      () async {
        await repository.enableLock('123456');

        final settings = await repository.load();
        expect(settings.lockEnabled, isTrue);
        expect(secrets.values[SettingKeys.pinHash], isNotNull);
        expect(await db.settingsDao.read(SettingKeys.pinHash), isNull);
      },
    );

    test('PIN tidak valid ditolak saat disimpan', () async {
      await expectLater(repository.enableLock('12345'), throwsArgumentError);
      expect((await repository.load()).lockEnabled, isFalse);
    });

    test('PIN benar lolos dan PIN salah ditolak', () async {
      await repository.enableLock('123456');

      final ok = await repository.verifyPin('123456', now: t0);
      final wrong = await repository.verifyPin('000000', now: t0);

      expect(ok.outcome, PinCheckOutcome.success);
      expect(wrong.outcome, PinCheckOutcome.wrong);
      expect(wrong.failedAttempts, 1);
    });

    test('kesalahan kelima memicu jeda, PIN benar pun ditahan', () async {
      await repository.enableLock('123456');

      var last = const PinCheck(outcome: PinCheckOutcome.wrong);
      for (var i = 0; i < 5; i++) {
        last = await repository.verifyPin('000000', now: t0);
      }
      expect(last.lockedUntil, t0.add(const Duration(seconds: 30)));

      final blocked = await repository.verifyPin(
        '123456',
        now: t0.add(const Duration(seconds: 10)),
      );
      expect(blocked.outcome, PinCheckOutcome.coolingDown);

      final after = await repository.verifyPin(
        '123456',
        now: t0.add(const Duration(seconds: 31)),
      );
      expect(after.outcome, PinCheckOutcome.success);
    });

    test('penghitung percobaan bertahan antar sesi aplikasi', () async {
      await repository.enableLock('123456');
      for (var i = 0; i < 4; i++) {
        await repository.verifyPin('000000', now: t0);
      }

      // Instance baru = aplikasi dibuka ulang; penghitung ada di database.
      final reopened = SecurityRepositoryImpl(db.settingsDao, secrets, hasher);
      final fifth = await reopened.verifyPin('000000', now: t0);

      expect(fifth.failedAttempts, 5);
      expect(fifth.lockedUntil, isNotNull);
    });

    test('PIN benar mereset penghitung percobaan', () async {
      await repository.enableLock('123456');
      await repository.verifyPin('000000', now: t0);
      await repository.verifyPin('123456', now: t0);

      final next = await repository.verifyPin('000000', now: t0);
      expect(next.failedAttempts, 1);
    });

    test('mematikan kunci menghapus PIN dan biometrik', () async {
      await repository.enableLock('123456');
      await repository.setBiometricEnabled(enabled: true);

      await repository.disableLock();

      expect(await repository.load(), LockSettings.disabled);
      expect(secrets.values, isEmpty);
    });

    test('kunci aktif tanpa PIN di Keystore dianggap mati', () async {
      await repository.enableLock('123456');
      secrets.values.clear();

      expect(
        (await repository.load()).lockEnabled,
        isFalse,
        reason: 'pengguna tidak boleh terkurung di layar kunci tanpa PIN',
      );
    });

    test('ganti PIN: PIN lama tidak berlaku lagi', () async {
      await repository.enableLock('123456');
      await repository.changePin('654321');

      expect(
        (await repository.verifyPin('123456', now: t0)).isSuccess,
        isFalse,
      );
      expect((await repository.verifyPin('654321', now: t0)).isSuccess, isTrue);
    });
  });
}
