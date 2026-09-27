import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_gluko_apps/features/backup/domain/backup_service.dart';
import 'package:injectable/injectable.dart';
import 'package:share_plus/share_plus.dart';

/// PRD F-09 AC1: ekspor lewat share sheet (Drive, WhatsApp, simpan lokal).
@LazySingleton(as: BackupFileGateway)
class PlatformBackupFileGateway implements BackupFileGateway {
  /// Android tidak mengenal ekstensi `.gtbak`, jadi file diperlakukan
  /// sebagai biner umum agar semua aplikasi tujuan mau menerimanya.
  static const String _mime = 'application/octet-stream';

  @override
  Future<bool> share(Uint8List bytes, String fileName) async {
    final result = await SharePlus.instance.share(
      ShareParams(
        files: [XFile.fromData(bytes, name: fileName, mimeType: _mime)],
        fileNameOverrides: [fileName],
        subject: 'Backup GlukoTrack',
      ),
    );
    // `unavailable`: share sheet tampil tetapi pilihan pengguna tidak bisa
    // diketahui; dianggap berhasil karena file sudah diserahkan.
    return result.status != ShareResultStatus.dismissed;
  }

  @override
  Future<bool> saveAs(Uint8List bytes, String fileName) async {
    final uri = await FilePicker.saveFile(
      fileName: fileName,
      bytes: bytes,
      dialogTitle: 'Simpan backup GlukoTrack',
    );
    return uri != null;
  }

  @override
  Future<Uint8List?> pick() async {
    final files = await FilePicker.pickFiles(
      dialogTitle: 'Pilih file backup (.gtbak)',
    );
    if (files.isEmpty) return null;
    return await files.first.readAsBytes();
  }
}
