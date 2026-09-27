import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gluko_apps/features/backup/domain/backup_codec.dart';
import 'package:flutter_gluko_apps/features/backup/domain/backup_service.dart';
import 'package:flutter_gluko_apps/features/backup/presentation/cubit/backup_state.dart';
import 'package:injectable/injectable.dart';

enum BackupDestination { share, device }

/// Layar Backup & restore (PRD F-09).
@injectable
class BackupCubit extends Cubit<BackupState> {
  new(this._service, this._files) : super(const BackupState());

  final BackupService _service;
  final BackupFileGateway _files;

  StreamSubscription<DateTime?>? _lastSub;
  Uint8List? _pendingBytes;

  void start() {
    unawaited(_lastSub?.cancel());
    _lastSub = _service.watchLastBackup().listen(
      (at) => emit(state.copyWith(lastBackupAt: at)),
    );
  }

  Future<void> createBackup(
    String passphrase, {
    required BackupDestination destination,
    DateTime? now,
  }) async {
    emit(state.copyWith(busyLabel: 'Mengenkripsi backup…', errorMessage: null));
    try {
      final file = await _service.create(passphrase, now: now);
      final delivered = switch (destination) {
        BackupDestination.share => await _files.share(
          file.bytes,
          file.fileName,
        ),
        BackupDestination.device => await _files.saveAs(
          file.bytes,
          file.fileName,
        ),
      };
      if (delivered) await _service.markBackedUp(now ?? DateTime.now());
      if (isClosed) return;
      emit(
        state.copyWith(
          busyLabel: null,
          infoMessage: delivered ? 'Backup tersimpan: ${file.fileName}' : null,
        ),
      );
    } on Object catch (e) {
      if (!isClosed) {
        emit(state.copyWith(busyLabel: null, errorMessage: 'Backup gagal: $e'));
      }
    }
  }

  /// Memilih file; `true` bila ada file yang dipilih.
  Future<bool> pickFile() async {
    try {
      final bytes = await _files.pick();
      if (bytes == null) return false;
      setPendingFile(bytes);
      return true;
    } on Object catch (e) {
      emit(state.copyWith(errorMessage: 'Gagal membuka file: $e'));
      return false;
    }
  }

  void setPendingFile(Uint8List bytes) {
    _pendingBytes = bytes;
    emit(state.copyWith(hasPendingFile: true, errorMessage: null));
  }

  Future<void> openPending(String passphrase) async {
    final bytes = _pendingBytes;
    if (bytes == null) return;
    emit(state.copyWith(busyLabel: 'Membuka backup…', errorMessage: null));
    try {
      final preview = await _service.open(bytes, passphrase);
      if (!isClosed) {
        emit(state.copyWith(busyLabel: null, preview: preview));
      }
    } on BackupException catch (e) {
      // Passphrase salah: file tetap dipegang agar bisa dicoba lagi.
      final keepFile = e.kind == BackupErrorKind.wrongPassphrase;
      if (!keepFile) _pendingBytes = null;
      if (!isClosed) {
        emit(
          state.copyWith(
            busyLabel: null,
            hasPendingFile: keepFile,
            errorMessage: e.message,
          ),
        );
      }
    }
  }

  Future<void> confirmRestore() async {
    final preview = state.preview;
    if (preview == null) return;
    emit(state.copyWith(busyLabel: 'Memulihkan data…'));
    try {
      await _service.restore(preview);
      _pendingBytes = null;
      if (isClosed) return;
      emit(
        state.copyWith(
          busyLabel: null,
          preview: null,
          hasPendingFile: false,
          restored: true,
          infoMessage: 'Data berhasil dipulihkan.',
        ),
      );
    } on Object catch (e) {
      // Restore berjalan dalam satu transaksi: data lama tetap utuh.
      if (!isClosed) {
        emit(
          state.copyWith(
            busyLabel: null,
            errorMessage: 'Pemulihan gagal, data lama tidak berubah. ($e)',
          ),
        );
      }
    }
  }

  void cancelRestore() {
    _pendingBytes = null;
    emit(state.copyWith(preview: null, hasPendingFile: false));
  }

  void clearMessages() => emit(
    state.copyWith(errorMessage: null, infoMessage: null, restored: false),
  );

  @override
  Future<void> close() async {
    await _lastSub?.cancel();
    return await super.close();
  }
}
