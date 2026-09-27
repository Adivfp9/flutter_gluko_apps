// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get navHome => 'Beranda';

  @override
  String get navHistory => 'Riwayat';

  @override
  String get navTrend => 'Tren';

  @override
  String get navSettings => 'Setelan';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get settingsSectionMonitoring => 'Pemantauan';

  @override
  String get settingsSectionData => 'Data';

  @override
  String get settingsTargetTitle => 'Target & satuan';

  @override
  String get settingsTargetSubtitle =>
      'Atur rentang GDP, GDS, 2 Jam PP, serta mg/dL atau mmol/L.';

  @override
  String get settingsRemindersTitle => 'Pengingat';

  @override
  String get settingsRemindersSubtitle => 'Jadwal cek gula darah harian.';

  @override
  String get settingsSecurityTitle => 'Keamanan';

  @override
  String get settingsSecuritySubtitle => 'PIN dan biometrik.';

  @override
  String get settingsBackupTitle => 'Backup & restore';

  @override
  String get settingsBackupLoading => 'Memuat…';

  @override
  String get settingsBackupNever =>
      'Belum pernah backup. Buat sekarang agar data aman.';

  @override
  String settingsBackupLast(String date) {
    return 'Terakhir $date';
  }

  @override
  String settingsBackupStale(String date) {
    return 'Terakhir $date — sudah lebih dari 30 hari.';
  }

  @override
  String get settingsAboutTitle => 'Tentang GlukoTrack';

  @override
  String get settingsAboutSubtitle => 'Disclaimer medis dan privasi.';

  @override
  String get aboutTagline => 'Catatan gula darah pribadi';

  @override
  String get aboutDisclaimerTitle => 'Disclaimer medis';

  @override
  String get aboutDisclaimer =>
      'GlukoTrack adalah alat bantu pencatatan gula darah pribadi, bukan alat diagnosis maupun pengganti nasihat tenaga kesehatan. Target dan klasifikasi di aplikasi ini bersifat umum. Konsultasikan target pribadi, pengobatan, dan setiap perubahan terapi dengan dokter Anda. Bila Anda mengalami gejala gula darah sangat rendah atau sangat tinggi, segera cari pertolongan medis.';

  @override
  String get aboutPrivacyTitle => 'Privasi';

  @override
  String get aboutPrivacyBody =>
      'Semua catatan tersimpan terenkripsi hanya di HP ini. GlukoTrack tidak memiliki akun, tidak mengirim data ke server, dan tidak meminta izin internet.';
}
