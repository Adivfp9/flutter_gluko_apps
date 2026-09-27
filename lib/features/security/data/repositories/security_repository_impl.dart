import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/database/daos/settings_dao.dart';
import 'package:flutter_gluko_apps/features/security/domain/repositories/security_repository.dart';
import 'package:flutter_gluko_apps/features/security/domain/services/pin_hasher.dart';
import 'package:flutter_gluko_apps/features/security/domain/services/security_services.dart';
import 'package:injectable/injectable.dart';

/// Hash PIN disimpan di Keystore ([SecretStore]); tanda aktif dan penghitung
/// percobaan di tabel `app_settings` yang sudah terenkripsi SQLCipher.
@LazySingleton(as: SecurityRepository)
class SecurityRepositoryImpl implements SecurityRepository {
  new(this._settings, this._secrets, this._hasher);

  final SettingsDao _settings;
  final SecretStore _secrets;
  final PinHasher _hasher;

  @override
  Future<LockSettings> load() async {
    final enabled = await _settings.readBool(SettingKeys.lockEnabled);
    if (!enabled) return LockSettings.disabled;

    // Kunci tanpa PIN tersimpan (mis. Keystore dihapus sistem) tidak boleh
    // mengurung pengguna di layar kunci yang mustahil dibuka.
    final hasPin = await _secrets.read(SettingKeys.pinHash) != null;
    if (!hasPin) return LockSettings.disabled;

    return LockSettings(
      lockEnabled: true,
      biometricEnabled: await _settings.readBool(SettingKeys.biometricEnabled),
    );
  }

  @override
  Future<void> enableLock(String pin) async {
    await _storePin(pin);
    await _settings.writeBool(SettingKeys.lockEnabled, value: true);
  }

  @override
  Future<void> changePin(String pin) => _storePin(pin);

  Future<void> _storePin(String pin) async {
    if (!PinHasher.isValidPin(pin)) {
      throw ArgumentError('PIN harus 6 digit angka.');
    }
    await _secrets.write(SettingKeys.pinHash, await _hasher.hash(pin));
    await _resetAttempts();
  }

  @override
  Future<void> disableLock() async {
    await _secrets.delete(SettingKeys.pinHash);
    await _settings.writeBool(SettingKeys.lockEnabled, value: false);
    await _settings.writeBool(SettingKeys.biometricEnabled, value: false);
    await _resetAttempts();
  }

  @override
  Future<void> setBiometricEnabled({required bool enabled}) =>
      _settings.writeBool(SettingKeys.biometricEnabled, value: enabled);

  @override
  Future<PinCheck> verifyPin(String pin, {required DateTime now}) async {
    final attempts = await _failedAttempts();
    final until = await lockedUntil();
    if (until != null && now.isBefore(until)) {
      return PinCheck(
        outcome: PinCheckOutcome.coolingDown,
        failedAttempts: attempts,
        lockedUntil: until,
      );
    }

    final stored = await _secrets.read(SettingKeys.pinHash);
    if (stored != null && await _hasher.verify(pin, stored)) {
      await _resetAttempts();
      return const PinCheck(outcome: PinCheckOutcome.success);
    }

    final failed = attempts + 1;
    await _settings.write(SettingKeys.pinFailedAttempts, '$failed');

    final cooldown = PinAttemptPolicy.cooldownAfter(failed);
    final nextAllowed = cooldown == null ? null : now.add(cooldown);
    if (nextAllowed != null) {
      await _settings.writeDateTime(SettingKeys.pinLockedUntil, nextAllowed);
    }

    return PinCheck(
      outcome: PinCheckOutcome.wrong,
      failedAttempts: failed,
      lockedUntil: nextAllowed,
    );
  }

  @override
  Future<DateTime?> lockedUntil() =>
      _settings.readDateTime(SettingKeys.pinLockedUntil);

  @override
  Future<void> clearSecrets() => _secrets.delete(SettingKeys.pinHash);

  Future<int> _failedAttempts() async =>
      int.tryParse(await _settings.read(SettingKeys.pinFailedAttempts) ?? '') ??
      0;

  Future<void> _resetAttempts() async {
    await _settings.remove(SettingKeys.pinFailedAttempts);
    await _settings.remove(SettingKeys.pinLockedUntil);
  }
}
