import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:meta/meta.dart';

/// Satu set ambang untuk satu tipe pengukuran, dalam mg/dL.
@immutable
class TargetThresholds {
  const new({
    required this.lowMax,
    required this.normalMax,
    required this.warningMax,
    this.criticalLow = defaultCriticalLow,
    this.criticalHigh = defaultCriticalHigh,
  });

  /// PRD 5.2: ambang nilai kritis bawaan.
  static const int defaultCriticalLow = 54;
  static const int defaultCriticalHigh = 300;

  /// Nilai di bawah ini berstatus Rendah.
  final int lowMax;

  /// Batas atas status Normal (inklusif).
  final int normalMax;

  /// Batas atas status Waspada (inklusif).
  final int warningMax;

  final int criticalLow;
  final int criticalHigh;

  /// PRD F-03 AC2: ambang wajib naik berurutan.
  bool get isOrdered => lowMax < normalMax && normalMax < warningMax;

  TargetThresholds copyWith({
    int? lowMax,
    int? normalMax,
    int? warningMax,
    int? criticalLow,
    int? criticalHigh,
  }) => TargetThresholds(
    lowMax: lowMax ?? this.lowMax,
    normalMax: normalMax ?? this.normalMax,
    warningMax: warningMax ?? this.warningMax,
    criticalLow: criticalLow ?? this.criticalLow,
    criticalHigh: criticalHigh ?? this.criticalHigh,
  );

  @override
  bool operator ==(Object other) =>
      other is TargetThresholds &&
      other.lowMax == lowMax &&
      other.normalMax == normalMax &&
      other.warningMax == warningMax &&
      other.criticalLow == criticalLow &&
      other.criticalHigh == criticalHigh;

  @override
  int get hashCode =>
      Object.hash(lowMax, normalMax, warningMax, criticalLow, criticalHigh);
}

/// Ambang bawaan PRD 5.1.
///
/// Satu-satunya sumber kebenaran untuk seed database, tombol "Kembalikan ke
/// default", dan perpindahan preset saat onboarding.
abstract final class TargetPresets {
  static const Map<ReadingType, TargetThresholds> general = {
    ReadingType.fasting: TargetThresholds(
      lowMax: 70,
      normalMax: 99,
      warningMax: 125,
    ),
    ReadingType.random: TargetThresholds(
      lowMax: 70,
      normalMax: 139,
      warningMax: 199,
    ),
    ReadingType.postprandial2h: TargetThresholds(
      lowMax: 70,
      normalMax: 139,
      warningMax: 199,
    ),
  };

  static const Map<ReadingType, TargetThresholds> diabetes = {
    ReadingType.fasting: TargetThresholds(
      lowMax: 70,
      normalMax: 130,
      warningMax: 180,
    ),
    ReadingType.random: TargetThresholds(
      lowMax: 70,
      normalMax: 180,
      warningMax: 250,
    ),
    ReadingType.postprandial2h: TargetThresholds(
      lowMax: 70,
      normalMax: 180,
      warningMax: 250,
    ),
  };

  /// Preset `custom` tidak punya angka bawaan — pengguna sudah menentukan
  /// sendiri, jadi yang dikembalikan adalah preset Umum sebagai titik awal.
  static Map<ReadingType, TargetThresholds> of(TargetPreset preset) =>
      switch (preset) {
        TargetPreset.general => general,
        TargetPreset.diabetes => diabetes,
        TargetPreset.custom => general,
      };

  static TargetThresholds forType(TargetPreset preset, ReadingType type) =>
      of(preset)[type]!;

  /// Mendeteksi preset mana yang cocok dengan sekumpulan ambang, dipakai untuk
  /// menyalakan segmen yang tepat di layar Target setelah data dibaca ulang.
  static TargetPreset detect(Map<ReadingType, TargetThresholds> actual) {
    bool matches(Map<ReadingType, TargetThresholds> preset) =>
        ReadingType.values.every((t) => actual[t] == preset[t]);

    if (matches(general)) return TargetPreset.general;
    if (matches(diabetes)) return TargetPreset.diabetes;
    return TargetPreset.custom;
  }
}
