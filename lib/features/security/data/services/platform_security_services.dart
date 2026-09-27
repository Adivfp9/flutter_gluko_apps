import 'package:flutter/services.dart';
import 'package:flutter_gluko_apps/features/security/domain/services/security_services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';

@LazySingleton(as: SecretStore)
class KeystoreSecretStore implements SecretStore {
  new(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

@LazySingleton(as: BiometricAuthenticator)
class LocalBiometricAuthenticator implements BiometricAuthenticator {
  new() : _auth = LocalAuthentication();

  final LocalAuthentication _auth;

  @override
  Future<bool> isAvailable() async {
    try {
      if (!await _auth.isDeviceSupported()) return false;
      final enrolled = await _auth.getAvailableBiometrics();
      return enrolled.isNotEmpty;
    } on Object {
      return false;
    }
  }

  @override
  Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        // PIN aplikasi adalah cadangannya; kredensial perangkat (pola/PIN
        // layar kunci HP) sengaja tidak diterima agar orang yang tahu PIN
        // layar HP tidak otomatis bisa membuka GlukoTrack.
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } on Object {
      return false;
    }
  }
}

@LazySingleton(as: SecureScreen)
class ChannelSecureScreen implements SecureScreen {
  static const MethodChannel _channel = MethodChannel(
    'glukotrack/secure_screen',
  );

  @override
  Future<void> setSecure({required bool enabled}) async {
    try {
      await _channel.invokeMethod<void>('setSecure', {'enabled': enabled});
    } on MissingPluginException {
      // Platform tanpa implementasi (test host): cukup diabaikan.
    }
  }
}
