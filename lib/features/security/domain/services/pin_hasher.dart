import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:injectable/injectable.dart';

/// Hash PIN dengan PBKDF2-HMAC-SHA256 + salt acak (rencana implementasi 4.5).
///
/// Format tersimpan: `pbkdf2-sha256$<iterasi>$<salt base64>$<hash base64>`.
/// Jumlah iterasi ikut disimpan supaya bisa dinaikkan kelak tanpa membuat
/// PIN lama tidak bisa diverifikasi.
@lazySingleton
class PinHasher {
  /// 100 ribu iterasi ≈ 0,1–0,3 detik di ponsel kelas menengah (Dart murni).
  /// PIN 6 digit hanya punya sejuta kemungkinan, jadi pertahanan utamanya
  /// adalah secure storage + pembatasan percobaan, bukan iterasi.
  new() : iterations = 100000;

  /// Untuk test: iterasi kecil agar suite tetap cepat.
  new withIterations(this.iterations);

  static const String _scheme = 'pbkdf2-sha256';
  static const int _saltBytes = 16;
  static const int _hashBits = 256;

  final int iterations;

  static final RegExp _pinPattern = RegExp(r'^\d{6}$');

  /// PRD F-08 AC1: PIN tepat 6 digit angka.
  static bool isValidPin(String pin) => _pinPattern.hasMatch(pin);

  Future<String> hash(String pin) async {
    final random = Random.secure();
    final salt = List<int>.generate(_saltBytes, (_) => random.nextInt(256));
    final digest = await _derive(pin, salt, iterations);
    return [
      _scheme,
      '$iterations',
      base64Encode(salt),
      base64Encode(digest),
    ].join(r'$');
  }

  /// `false` untuk format rusak, bukan exception: data korup tidak boleh
  /// membuat layar kunci crash.
  Future<bool> verify(String pin, String stored) async {
    final parts = stored.split(r'$');
    if (parts.length != 4 || parts[0] != _scheme) return false;

    final rounds = int.tryParse(parts[1]);
    if (rounds == null || rounds <= 0) return false;

    final List<int> salt;
    final List<int> expected;
    try {
      salt = base64Decode(parts[2]);
      expected = base64Decode(parts[3]);
    } on FormatException {
      return false;
    }

    final actual = await _derive(pin, salt, rounds);
    return _constantTimeEquals(actual, expected);
  }

  Future<List<int>> _derive(String pin, List<int> salt, int rounds) async {
    final algorithm = Pbkdf2.hmacSha256(iterations: rounds, bits: _hashBits);
    final key = await algorithm.deriveKeyFromPassword(
      password: pin,
      nonce: salt,
    );
    return await key.extractBytes();
  }

  bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }
}
