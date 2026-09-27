import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

import 'generated/schema.dart';

/// Rencana 1.4 / 5.5: skema hasil `onCreate` harus sama persis dengan
/// snapshot `drift_schemas/app_database/drift_schema_v<N>.json`.
///
/// Test ini gagal bila tabel diubah tanpa menaikkan `schemaVersion` dan
/// menjalankan `dart run drift_dev make-migrations` — kesalahan yang membuat
/// pengguna lama kehilangan data setelah update. Saat skema v2 ada,
/// `make-migrations` akan menambahkan test migrasi v1 → v2 di folder ini.
void main() {
  late SchemaVerifier verifier;

  setUpAll(() => verifier = SchemaVerifier(GeneratedHelper()));

  test('instalasi baru menghasilkan skema snapshot terbaru', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await verifier.migrateAndValidate(db, db.schemaVersion);
  });

  test('snapshot terbaru sama dengan schemaVersion', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final latest = GeneratedHelper.versions.reduce((a, b) => a > b ? a : b);
    expect(
      latest,
      db.schemaVersion,
      reason: 'jalankan make-migrations setelah menaikkan schemaVersion',
    );
  });
}
