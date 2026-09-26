import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/database/connection/database_key_store.dart';
import 'package:flutter_gluko_apps/database/connection/encrypted_connection.dart';
import 'package:flutter_gluko_apps/database/daos/glucose_dao.dart';
import 'package:flutter_gluko_apps/database/daos/profile_dao.dart';
import 'package:flutter_gluko_apps/database/daos/reminder_dao.dart';
import 'package:flutter_gluko_apps/database/daos/settings_dao.dart';
import 'package:flutter_gluko_apps/database/daos/target_dao.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

/// Registrasi infrastruktur penyimpanan.
///
/// DAO diambil dari instance [AppDatabase] yang sama agar semua query berbagi
/// satu koneksi — ini yang membuat `Stream` drift saling memicu antar layar
/// (PRD 7.4 langkah 5).
@module
abstract class DatabaseModule {
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @lazySingleton
  AppDatabase database(DatabaseKeyStore keyStore) =>
      AppDatabase(openEncryptedDatabase(keyStore));

  @lazySingleton
  GlucoseDao glucoseDao(AppDatabase db) => db.glucoseDao;

  @lazySingleton
  ProfileDao profileDao(AppDatabase db) => db.profileDao;

  @lazySingleton
  TargetDao targetDao(AppDatabase db) => db.targetDao;

  @lazySingleton
  ReminderDao reminderDao(AppDatabase db) => db.reminderDao;

  @lazySingleton
  SettingsDao settingsDao(AppDatabase db) => db.settingsDao;
}
