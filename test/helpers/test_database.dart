import 'package:drift/native.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';

/// Database in-memory untuk test (PRD 9.1).
///
/// `onCreate` tetap dijalankan sehingga indeks parsial dan seed ikut terbentuk
/// — tanpa itu test tidak akan menangkap pelanggaran `ux_fasting_per_day`.
AppDatabase createTestDatabase() {
  return AppDatabase(
    NativeDatabase.memory(
      setup: (db) => db.execute('PRAGMA foreign_keys = ON;'),
    ),
  );
}
