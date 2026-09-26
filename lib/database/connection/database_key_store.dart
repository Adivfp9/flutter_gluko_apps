import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

/// Menyimpan kunci enkripsi database (NFR-05).
///
/// Kunci 256-bit dibuat sekali seumur pemasangan aplikasi lalu disimpan di
/// Android Keystore lewat `flutter_secure_storage`. Kunci **tidak pernah**
/// ikut berpindah perangkat — itulah sebabnya file database dikecualikan dari
/// Android auto-backup, dan mengapa pemulihan resmi hanya lewat `.gtbak`.
@lazySingleton
class DatabaseKeyStore {
  new(this._storage);

  static const String _keyName = 'db_encryption_key_hex';

  /// 32 byte = 256 bit.
  static const int keyLengthBytes = 32;

  final FlutterSecureStorage _storage;

  /// Mengembalikan kunci dalam bentuk hex, membuatnya bila belum ada.
  Future<String> readOrCreate() async {
    final existing = await _storage.read(key: _keyName);
    if (existing != null && existing.length == keyLengthBytes * 2) {
      return existing;
    }

    final key = generateKeyHex();
    await _storage.write(key: _keyName, value: key);
    return key;
  }

  Future<bool> exists() async => await _storage.read(key: _keyName) != null;

  /// Hanya untuk alur "hapus semua data" — menghapus kunci membuat database
  /// lama tidak bisa dibuka lagi selamanya.
  Future<void> deleteKey() => _storage.delete(key: _keyName);

  /// Kunci acak kriptografis, dikodekan hex huruf kecil.
  static String generateKeyHex() {
    final random = Random.secure();
    final bytes = Uint8List.fromList(
      List<int>.generate(keyLengthBytes, (_) => random.nextInt(256)),
    );
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
