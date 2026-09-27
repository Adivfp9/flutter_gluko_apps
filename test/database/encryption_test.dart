import 'dart:convert';
import 'dart:io';

import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/database/connection/database_key_store.dart';
import 'package:flutter_gluko_apps/database/connection/encrypted_connection.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fixtures.dart';

/// Gate Sprint 1 / NFR-05 dan risiko §7: SQLCipher salah konfigurasi akan
/// membuka database tanpa enkripsi tanpa gejala apa pun. Test ini membaca
/// berkas mentah untuk memastikan isinya benar-benar terenkripsi.
void main() {
  late Directory dir;
  late File file;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('glukotrack_enc_');
    file = File('${dir.path}/glukotrack.db');
  });

  tearDown(() {
    try {
      dir.deleteSync(recursive: true);
    } on FileSystemException {
      // Windows kadang masih memegang handle sesaat setelah close.
    }
  });

  Future<void> writeSample(String keyHex) async {
    final db = AppDatabase(openEncryptedFile(file, keyHex));
    await db.glucoseDao.insertReading(
      readingCompanion(note: 'catatan-rahasia-unik'),
      [],
    );
    await db.close();
  }

  test('berkas di disk bukan SQLite polos', () async {
    await writeSample(DatabaseKeyStore.generateKeyHex());

    final bytes = file.readAsBytesSync();
    expect(bytes, isNotEmpty);
    expect(
      ascii.decode(bytes.sublist(0, 15), allowInvalid: true),
      isNot('SQLite format 3'),
      reason: 'header SQLite polos berarti SQLCipher tidak aktif',
    );
    expect(
      latin1.decode(bytes),
      isNot(contains('catatan-rahasia-unik')),
      reason: 'isi catatan tidak boleh terbaca dari berkas mentah',
    );
  });

  test('kunci yang sama membuka kembali datanya', () async {
    final key = DatabaseKeyStore.generateKeyHex();
    await writeSample(key);

    final db = AppDatabase(openEncryptedFile(file, key));
    addTearDown(db.close);
    final rows = await db.select(db.glucoseReadingsTable).get();

    expect(rows.single.note, 'catatan-rahasia-unik');
  });

  test('kunci lain ditolak', () async {
    await writeSample(DatabaseKeyStore.generateKeyHex());

    final db = AppDatabase(
      openEncryptedFile(file, DatabaseKeyStore.generateKeyHex()),
    );
    addTearDown(db.close);

    await expectLater(
      db.select(db.glucoseReadingsTable).get(),
      throwsA(anything),
    );
  });

  test('kunci acak 256-bit dalam hex', () {
    final a = DatabaseKeyStore.generateKeyHex();
    final b = DatabaseKeyStore.generateKeyHex();

    expect(a, matches(RegExp(r'^[0-9a-f]{64}$')));
    expect(a, isNot(b));
  });
}
