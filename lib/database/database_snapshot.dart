import 'package:drift/drift.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:injectable/injectable.dart';

/// Isi seluruh tabel sebagai baris mentah: `{nama_tabel: [{kolom: nilai}]}`.
typedef TableRows = Map<String, List<Map<String, Object?>>>;

/// Dump dan pemulihan logis seluruh database untuk backup `.gtbak` (F-09).
///
/// Sengaja berupa baris mentah per kolom, bukan salinan file SQLCipher:
/// file database terkunci kunci Keystore perangkat ini, sedangkan backup
/// harus bisa dipulihkan di HP lain (keputusan B-2). Nama kolom SQL juga
/// lebih stabil daripada nama field Dart bila skema kelak dimigrasi.
@lazySingleton
class DatabaseSnapshot {
  new(this._db);

  final AppDatabase _db;

  /// Setelan milik perangkat ini, bukan milik data pengguna: status kunci
  /// dan penghitung PIN terikat ke hash PIN di Keystore yang tidak ikut
  /// ter-backup, dan waktu backup/pembersihan adalah riwayat perangkat.
  static const Set<String> deviceOnlySettings = {
    SettingKeys.lockEnabled,
    SettingKeys.biometricEnabled,
    SettingKeys.pinHash,
    SettingKeys.pinSalt,
    SettingKeys.pinFailedAttempts,
    SettingKeys.pinLockedUntil,
    SettingKeys.lastBackupAt,
    SettingKeys.lastPurgeAt,
  };

  /// Urutan induk → anak agar foreign key terpenuhi saat menyisipkan.
  List<TableInfo<Table, Object?>> get _tables => [
    _db.userProfileTable,
    _db.targetRangesTable,
    _db.glucoseReadingsTable,
    _db.readingSymptomsTable,
    _db.remindersTable,
    _db.appSettingsTable,
  ];

  Set<String> get tableNames => {for (final t in _tables) t.actualTableName};

  Future<TableRows> export() => _db.transaction(() async {
    final result = <String, List<Map<String, Object?>>>{};
    for (final table in _tables) {
      final name = table.actualTableName;
      final rows = await _db.customSelect('SELECT * FROM $name').get();
      result[name] = [
        for (final row in rows)
          if (!_isDeviceOnly(name, row.data)) Map.of(row.data),
      ];
    }
    return result;
  });

  /// Mengganti seluruh data dengan [rows] dalam satu transaksi: gagal di
  /// tengah jalan berarti data lama tetap utuh.
  Future<void> replaceAll(TableRows rows) async {
    final unknown = rows.keys.toSet().difference(tableNames);
    if (unknown.isNotEmpty) {
      throw FormatException('Tabel tidak dikenal: ${unknown.join(', ')}');
    }

    await _db.transaction(() async {
      // Lewat API drift (bukan SQL mentah) supaya stream yang sedang
      // didengar beranda, riwayat, dan pengingat ikut diperbarui.
      for (final table in _tables.reversed) {
        if (table == _db.appSettingsTable) {
          await (_db.delete(
            _db.appSettingsTable,
          )..where((t) => t.key.isNotIn(deviceOnlySettings))).go();
        } else {
          await _db.delete(table).go();
        }
      }

      for (final table in _tables) {
        final name = table.actualTableName;
        final columns = {for (final c in table.$columns) c.name};
        for (final row in rows[name] ?? const <Map<String, Object?>>[]) {
          if (_isDeviceOnly(name, row)) continue;
          final extra = row.keys.toSet().difference(columns);
          if (extra.isNotEmpty) {
            throw FormatException(
              'Kolom tidak dikenal di $name: ${extra.join(', ')}',
            );
          }
          final keys = row.keys.toList();
          await _db.customInsert(
            'INSERT INTO $name (${keys.join(', ')}) '
            'VALUES (${List.filled(keys.length, '?').join(', ')})',
            variables: [for (final k in keys) Variable(row[k])],
            updates: {table},
          );
        }
      }
    });
  }

  bool _isDeviceOnly(String table, Map<String, Object?> row) =>
      table == _db.appSettingsTable.actualTableName &&
      deviceOnlySettings.contains(row['key']);
}
