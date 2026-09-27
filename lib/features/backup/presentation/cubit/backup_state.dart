import 'package:flutter_gluko_apps/features/backup/domain/backup_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'backup_state.freezed.dart';

@freezed
abstract class BackupState with _$BackupState {
  const factory({
    DateTime? lastBackupAt,

    /// Teks proses yang sedang berjalan, mis. "Mengenkripsi…"; `null` = diam.
    String? busyLabel,

    /// File sudah dipilih, menunggu passphrase.
    @Default(false) bool hasPendingFile,

    /// Backup berhasil dibuka, menunggu konfirmasi timpa.
    BackupPreview? preview,
    String? errorMessage,
    String? infoMessage,

    /// Sekali pakai: restore baru saja selesai.
    @Default(false) bool restored,
  }) = _BackupState;

  const new _();

  bool get isBusy => busyLabel != null;
}
