import 'dart:convert';
import 'dart:io' show GZipCodec;
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_gluko_apps/database/database_snapshot.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

enum BackupErrorKind {
  notBackup('File ini bukan backup GlukoTrack.'),
  corrupted('File backup rusak atau tidak lengkap.'),
  newerVersion(
    'Backup ini dibuat oleh versi GlukoTrack yang lebih baru. '
    'Perbarui aplikasi dulu, lalu coba lagi.',
  ),
  wrongPassphrase('Passphrase salah.');

  new(this.message);

  final String message;
}

class BackupException implements Exception {
  const new(this.kind);

  final BackupErrorKind kind;

  String get message => kind.message;

  @override
  String toString() => 'BackupException(${kind.name})';
}

/// Metadata plaintext di awal file; bisa dibaca tanpa passphrase.
@immutable
class BackupHeader {
  const new({required this.schemaVersion, required this.createdAt});

  final int schemaVersion;
  final DateTime createdAt;
}

/// Hasil dekode: metadata + seluruh baris tabel.
@immutable
class BackupContents {
  const new({required this.header, required this.tables});

  final BackupHeader header;
  final TableRows tables;

  int countOf(String table) => tables[table]?.length ?? 0;
}

/// Format file `.gtbak` (keputusan B-2).
///
/// ```text
/// "GTBAK" 0x01 | uint32 BE panjang header | header JSON (UTF-8) | ciphertext
/// ```
///
/// Kunci AES-256-GCM diturunkan dari passphrase pengguna dengan
/// PBKDF2-HMAC-SHA256 + salt acak, sehingga backup bisa dipulihkan di HP
/// lain. SHA-256 atas ciphertext di header membedakan "file rusak" dari
/// "passphrase salah" — keduanya sama-sama menggagalkan tag GCM.
@lazySingleton
class BackupCodec {
  new() : iterations = 200000;

  /// Untuk test: iterasi kecil agar suite tetap cepat.
  new withIterations(this.iterations);

  static const List<int> magic = [0x47, 0x54, 0x42, 0x41, 0x4B, 0x01];
  static const int formatVersion = 1;
  static const int minPassphraseLength = 8;
  static const String fileExtension = 'gtbak';
  static const int _saltBytes = 16;

  final int iterations;

  final AesGcm _cipher = AesGcm.with256bits();

  static bool isAcceptablePassphrase(String passphrase) =>
      passphrase.length >= minPassphraseLength;

  Future<Uint8List> encode({
    required TableRows tables,
    required int schemaVersion,
    required String passphrase,
    required DateTime createdAt,
  }) async {
    final createdIso = createdAt.toUtc().toIso8601String();
    final plain = GZipCodec().encode(
      utf8.encode(jsonEncode({'tables': tables})),
    );

    final random = Random.secure();
    final salt = List<int>.generate(_saltBytes, (_) => random.nextInt(256));
    final nonce = _cipher.newNonce();
    final key = await _deriveKey(passphrase, salt, iterations);
    final box = await _cipher.encrypt(
      plain,
      secretKey: key,
      nonce: nonce,
      aad: _aad(schemaVersion, createdIso),
    );
    final digest = await Sha256().hash(box.cipherText);

    final header = utf8.encode(
      jsonEncode({
        'format': formatVersion,
        'app': 'GlukoTrack',
        'schema_version': schemaVersion,
        'created_at': createdIso,
        'kdf': 'pbkdf2-sha256',
        'iterations': iterations,
        'salt': base64Encode(salt),
        'cipher': 'aes-256-gcm',
        'nonce': base64Encode(nonce),
        'mac': base64Encode(box.mac.bytes),
        'compression': 'gzip',
        'sha256': base64Encode(digest.bytes),
      }),
    );

    final length = ByteData(4)..setUint32(0, header.length);
    return Uint8List.fromList([
      ...magic,
      ...length.buffer.asUint8List(),
      ...header,
      ...box.cipherText,
    ]);
  }

  /// Membaca header tanpa passphrase, untuk validasi awal.
  BackupHeader readHeader(Uint8List bytes) => _parse(bytes).header;

  Future<BackupContents> decode(
    Uint8List bytes, {
    required String passphrase,
    required int currentSchemaVersion,
  }) async {
    final parsed = _parse(bytes);
    final header = parsed.header;

    if (header.schemaVersion > currentSchemaVersion) {
      throw const BackupException(BackupErrorKind.newerVersion);
    }

    final digest = await Sha256().hash(parsed.cipherText);
    if (!_equals(digest.bytes, parsed.sha256)) {
      throw const BackupException(BackupErrorKind.corrupted);
    }

    final key = await _deriveKey(passphrase, parsed.salt, parsed.iterations);
    final List<int> plain;
    try {
      plain = await _cipher.decrypt(
        SecretBox(parsed.cipherText, nonce: parsed.nonce, mac: Mac(parsed.mac)),
        secretKey: key,
        aad: _aad(header.schemaVersion, parsed.createdIso),
      );
    } on SecretBoxAuthenticationError {
      // Checksum sudah cocok, jadi ciphertext utuh: tag gagal berarti kunci
      // (passphrase) yang salah.
      throw const BackupException(BackupErrorKind.wrongPassphrase);
    }

    final TableRows tables;
    try {
      final json = jsonDecode(utf8.decode(GZipCodec().decode(plain)));
      final raw = (json as Map<String, Object?>)['tables']! as Map;
      tables = {
        for (final entry in raw.entries)
          entry.key as String: [
            for (final row in entry.value as List)
              Map<String, Object?>.from(row as Map),
          ],
      };
    } on Object {
      throw const BackupException(BackupErrorKind.corrupted);
    }

    return BackupContents(
      header: header,
      tables: BackupMigrations.upgrade(
        tables,
        from: header.schemaVersion,
        to: currentSchemaVersion,
      ),
    );
  }

  Future<SecretKey> _deriveKey(String passphrase, List<int> salt, int rounds) =>
      Pbkdf2.hmacSha256(
        iterations: rounds,
        bits: 256,
      ).deriveKeyFromPassword(password: passphrase, nonce: salt);

  /// Header yang memengaruhi cara data dibaca ikut diautentikasi, sehingga
  /// mengubah `schema_version` di file akan menggagalkan dekripsi.
  List<int> _aad(int schemaVersion, String createdIso) =>
      utf8.encode('GTBAK/$formatVersion/$schemaVersion/$createdIso');

  _ParsedFile _parse(Uint8List bytes) {
    if (bytes.length < magic.length + 4 ||
        !_equals(bytes.sublist(0, magic.length), magic)) {
      throw const BackupException(BackupErrorKind.notBackup);
    }

    try {
      final length = ByteData.sublistView(
        bytes,
        magic.length,
        magic.length + 4,
      ).getUint32(0);
      final start = magic.length + 4;
      if (start + length > bytes.length) {
        throw const FormatException('header terpotong');
      }
      final json =
          jsonDecode(utf8.decode(bytes.sublist(start, start + length)))
              as Map<String, Object?>;

      if (json['format'] != formatVersion ||
          json['kdf'] != 'pbkdf2-sha256' ||
          json['cipher'] != 'aes-256-gcm') {
        throw const FormatException('format tidak dikenal');
      }

      final createdIso = json['created_at']! as String;
      final iterations = json['iterations']! as int;
      if (iterations <= 0) throw const FormatException('iterasi');

      return _ParsedFile(
        header: BackupHeader(
          schemaVersion: json['schema_version']! as int,
          createdAt: DateTime.parse(createdIso),
        ),
        createdIso: createdIso,
        iterations: iterations,
        salt: base64Decode(json['salt']! as String),
        nonce: base64Decode(json['nonce']! as String),
        mac: base64Decode(json['mac']! as String),
        sha256: base64Decode(json['sha256']! as String),
        cipherText: bytes.sublist(start + length),
      );
    } on BackupException {
      rethrow;
    } on Object {
      throw const BackupException(BackupErrorKind.corrupted);
    }
  }

  bool _equals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }
}

class _ParsedFile {
  const new({
    required this.header,
    required this.createdIso,
    required this.iterations,
    required this.salt,
    required this.nonce,
    required this.mac,
    required this.sha256,
    required this.cipherText,
  });

  final BackupHeader header;
  final String createdIso;
  final int iterations;
  final List<int> salt;
  final List<int> nonce;
  final List<int> mac;
  final List<int> sha256;
  final List<int> cipherText;
}

/// Migrasi isi backup dari skema lama ke skema saat ini (rencana 4.6:
/// versi lebih lama dimigrasi, lebih baru ditolak).
///
/// Setiap kenaikan `schemaVersion` database wajib menambah satu langkah di
/// [_steps], misalnya `2: (rows) => ...` untuk mengubah skema 1 → 2.
abstract final class BackupMigrations {
  static final Map<int, TableRows Function(TableRows)> _steps = {};

  static TableRows upgrade(
    TableRows tables, {
    required int from,
    required int to,
  }) {
    var current = tables;
    for (var version = from + 1; version <= to; version++) {
      final step = _steps[version];
      if (step == null) {
        throw StateError('Migrasi backup ke skema $version belum ditulis.');
      }
      current = step(current);
    }
    return current;
  }
}
