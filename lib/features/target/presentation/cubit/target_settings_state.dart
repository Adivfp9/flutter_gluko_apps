import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/utils/unit_converter.dart';
import 'package:flutter_gluko_apps/features/profile/domain/entities/user_profile.dart';
import 'package:flutter_gluko_apps/features/target/domain/entities/target_set.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'target_settings_state.freezed.dart';

enum TargetBoundary { lowMax, normalMax, warningMax }

@freezed
abstract class TargetSettingsState with _$TargetSettingsState {
  const factory({
    @Default(false) bool isLoading,
    @Default(false) bool isSaving,
    @Default(false) bool isReclassifying,
    TargetSet? targets,
    UserProfile? profile,
    @Default(GlucoseUnit.mgDl) GlucoseUnit unit,
    @Default(<String, String>{}) Map<String, String> thresholdInputs,
    @Default(TargetPreset.general) TargetPreset basePreset,
    @Default(false) bool hasUnsavedChanges,
    @Default(false) bool saved,
    String? errorMessage,
    String? infoMessage,
  }) = _TargetSettingsState;

  const new _();

  bool get isReady => !isLoading && targets != null && profile != null;

  TargetPreset get selectedPreset =>
      parsedTargets?.preset ?? targets?.preset ?? TargetPreset.general;

  bool get isBusy => isSaving || isReclassifying;

  String inputFor(ReadingType type, TargetBoundary boundary) =>
      thresholdInputs[_inputKey(type, boundary)] ?? '';

  TargetSet? get parsedTargets {
    final current = targets;
    if (current == null) return null;
    var result = current;
    for (final type in ReadingType.values) {
      final low = UnitConverter.parseToMgDl(
        inputFor(type, TargetBoundary.lowMax),
        unit,
      );
      final normal = UnitConverter.parseToMgDl(
        inputFor(type, TargetBoundary.normalMax),
        unit,
      );
      final warning = UnitConverter.parseToMgDl(
        inputFor(type, TargetBoundary.warningMax),
        unit,
      );
      if (low == null || normal == null || warning == null) return null;
      final old = current.forType(type);
      result = result.replace(
        type,
        old.copyWith(lowMax: low, normalMax: normal, warningMax: warning),
      );
    }
    return result;
  }

  String? get validationMessage {
    if (!isReady) return null;
    if (thresholdInputs.values.any((value) => value.trim().isEmpty)) {
      return 'Semua ambang target wajib diisi.';
    }
    final parsed = parsedTargets;
    if (parsed == null) return 'Masukkan angka target yang valid.';
    if (!parsed.isValid) {
      return 'Ambang harus naik berurutan: rendah < normal < waspada.';
    }
    return null;
  }

  bool get canSave => isReady && !isBusy && validationMessage == null;
}

String targetInputKey(ReadingType type, TargetBoundary boundary) =>
    _inputKey(type, boundary);

String _inputKey(ReadingType type, TargetBoundary boundary) =>
    '${type.dbValue}:${boundary.name}';
