import 'package:drift/drift.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/domain/target_presets.dart';
import 'package:flutter_gluko_apps/database/daos/glucose_dao.dart';
import 'package:flutter_gluko_apps/database/daos/profile_dao.dart';
import 'package:flutter_gluko_apps/database/daos/reminder_dao.dart';
import 'package:flutter_gluko_apps/database/daos/settings_dao.dart';
import 'package:flutter_gluko_apps/database/daos/target_dao.dart';
import 'package:flutter_gluko_apps/database/tables/app_settings_table.dart';
import 'package:flutter_gluko_apps/database/tables/glucose_readings_table.dart';
import 'package:flutter_gluko_apps/database/tables/reading_symptoms_table.dart';
import 'package:flutter_gluko_apps/database/tables/reminders_table.dart';
import 'package:flutter_gluko_apps/database/tables/target_ranges_table.dart';
import 'package:flutter_gluko_apps/database/tables/user_profile_table.dart';

part 'app_database.g.dart';

/// Kunci `app_settings` yang dipakai lintas fitur.
abstract final class SettingKeys {
  static const String lastBackupAt = 'last_backup_at';
  static const String lockEnabled = 'lock_enabled';
  static const String pinHash = 'pin_hash';
  static const String pinSalt = 'pin_salt';
  static const String biometricEnabled = 'biometric_enabled';
  static const String lastPurgeAt = 'last_purge_at';
  static const String themeMode = 'theme_mode';
}

@DriftDatabase(
  tables: [
    UserProfileTable,
    TargetRangesTable,
    GlucoseReadingsTable,
    ReadingSymptomsTable,
    RemindersTable,
    AppSettingsTable,
  ],
  daos: [ProfileDao, TargetDao, GlucoseDao, ReminderDao, SettingsDao],
)
class AppDatabase extends _$AppDatabase {
  new(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _createIndexes();
      await _seedDefaults();
    },
    beforeOpen: (details) async {
      // PRD 8.4. Foreign key harus dinyalakan per koneksi, bukan sekali saja
      // saat pembuatan database.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Indeks PRD 8.2.
  ///
  /// Dibuat manual karena ketiganya adalah indeks parsial (`WHERE`), yang
  /// tidak bisa dinyatakan lewat DSL tabel drift.
  Future<void> _createIndexes() async {
    await customStatement(
      'CREATE INDEX idx_readings_measured '
      'ON glucose_readings(measured_at DESC) WHERE deleted_at IS NULL',
    );
    await customStatement(
      'CREATE INDEX idx_readings_type_date '
      'ON glucose_readings(reading_type, local_date) '
      'WHERE deleted_at IS NULL',
    );
    // PRD 5.5: maksimal satu GDP per tanggal kalender. Indeks ini adalah jaring
    // pengaman terakhir; alur normalnya dicegat lebih dulu oleh use case
    // AddReading agar pengguna mendapat dialog pilihan, bukan exception.
    await customStatement(
      'CREATE UNIQUE INDEX ux_fasting_per_day '
      'ON glucose_readings(local_date) '
      "WHERE reading_type = 'fasting' AND deleted_at IS NULL",
    );
  }

  /// Seed PRD 8.4: tiga baris `target_ranges` preset Umum dan satu pengingat
  /// puasa pukul 06.00.
  Future<void> _seedDefaults() async {
    final now = DateTime.now().millisecondsSinceEpoch;

    await batch((b) {
      for (final type in ReadingType.values) {
        final t = TargetPresets.forType(TargetPreset.general, type);
        b.insert(
          targetRangesTable,
          TargetRangesTableCompanion.insert(
            readingType: type.dbValue,
            lowMax: t.lowMax,
            normalMax: t.normalMax,
            warningMax: t.warningMax,
            criticalLow: Value(t.criticalLow),
            criticalHigh: Value(t.criticalHigh),
            updatedAt: now,
          ),
        );
      }

      b.insert(
        remindersTable,
        RemindersTableCompanion.insert(
          label: 'Cek gula darah puasa',
          readingType: Value(ReadingType.fasting.dbValue),
          timeOfMinutes: 6 * 60,
          createdAt: now,
        ),
      );
    });
  }

  /// PRD 8.4: hapus permanen baris yang sudah di-soft delete lebih dari
  /// [retentionDays] hari. Dipanggil saat aplikasi dibuka.
  ///
  /// Mengembalikan jumlah baris yang benar-benar dihapus.
  Future<int> purgeDeletedOlderThan({int retentionDays = 30, DateTime? now}) {
    final cutoff = (now ?? DateTime.now())
        .subtract(Duration(days: retentionDays))
        .millisecondsSinceEpoch;

    return (delete(glucoseReadingsTable)..where(
          (t) =>
              t.deletedAt.isNotNull() & t.deletedAt.isSmallerThanValue(cutoff),
        ))
        .go();
  }
}
