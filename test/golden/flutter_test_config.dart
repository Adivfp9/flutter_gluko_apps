import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Waktu tetap untuk seluruh golden test: tanggal di header beranda, label
/// "Kemarin", dan sumbu grafik tidak boleh berubah setiap hari.
final DateTime goldenNow = DateTime(2026, 9, 27, 9);

/// Selisih piksel yang masih diterima (1%).
///
/// Golden dibuat di Windows sementara CI berjalan di Linux; rasterisasi
/// anti-aliasing teks sedikit berbeda antar-OS. Perubahan tata letak nyata
/// jauh di atas ambang ini.
const double goldenTolerance = 0.01;

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final base = goldenFileComparator;
  if (base is LocalFileComparator) {
    goldenFileComparator = _TolerantComparator(
      base.basedir.resolve('golden_test.dart'),
    );
  }
  return await withClock(Clock.fixed(goldenNow), testMain);
}

class _TolerantComparator extends LocalFileComparator {
  new(super.testFile);

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );
    if (result.passed || result.diffPercent <= goldenTolerance) {
      result.dispose();
      return true;
    }
    final error = await generateFailureOutput(result, golden, basedir);
    result.dispose();
    throw FlutterError(error);
  }
}
