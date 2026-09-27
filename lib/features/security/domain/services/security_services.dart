/// Pembungkus kemampuan platform untuk kunci aplikasi (PRD F-08).
///
/// Berupa interface di domain supaya logika kunci bisa diuji tanpa
/// Keystore, BiometricPrompt, atau method channel (rencana B-3).
library;

/// Penyimpanan rahasia kecil di Android Keystore.
abstract interface class SecretStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

/// Autentikasi biometrik perangkat.
abstract interface class BiometricAuthenticator {
  /// Perangkat punya sensor dan pengguna sudah mendaftarkan biometrik.
  Future<bool> isAvailable();

  /// `false` bila dibatalkan atau gagal; tidak melempar untuk kasus umum.
  Future<bool> authenticate(String reason);
}

/// PRD F-08 AC3: menyembunyikan isi layar di app switcher.
abstract interface class SecureScreen {
  Future<void> setSecure({required bool enabled});
}
