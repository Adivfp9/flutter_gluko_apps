import 'dart:convert';

import 'package:drift/drift.dart' hide isNull;
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/database/database_snapshot.dart';
import 'package:flutter_gluko_apps/features/backup/domain/backup_codec.dart';
import 'package:flutter_gluko_apps/features/backup/domain/backup_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/test_database.dart';

void main() {
  // Iterasi kecil: yang diuji format dan alurnya, bukan kekuatan KDF.
  final codec = BackupCodec.withIterations(1000);
  const passphrase = 'kopi-pagi-2026';
  final createdAt = DateTime.utc(2026, 9, 27, 3);

  BackupService serviceFor(AppDatabase db) =>
      BackupService(db, DatabaseSnapshot(db), codec, db.settingsDao);

  /// Data yang mewakili pemakaian nyata: profil, target kustom, pembacaan
  /// dengan gejala dan catatan Unicode, baris soft delete, pengingat, dan
  /// setelan.
  Future<void> seedRealisticData(AppDatabase db) async {
    final now = DateTime.utc(2026, 9, 20).millisecondsSinceEpoch;
    await db.profileDao.save(
      UserProfileTableCompanion.insert(
        name: const Value('Budi Contoh'),
        birthYear: const Value(1970),
        unit: const Value('mmol_l'),
        onboardingDone: const Value(true),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await (db.update(db.targetRangesTable)
          ..where((t) => t.readingType.equals('fasting')))
        .write(const TargetRangesTableCompanion(normalMax: Value(110)));

    await db.glucoseDao.insertReading(
      readingCompanion(
        localDate: '2026-09-25',
        note: 'Sesudah jalan pagi — terasa pusing 😵',
        mealContext: MealContext.afterMeal,
        hoursAfterMeal: 2.5,
        type: ReadingType.postprandial2h,
        valueMgDl: 182,
        status: GlucoseStatus.high,
      ),
      ['dizzy', 'thirsty'],
    );
    await db.glucoseDao.insertReading(
      readingCompanion(localDate: '2026-09-26', valueMgDl: 97),
      [],
    );
    final deleted = await db.glucoseDao.insertReading(
      readingCompanion(
        localDate: '2026-09-24',
        type: ReadingType.random,
        valueMgDl: 140,
      ),
      [],
    );
    await db.glucoseDao.softDelete(deleted, DateTime.utc(2026, 9, 26));

    await db.reminderDao.insertReminder(
      RemindersTableCompanion.insert(
        label: 'Cek malam',
        timeOfMinutes: 21 * 60,
        daysMask: const Value(0x1F),
        createdAt: now,
      ),
    );
    await db.settingsDao.write(SettingKeys.themeMode, 'dark');
  }

  Matcher backupError(BackupErrorKind kind) =>
      throwsA(isA<BackupException>().having((e) => e.kind, 'kind', kind));

  group('BackupCodec', () {
    Future<Uint8List> sample({int schema = 1}) => codec.encode(
      tables: {
        'app_settings': [
          {'key': 'theme_mode', 'value': 'dark'},
        ],
      },
      schemaVersion: schema,
      passphrase: passphrase,
      createdAt: createdAt,
    );

    test('passphrase yang sama membuka kembali isinya', () async {
      final bytes = await sample();
      final contents = await codec.decode(
        bytes,
        passphrase: passphrase,
        currentSchemaVersion: 1,
      );

      expect(contents.header.createdAt, createdAt);
      expect(contents.tables['app_settings']!.single['value'], 'dark');
    });

    test('isi tidak terbaca tanpa passphrase', () async {
      final bytes = await sample();

      expect(
        utf8.decode(bytes, allowMalformed: true),
        isNot(contains('theme_mode')),
      );
    });

    test('passphrase salah ditolak dengan pesan yang tepat', () async {
      await expectLater(
        codec.decode(
          await sample(),
          passphrase: 'salah-total',
          currentSchemaVersion: 1,
        ),
        backupError(BackupErrorKind.wrongPassphrase),
      );
    });

    test('satu byte berubah terdeteksi sebagai file rusak', () async {
      final bytes = await sample();
      bytes[bytes.length - 1] ^= 0xFF;

      await expectLater(
        codec.decode(bytes, passphrase: passphrase, currentSchemaVersion: 1),
        backupError(BackupErrorKind.corrupted),
      );
    });

    test('file terpotong terdeteksi sebagai rusak', () async {
      final bytes = await sample();

      await expectLater(
        codec.decode(
          Uint8List.sublistView(bytes, 0, 20),
          passphrase: passphrase,
          currentSchemaVersion: 1,
        ),
        backupError(BackupErrorKind.corrupted),
      );
    });

    test('file lain ditolak sebagai bukan backup', () {
      final notBackup = Uint8List.fromList(utf8.encode('%PDF-1.7 bukan'));

      expect(
        () => codec.readHeader(notBackup),
        backupError(BackupErrorKind.notBackup),
      );
    });

    test('backup dari skema lebih baru ditolak (rencana 4.6)', () async {
      await expectLater(
        codec.decode(
          await sample(schema: 2),
          passphrase: passphrase,
          currentSchemaVersion: 1,
        ),
        backupError(BackupErrorKind.newerVersion),
      );
    });

    test('header bisa dibaca tanpa passphrase', () async {
      final header = codec.readHeader(await sample());

      expect(header.schemaVersion, 1);
      expect(header.createdAt, createdAt);
    });

    test('passphrase minimal 8 karakter', () {
      expect(BackupCodec.isAcceptablePassphrase('1234567'), isFalse);
      expect(BackupCodec.isAcceptablePassphrase('12345678'), isTrue);
    });
  });

  group('Gate Sprint 4: backup → wipe → restore = data identik', () {
    late AppDatabase db;

    setUp(() => db = createTestDatabase());
    tearDown(() => db.close());

    test('seluruh tabel kembali persis sama', () async {
      await seedRealisticData(db);
      final snapshot = DatabaseSnapshot(db);
      final before = await snapshot.export();
      final file = await serviceFor(db).create(passphrase, now: createdAt);

      await db.wipeAllData();
      expect(await db.profileDao.find(), isNull);

      final service = serviceFor(db);
      await service.restore(await service.open(file.bytes, passphrase));

      expect(await snapshot.export(), before);
    });

    test('bisa dipulihkan di database lain (HP baru)', () async {
      await seedRealisticData(db);
      final before = await DatabaseSnapshot(db).export();
      final file = await serviceFor(db).create(passphrase, now: createdAt);

      final newPhone = createTestDatabase();
      addTearDown(newPhone.close);
      final service = serviceFor(newPhone);
      await service.restore(await service.open(file.bytes, passphrase));

      expect(await DatabaseSnapshot(newPhone).export(), before);
      expect((await newPhone.profileDao.find())!.name, 'Budi Contoh');
    });

    test('setelan perangkat tidak ikut ter-backup maupun tertimpa', () async {
      await seedRealisticData(db);
      await db.settingsDao.writeBool(SettingKeys.lockEnabled, value: true);
      final file = await serviceFor(db).create(passphrase, now: createdAt);

      final newPhone = createTestDatabase();
      addTearDown(newPhone.close);
      final lastBackup = DateTime(2026, 9, 1);
      await newPhone.settingsDao.writeDateTime(
        SettingKeys.lastBackupAt,
        lastBackup,
      );

      final service = serviceFor(newPhone);
      await service.restore(await service.open(file.bytes, passphrase));

      expect(
        await newPhone.settingsDao.read(SettingKeys.lockEnabled),
        isNull,
        reason: 'hash PIN tidak ikut backup; kunci aktif tanpa PIN = terkurung',
      );
      expect(
        await newPhone.settingsDao.readDateTime(SettingKeys.lastBackupAt),
        lastBackup,
      );
      expect(await newPhone.settingsDao.read(SettingKeys.themeMode), 'dark');
    });

    test('ringkasan tidak menghitung catatan yang sudah dihapus', () async {
      await seedRealisticData(db);
      final service = serviceFor(db);
      final file = await service.create(passphrase, now: createdAt);

      final preview = await service.open(file.bytes, passphrase);

      expect(preview.readingCount, 2);
      expect(preview.reminderCount, 2);
    });

    test('restore gagal di tengah jalan tidak menyentuh data lama', () async {
      await seedRealisticData(db);
      final snapshot = DatabaseSnapshot(db);
      final before = await snapshot.export();

      final broken = {
        ...before,
        'reminders': [
          {'id': 99, 'kolom_asing': 'x'},
        ],
      };

      await expectLater(snapshot.replaceAll(broken), throwsFormatException);
      expect(await snapshot.export(), before);
    });

    test('passphrase salah tidak mengubah apa pun', () async {
      await seedRealisticData(db);
      final before = await DatabaseSnapshot(db).export();
      final file = await serviceFor(db).create(passphrase, now: createdAt);

      await expectLater(
        serviceFor(db).open(file.bytes, 'bukan-ini-ya'),
        throwsA(isA<BackupException>()),
      );
      expect(await DatabaseSnapshot(db).export(), before);
    });

    test('backup ditandai hanya lewat markBackedUp', () async {
      final service = serviceFor(db);
      await service.create(passphrase, now: createdAt);
      expect(await db.settingsDao.read(SettingKeys.lastBackupAt), isNull);

      await service.markBackedUp(createdAt);
      expect(
        await db.settingsDao.readDateTime(SettingKeys.lastBackupAt),
        createdAt.toLocal(),
      );
    });
  });

  group('Pengingat backup (PRD F-09 AC3)', () {
    final now = DateTime(2026, 9, 27);

    test('belum pernah backup → diingatkan', () {
      expect(needsBackupNudge(null, now), isTrue);
    });

    test('30 hari tepat belum diingatkan, 31 hari diingatkan', () {
      expect(
        needsBackupNudge(now.subtract(const Duration(days: 30)), now),
        isFalse,
      );
      expect(
        needsBackupNudge(now.subtract(const Duration(days: 31)), now),
        isTrue,
      );
    });
  });
}
