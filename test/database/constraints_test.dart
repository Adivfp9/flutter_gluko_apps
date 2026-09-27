import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/common.dart';

import '../helpers/fixtures.dart';
import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = createTestDatabase());
  tearDown(() => db.close());

  group('CHECK constraint glucose_readings', () {
    test('menolak nilai di bawah 20 mg/dL', () {
      expect(
        () => db.glucoseDao.insertReading(readingCompanion(valueMgDl: 19), []),
        throwsA(isA<SqliteException>()),
      );
    });

    test('menolak nilai di atas 600 mg/dL', () {
      expect(
        () => db.glucoseDao.insertReading(readingCompanion(valueMgDl: 601), []),
        throwsA(isA<SqliteException>()),
      );
    });

    test('menerima nilai tepat di batas 20 dan 600', () async {
      await db.glucoseDao.insertReading(
        readingCompanion(valueMgDl: 20, localDate: '2026-09-01'),
        [],
      );
      await db.glucoseDao.insertReading(
        readingCompanion(
          valueMgDl: 600,
          localDate: '2026-09-02',
          type: ReadingType.random,
        ),
        [],
      );
      expect(await db.glucoseDao.countActive(), 2);
    });

    test('menolak catatan lebih dari 500 karakter', () {
      expect(
        () =>
            db.glucoseDao.insertReading(readingCompanion(note: 'a' * 501), []),
        throwsA(isA<SqliteException>()),
      );
    });

    test('menerima catatan tepat 500 karakter', () async {
      await db.glucoseDao.insertReading(readingCompanion(note: 'a' * 500), []);
      expect(await db.glucoseDao.countActive(), 1);
    });

    test('menolak reading_type di luar tiga nilai yang sah', () {
      expect(
        () => db.glucoseDao.insertReading(
          readingCompanion().copyWith(readingType: const Value('after_meal')),
          [],
        ),
        throwsA(isA<SqliteException>()),
      );
    });

    test('menolak status di luar empat nilai yang sah', () {
      expect(
        () => db.glucoseDao.insertReading(
          readingCompanion().copyWith(status: const Value('critical')),
          [],
        ),
        throwsA(isA<SqliteException>()),
      );
    });
  });

  group('Indeks unik ux_fasting_per_day (PRD 5.5)', () {
    test('menolak GDP kedua pada tanggal lokal yang sama', () async {
      await db.glucoseDao.insertReading(
        readingCompanion(localDate: '2026-09-26'),
        [],
      );

      expect(
        () => db.glucoseDao.insertReading(
          readingCompanion(localDate: '2026-09-26', valueMgDl: 101),
          [],
        ),
        throwsA(isA<SqliteException>()),
      );
    });

    test('mengizinkan GDP pada tanggal berbeda', () async {
      await db.glucoseDao.insertReading(
        readingCompanion(localDate: '2026-09-26'),
        [],
      );
      await db.glucoseDao.insertReading(
        readingCompanion(localDate: '2026-09-27'),
        [],
      );
      expect(await db.glucoseDao.countActive(), 2);
    });

    test('mengizinkan banyak GDS pada tanggal yang sama', () async {
      for (var i = 0; i < 3; i++) {
        await db.glucoseDao.insertReading(
          readingCompanion(
            localDate: '2026-09-26',
            type: ReadingType.random,
            valueMgDl: 120 + i,
          ),
          [],
        );
      }
      expect(await db.glucoseDao.countActive(), 3);
    });

    test('GDP yang sudah di-soft delete membebaskan slot hari itu', () async {
      final id = await db.glucoseDao.insertReading(
        readingCompanion(localDate: '2026-09-26'),
        [],
      );
      await db.glucoseDao.softDelete(id, DateTime(2026, 9, 26, 10));

      // Indeks parsial hanya mencakup deleted_at IS NULL, jadi ini harus lolos.
      await db.glucoseDao.insertReading(
        readingCompanion(localDate: '2026-09-26', valueMgDl: 101),
        [],
      );
      expect(await db.glucoseDao.countActive(), 1);
    });

    test('Undo ditolak bila slot GDP hari itu sudah terisi lagi', () async {
      final first = await db.glucoseDao.insertReading(
        readingCompanion(localDate: '2026-09-26'),
        [],
      );
      await db.glucoseDao.softDelete(first, DateTime(2026, 9, 26, 10));
      await db.glucoseDao.insertReading(
        readingCompanion(localDate: '2026-09-26', valueMgDl: 101),
        [],
      );

      // Kasus yang dicatat sebagai B-4 di rencana implementasi: restore bisa
      // menabrak indeks unik, dan itu harus gagal keras, bukan diam-diam
      // menghasilkan dua GDP pada hari yang sama.
      expect(
        () => db.glucoseDao.restore(first),
        throwsA(isA<SqliteException>()),
      );
    });
  });

  group('CHECK constraint target_ranges (PRD F-03 AC2)', () {
    test('menolak ambang yang tidak berurutan', () {
      expect(
        () => db.targetDao.upsert(
          TargetRangesTableCompanion.insert(
            readingType: ReadingType.fasting.dbValue,
            lowMax: 140,
            normalMax: 99,
            warningMax: 125,
            updatedAt: 0,
          ),
        ),
        throwsA(isA<SqliteException>()),
      );
    });

    test('upsert memperbarui baris, bukan menambah baris keempat', () async {
      await db.targetDao.upsert(
        TargetRangesTableCompanion.insert(
          readingType: ReadingType.fasting.dbValue,
          lowMax: 70,
          normalMax: 130,
          warningMax: 180,
          updatedAt: 123,
        ),
      );

      final all = await db.targetDao.all();
      expect(all.length, 3);
      final fasting = all.firstWhere(
        (t) => t.readingType == ReadingType.fasting.dbValue,
      );
      expect(fasting.normalMax, 130);
      expect(fasting.updatedAt, 123);
    });
  });

  group('Gejala', () {
    test('tersimpan dan terbaca kembali bersama pembacaan', () async {
      final id = await db.glucoseDao.insertReading(readingCompanion(), [
        Symptom.dizzy.dbValue,
        Symptom.weak.dbValue,
      ]);

      final saved = await db.glucoseDao.findById(id);
      expect(saved!.symptoms..sort(), ['dizzy', 'weak']);
    });

    test('ikut terhapus saat pembacaan dihapus permanen (cascade)', () async {
      final id = await db.glucoseDao.insertReading(readingCompanion(), [
        Symptom.dizzy.dbValue,
      ]);
      await db.glucoseDao.hardDelete(id);

      final rows = await db.select(db.readingSymptomsTable).get();
      expect(rows, isEmpty);
    });

    test('gejala duplikat hanya disimpan sekali', () async {
      final id = await db.glucoseDao.insertReading(readingCompanion(), [
        Symptom.dizzy.dbValue,
        Symptom.dizzy.dbValue,
      ]);
      final saved = await db.glucoseDao.findById(id);
      expect(saved!.symptoms, ['dizzy']);
    });
  });

  group('Purge soft delete (PRD 8.4)', () {
    test('menghapus permanen baris yang dihapus lebih dari 30 hari', () async {
      final old = await db.glucoseDao.insertReading(
        readingCompanion(localDate: '2026-07-01'),
        [],
      );
      final recent = await db.glucoseDao.insertReading(
        readingCompanion(localDate: '2026-09-20', type: ReadingType.random),
        [],
      );

      await db.glucoseDao.softDelete(old, DateTime(2026, 8, 1));
      await db.glucoseDao.softDelete(recent, DateTime(2026, 9, 20));

      final purged = await db.purgeDeletedOlderThan(now: DateTime(2026, 9, 26));

      expect(purged, 1);
      expect(await db.glucoseDao.findRowById(old), isNull);
      expect(await db.glucoseDao.findRowById(recent), isNotNull);
    });

    test('tidak menyentuh baris yang masih aktif', () async {
      await db.glucoseDao.insertReading(readingCompanion(), []);
      final purged = await db.purgeDeletedOlderThan(now: DateTime(2030));
      expect(purged, 0);
      expect(await db.glucoseDao.countActive(), 1);
    });
  });
}
