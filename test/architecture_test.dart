@Tags(['architecture'])
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Menegakkan aturan arsitektur PRD 7.5 yang tidak bisa diekspresikan
/// analyzer.
///
/// Dijalankan sebagai test biasa supaya pelanggaran memerahkan CI, bukan
/// sekadar jadi catatan di dokumen yang lama-lama diabaikan.
void main() {
  final libDir = Directory('lib');

  List<File> dartFilesUnder(bool Function(String path) matches) {
    if (!libDir.existsSync()) return [];
    return libDir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .where((f) => !f.path.endsWith('.g.dart'))
        .where((f) => !f.path.endsWith('.freezed.dart'))
        .where((f) => !f.path.endsWith('.config.dart'))
        .where((f) => matches(f.path.replaceAll(r'\', '/')))
        .toList();
  }

  Iterable<String> importsOf(File file) {
    return file
        .readAsLinesSync()
        .map((l) => l.trim())
        .where((l) => l.startsWith('import ') || l.startsWith('export '));
  }

  group('Batas layer', () {
    test('domain tidak bergantung pada Flutter, drift, atau paket UI', () {
      final offenders = <String>[];
      const forbidden = [
        'package:flutter/',
        'package:flutter_bloc/',
        'package:drift/',
        'package:sqlite3/',
        'package:go_router/',
        'package:fl_chart/',
      ];

      for (final file in dartFilesUnder((p) => p.contains('/domain/'))) {
        for (final line in importsOf(file)) {
          for (final bad in forbidden) {
            if (line.contains(bad)) {
              offenders.add('${file.path}: $line');
            }
          }
        }
      }

      expect(
        offenders,
        isEmpty,
        reason:
            'Layer domain harus murni Dart (PRD 7.5). Pelanggaran:\n'
            '${offenders.join('\n')}',
      );
    });

    test('domain tidak mengimpor layer data atau presentation', () {
      final offenders = <String>[];

      for (final file in dartFilesUnder((p) => p.contains('/domain/'))) {
        for (final line in importsOf(file)) {
          if (line.contains('/data/') || line.contains('/presentation/')) {
            offenders.add('${file.path}: $line');
          }
        }
      }

      expect(
        offenders,
        isEmpty,
        reason:
            'Arah dependensi hanya boleh menuju domain. Pelanggaran:\n'
            '${offenders.join('\n')}',
      );
    });

    test(
      'presentation tidak memanggil repository, DAO, atau drift langsung',
      () {
        final offenders = <String>[];

        for (final file in dartFilesUnder(
          (p) => p.contains('/presentation/'),
        )) {
          for (final line in importsOf(file)) {
            final touchesData =
                line.contains('/data/') || line.contains('package:drift/');
            final touchesDatabase = line.contains('/database/');
            if (touchesData || touchesDatabase) {
              offenders.add('${file.path}: $line');
            }
          }
        }

        expect(
          offenders,
          isEmpty,
          reason:
              'BLoC hanya boleh bergantung pada use case (PRD 7.5). '
              'Pelanggaran:\n${offenders.join('\n')}',
        );
      },
    );

    test('core tidak bergantung pada features', () {
      final offenders = <String>[];

      for (final file in dartFilesUnder(
        (p) => p.contains('lib/core/') && !p.contains('lib/core/router/'),
      )) {
        for (final line in importsOf(file)) {
          if (line.contains('/features/')) {
            offenders.add('${file.path}: $line');
          }
        }
      }

      expect(
        offenders,
        isEmpty,
        reason:
            'core/ adalah fondasi bersama dan tidak boleh menarik feature. '
            'Pengecualian: core/router merakit halaman antar-feature. '
            'Pelanggaran:\n${offenders.join('\n')}',
      );
    });
  });
}
