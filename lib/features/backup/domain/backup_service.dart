import 'dart:typed_data';

import 'package:flutter_gluko_apps/core/utils/local_date.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/database/daos/settings_dao.dart';
import 'package:flutter_gluko_apps/database/database_snapshot.dart';
import 'package:flutter_gluko_apps/features/backup/domain/backup_codec.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

/// Tempat file backup keluar-masuk aplikasi (share sheet, pemilih file).
///
/// Interface di domain agar alur backup bisa diuji tanpa plugin (B-3).
abstract interface class BackupFileGateway {
  /// Membuka share sheet; `true` bila pengguna memilih tujuan.
  Future<bool> share(Uint8List bytes, String fileName);

  /// Menyimpan lewat dialog "Simpan sebagai"; `true` bila tersimpan.
  Future<bool> saveAs(Uint8List bytes, String fileName);

  /// Memilih file backup; `null` bila dibatalkan.
  Future<Uint8List?> pick();
}

@immutable
class BackupFile {
  const new({required this.bytes, required this.fileName});

  final Uint8List bytes;
  final String fileName;
}

/// Ringkasan backup yang sudah berhasil dibuka, untuk konfirmasi timpa.
@immutable
class BackupPreview {
  const new({required this.contents});

  final BackupContents contents;

  DateTime get createdAt => contents.header.createdAt.toLocal();

  /// Pembacaan aktif saja; yang sudah di-soft delete tidak dihitung.
  int get readingCount => (contents.tables['glucose_readings'] ?? const [])
      .where((row) => row['deleted_at'] == null)
      .length;

  int get reminderCount => contents.countOf('reminders');
}

/// PRD F-09 AC3: ingatkan bila belum pernah backup atau sudah > 30 hari.
bool needsBackupNudge(DateTime? lastBackupAt, DateTime now) =>
    lastBackupAt == null ||
    now.difference(lastBackupAt) > const Duration(days: 30);

/// Alur backup & restore `.gtbak` (PRD F-09).
@lazySingleton
class BackupService {
  new(this._database, this._snapshot, this._codec, this._settings);

  final AppDatabase _database;
  final DatabaseSnapshot _snapshot;
  final BackupCodec _codec;
  final SettingsDao _settings;

  Stream<DateTime?> watchLastBackup() =>
      _settings.watch(SettingKeys.lastBackupAt).map((raw) {
        final ms = raw == null ? null : int.tryParse(raw);
        return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
      });

  Future<BackupFile> create(String passphrase, {DateTime? now}) async {
    if (!BackupCodec.isAcceptablePassphrase(passphrase)) {
      throw ArgumentError(
        'Passphrase minimal ${BackupCodec.minPassphraseLength} karakter.',
      );
    }
    final at = now ?? DateTime.now();
    final bytes = await _codec.encode(
      tables: await _snapshot.export(),
      schemaVersion: _database.schemaVersion,
      passphrase: passphrase,
      createdAt: at,
    );
    return BackupFile(
      bytes: bytes,
      fileName:
          'glukotrack-${LocalDate.ofLocal(at)}.${BackupCodec.fileExtension}',
    );
  }

  /// Dicatat hanya setelah file benar-benar dibagikan atau disimpan, agar
  /// nudge 30 hari tidak hilang karena share sheet yang dibatalkan.
  Future<void> markBackedUp(DateTime at) =>
      _settings.writeDateTime(SettingKeys.lastBackupAt, at);

  /// Melempar [BackupException] untuk file salah, rusak, versi lebih baru,
  /// atau passphrase salah — sebelum ada data yang disentuh.
  Future<BackupPreview> open(Uint8List bytes, String passphrase) async =>
      BackupPreview(
        contents: await _codec.decode(
          bytes,
          passphrase: passphrase,
          currentSchemaVersion: _database.schemaVersion,
        ),
      );

  /// Menimpa seluruh data dengan isi backup, dalam satu transaksi.
  Future<void> restore(BackupPreview preview) =>
      _snapshot.replaceAll(preview.contents.tables);
}
