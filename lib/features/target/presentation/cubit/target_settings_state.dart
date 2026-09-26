import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
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
    @Default(false) bool saved,
    String? errorMessage,
    String? infoMessage,
  }) = _TargetSettingsState;

  const new _();

  bool get isReady => !isLoading && targets != null && profile != null;

  TargetPreset get selectedPreset => targets?.preset ?? TargetPreset.general;

  bool get canSave =>
      isReady && !isSaving && !isReclassifying && targets!.isValid;
}
