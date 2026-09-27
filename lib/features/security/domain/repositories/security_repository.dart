import 'dart:math';

import 'package:meta/meta.dart';

/// Setelan kunci aplikasi (PRD F-08).
@immutable
class LockSettings {
  const new({required this.lockEnabled, required this.biometricEnabled});

  static const LockSettings disabled = LockSettings(
    lockEnabled: false,
    biometricEnabled: false,
  );

  final bool lockEnabled;
  final bool biometricEnabled;

  @override
  bool operator ==(Object other) =>
      other is LockSettings &&
      other.lockEnabled == lockEnabled &&
      other.biometricEnabled == biometricEnabled;

  @override
  int get hashCode => Object.hash(lockEnabled, biometricEnabled);
}

enum PinCheckOutcome { success, wrong, coolingDown }

/// Hasil verifikasi PIN beserta status pembatasan percobaan.
@immutable
class PinCheck {
  const new({
    required this.outcome,
    this.failedAttempts = 0,
    this.lockedUntil,
  });

  final PinCheckOutcome outcome;
  final int failedAttempts;

  /// Diisi bila percobaan berikutnya baru boleh setelah waktu ini.
  final DateTime? lockedUntil;

  bool get isSuccess => outcome == PinCheckOutcome.success;
}

/// Pembatasan tebakan PIN.
///
/// Lima kesalahan pertama bebas; setelahnya jeda 30 detik yang berlipat dua
/// setiap kesalahan berikutnya, maksimal 15 menit. Tanpa ini, PIN 6 digit
/// bisa ditebak habis dalam hitungan jam.
abstract final class PinAttemptPolicy {
  static const int freeAttempts = 5;
  static const Duration baseCooldown = Duration(seconds: 30);
  static const Duration maxCooldown = Duration(minutes: 15);

  static Duration? cooldownAfter(int failedAttempts) {
    if (failedAttempts < freeAttempts) return null;
    final exponent = min(failedAttempts - freeAttempts, 10);
    final seconds = baseCooldown.inSeconds * (1 << exponent);
    return Duration(seconds: min(seconds, maxCooldown.inSeconds));
  }
}

abstract interface class SecurityRepository {
  Future<LockSettings> load();

  /// Menyimpan PIN baru dan menyalakan kunci.
  Future<void> enableLock(String pin);

  Future<void> changePin(String pin);

  /// Mematikan kunci sekaligus menghapus PIN dan biometrik.
  Future<void> disableLock();

  Future<void> setBiometricEnabled({required bool enabled});

  Future<PinCheck> verifyPin(String pin, {required DateTime now});

  /// Waktu jeda yang sedang berlaku, bila ada.
  Future<DateTime?> lockedUntil();

  /// Menghapus seluruh rahasia di Keystore; bagian dari "hapus semua data".
  Future<void> clearSecrets();
}
