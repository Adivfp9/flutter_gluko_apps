import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/domain/target_presets.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

/// Hasil klasifikasi satu nilai.
@immutable
class Classification {
  const new({required this.status, required this.isCritical});

  final GlucoseStatus status;

  /// PRD 5.2: nilai sangat rendah atau sangat tinggi, memicu peringatan di
  /// v1.1. Di MVP nilainya sudah disimpan supaya data lama tetap berguna.
  final bool isCritical;

  @override
  bool operator ==(Object other) =>
      other is Classification &&
      other.status == status &&
      other.isCritical == isCritical;

  @override
  int get hashCode => Object.hash(status, isCritical);
}

/// PRD 5.2, algoritma klasifikasi.
///
/// ```text
/// if value < lowMax            -> RENDAH
/// else if value <= normalMax   -> NORMAL
/// else if value <= warningMax  -> WASPADA
/// else                         -> TINGGI
/// ```
///
/// Fungsi murni tanpa akses database supaya bisa dipanggil pada setiap ketukan
/// keypad untuk status langsung di form catat, tanpa biaya I/O.
@injectable
class ClassifyReading {
  const new();

  Classification call(int valueMgDl, TargetThresholds thresholds) {
    final status = switch (valueMgDl) {
      final v when v < thresholds.lowMax => GlucoseStatus.low,
      final v when v <= thresholds.normalMax => GlucoseStatus.normal,
      final v when v <= thresholds.warningMax => GlucoseStatus.warning,
      _ => GlucoseStatus.high,
    };

    final isCritical =
        valueMgDl < thresholds.criticalLow ||
        valueMgDl > thresholds.criticalHigh;

    return Classification(status: status, isCritical: isCritical);
  }
}
