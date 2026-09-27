import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_gluko_apps/database/connection/database_key_store.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Nama berkas database di direktori dokumen aplikasi.
const String kDatabaseFileName = 'glukotrack.db';

/// Membuka database SQLCipher (NFR-05).
///
/// Varian SQLCipher dipilih lewat build hook `sqlite3` di `pubspec.yaml`
/// (`hooks.user_defines.sqlite3.source: sqlcipher`), jadi pustaka yang
/// ter-bundle memang sudah mendukung `PRAGMA key` — tidak perlu
/// `open.overrideFor`.
///
/// Kunci diberikan sebagai **raw key** (`x'<hex>'`) sehingga SQLCipher memakai
/// byte-nya langsung tanpa menjalankan PBKDF2 di setiap pembukaan. Ini menjaga
/// cold start tetap di bawah 2 detik (NFR-02). Derivasi berbasis passphrase
/// justru dipakai di tempat lain, yaitu pada berkas backup `.gtbak`.
LazyDatabase openEncryptedDatabase(DatabaseKeyStore keyStore) {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, kDatabaseFileName));
    return openEncryptedFile(file, await keyStore.readOrCreate());
  });
}

/// Membuka [file] sebagai database SQLCipher dengan kunci mentah [keyHex].
///
/// Dipisah dari [openEncryptedDatabase] supaya enkripsinya bisa diuji pada
/// berkas sementara, tanpa path_provider dan Keystore.
QueryExecutor openEncryptedFile(File file, String keyHex) =>
    NativeDatabase.createInBackground(
      file,
      setup: (db) {
        db
          // PRAGMA key harus dieksekusi sebelum statement lain; kalau tidak,
          // SQLite menolak berkas terenkripsi sebagai "file is not a database".
          ..execute('PRAGMA key = "x\'$keyHex\'";')
          // Memaksa satu operasi baca supaya kunci yang salah gagal di sini,
          // bukan nanti saat query pertama di tengah layar.
          ..execute('SELECT count(*) FROM sqlite_master;')
          // NFR-02/07: WAL menaikkan throughput tulis dan mengurangi lock.
          ..execute('PRAGMA journal_mode = WAL;');
      },
    );
