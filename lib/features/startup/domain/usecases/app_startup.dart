import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/database/daos/settings_dao.dart';
import 'package:flutter_gluko_apps/features/profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

/// Hasil pemeriksaan saat aplikasi dibuka.
class StartupResult {
  const new({required this.onboardingDone, required this.purgedRows});

  final bool onboardingDone;

  /// Jumlah baris yang dihapus permanen oleh job pembersihan.
  final int purgedRows;
}

/// Pekerjaan yang dijalankan sekali setiap aplikasi dibuka.
///
/// PRD 8.4: baris dengan `deleted_at` lebih dari 30 hari dibersihkan saat
/// aplikasi dibuka. Pembersihan sengaja tidak memblokir tampilan layar —
/// kegagalannya tidak boleh membuat aplikasi gagal start.
@lazySingleton
class AppStartup {
  new(this._database, this._settings, this._profiles);

  static const int retentionDays = 30;

  final AppDatabase _database;
  final SettingsDao _settings;
  final ProfileRepository _profiles;

  Future<StartupResult> run() async {
    final purged = await _purgeQuietly();

    final profile = await _profiles.getProfile();
    final onboardingDone = profile.getOrElse((_) => throw StateError('x'));

    return StartupResult(
      onboardingDone: onboardingDone.onboardingDone,
      purgedRows: purged,
    );
  }

  Future<int> _purgeQuietly() async {
    try {
      final purged = await _database.purgeDeletedOlderThan();
      await _settings.writeDateTime(SettingKeys.lastPurgeAt, DateTime.now());
      return purged;
    } on Object {
      // Database bermasalah akan tetap terlihat pada operasi berikutnya;
      // menggagalkan start hanya karena pembersihan justru lebih buruk.
      return 0;
    }
  }
}
