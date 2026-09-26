import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/domain/target_presets.dart';
import 'package:meta/meta.dart';

/// Ambang aktif untuk ketiga tipe pengukuran.
///
/// Disimpan sebagai satu objek karena klasifikasi selalu butuh ambang tipe
/// yang bersangkutan, dan layar Target menyunting ketiganya sekaligus.
@immutable
class TargetSet {
  const new(this.byType);

  factory fromPreset(TargetPreset preset) =>
      TargetSet(Map.unmodifiable(TargetPresets.of(preset)));

  final Map<ReadingType, TargetThresholds> byType;

  TargetThresholds forType(ReadingType type) =>
      byType[type] ?? TargetPresets.forType(TargetPreset.general, type);

  /// Preset mana yang sedang dipakai; `custom` bila angkanya sudah diubah.
  TargetPreset get preset => TargetPresets.detect(byType);

  /// PRD F-03 AC2: seluruh tipe harus punya ambang yang naik berurutan.
  bool get isValid => ReadingType.values.every((t) => forType(t).isOrdered);

  TargetSet replace(ReadingType type, TargetThresholds thresholds) =>
      TargetSet({...byType, type: thresholds});

  @override
  bool operator ==(Object other) =>
      other is TargetSet &&
      ReadingType.values.every((t) => other.byType[t] == byType[t]);

  @override
  int get hashCode =>
      Object.hashAll([for (final t in ReadingType.values) byType[t]]);
}
