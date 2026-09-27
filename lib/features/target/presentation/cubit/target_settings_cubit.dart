import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/error/failures.dart';
import 'package:flutter_gluko_apps/core/usecase/usecase.dart';
import 'package:flutter_gluko_apps/core/utils/unit_converter.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/reclassify_readings.dart';
import 'package:flutter_gluko_apps/features/profile/domain/usecases/get_profile.dart';
import 'package:flutter_gluko_apps/features/target/domain/entities/target_set.dart';
import 'package:flutter_gluko_apps/features/target/domain/usecases/get_targets.dart';
import 'package:flutter_gluko_apps/features/target/domain/usecases/reset_targets.dart';
import 'package:flutter_gluko_apps/features/target/domain/usecases/save_targets.dart';
import 'package:flutter_gluko_apps/features/target/presentation/cubit/target_settings_state.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class TargetSettingsCubit extends Cubit<TargetSettingsState> {
  new(
    this._getTargets,
    this._saveTargets,
    this._resetTargets,
    this._getProfile,
    this._reclassifyReadings,
  ) : super(const TargetSettingsState());

  final GetTargets _getTargets;
  final SaveTargets _saveTargets;
  final ResetTargets _resetTargets;
  final GetProfile _getProfile;
  final ReclassifyReadings _reclassifyReadings;

  Future<void> initialize() async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        infoMessage: null,
        saved: false,
      ),
    );
    final targetsResult = await _getTargets(const NoParams());
    final targetFailure = targetsResult.getLeft().toNullable();
    if (targetFailure != null) return _loadFailed(targetFailure);

    final profileResult = await _getProfile(const NoParams());
    final profileFailure = profileResult.getLeft().toNullable();
    if (profileFailure != null) return _loadFailed(profileFailure);

    final profile = profileResult.getRight().toNullable()!;
    emit(
      state.copyWith(
        isLoading: false,
        targets: targetsResult.getRight().toNullable(),
        profile: profile,
        unit: profile.unit,
        thresholdInputs: _inputsFor(
          targetsResult.getRight().toNullable()!,
          profile.unit,
        ),
        basePreset: profile.preset == TargetPreset.custom
            ? profile.diabetesType.defaultPreset
            : profile.preset,
        hasUnsavedChanges: false,
      ),
    );
  }

  void selectPreset(TargetPreset preset) {
    if (preset == TargetPreset.custom) return;
    emit(
      state.copyWith(
        targets: TargetSet.fromPreset(preset),
        thresholdInputs: _inputsFor(TargetSet.fromPreset(preset), state.unit),
        basePreset: preset,
        hasUnsavedChanges: true,
        saved: false,
        errorMessage: null,
        infoMessage: null,
      ),
    );
  }

  void updateThreshold(ReadingType type, TargetBoundary boundary, int value) {
    updateThresholdInput(
      type,
      boundary,
      UnitConverter.formatValue(value, state.unit),
    );
  }

  void updateThresholdInput(
    ReadingType type,
    TargetBoundary boundary,
    String raw,
  ) {
    final inputs = {...state.thresholdInputs};
    inputs[targetInputKey(type, boundary)] = raw;
    emit(
      state.copyWith(
        thresholdInputs: inputs,
        hasUnsavedChanges: true,
        saved: false,
        errorMessage: null,
        infoMessage: null,
      ),
    );
  }

  void setUnit(GlucoseUnit unit) {
    final targets = state.parsedTargets ?? state.targets;
    if (targets == null) return;
    emit(
      state.copyWith(
        unit: unit,
        thresholdInputs: _inputsFor(targets, unit),
        hasUnsavedChanges: true,
        saved: false,
        errorMessage: null,
        infoMessage: null,
      ),
    );
  }

  Future<void> save() async {
    if (state.isBusy) return;
    final targets = state.parsedTargets;
    final profile = state.profile;
    if (targets == null || profile == null) return;
    if (!targets.isValid) {
      emit(
        state.copyWith(
          saved: false,
          errorMessage:
              'Ambang harus naik berurutan: rendah < normal < waspada.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isSaving: true,
        saved: false,
        errorMessage: null,
        infoMessage: null,
      ),
    );
    final targetResult = await _saveTargets.withUnit(targets, state.unit);
    final targetFailure = targetResult.getLeft().toNullable();
    if (targetFailure != null) return _saveFailed(targetFailure);

    final updatedProfile = profile.copyWith(
      unit: state.unit,
      preset: targets.preset,
    );
    emit(
      state.copyWith(
        isSaving: false,
        saved: true,
        targets: targets,
        profile: updatedProfile,
        hasUnsavedChanges: false,
        infoMessage: 'Target dan satuan berhasil disimpan.',
      ),
    );
  }

  Future<void> reset() async {
    if (state.isBusy) return;
    final preset = state.selectedPreset == TargetPreset.custom
        ? state.basePreset
        : state.selectedPreset;
    emit(state.copyWith(isSaving: true, errorMessage: null, saved: false));
    final result = await _resetTargets(preset);
    switch (result) {
      case Left(value: final failure):
        _saveFailed(failure);
      case Right(value: final targets):
        emit(
          state.copyWith(
            isSaving: false,
            targets: targets,
            thresholdInputs: _inputsFor(targets, state.unit),
            basePreset: preset,
            hasUnsavedChanges: false,
            saved: true,
            infoMessage: 'Target dikembalikan ke preset ${preset.label}.',
          ),
        );
    }
  }

  Future<void> reclassify() async {
    if (state.isBusy) return;
    if (state.hasUnsavedChanges) {
      emit(
        state.copyWith(
          errorMessage: 'Simpan target terlebih dahulu sebelum hitung ulang.',
        ),
      );
      return;
    }
    final targets = state.targets;
    if (targets == null || !targets.isValid) return;
    emit(
      state.copyWith(
        isReclassifying: true,
        errorMessage: null,
        infoMessage: null,
      ),
    );
    final result = await _reclassifyReadings(targets);
    switch (result) {
      case Left(value: final failure):
        emit(
          state.copyWith(isReclassifying: false, errorMessage: failure.message),
        );
      case Right(value: final count):
        emit(
          state.copyWith(
            isReclassifying: false,
            infoMessage: '$count catatan berhasil dihitung ulang.',
          ),
        );
    }
  }

  void _loadFailed(Failure failure) =>
      emit(state.copyWith(isLoading: false, errorMessage: failure.message));

  void _saveFailed(Failure failure) => emit(
    state.copyWith(
      isSaving: false,
      saved: false,
      errorMessage: failure.message,
    ),
  );

  Map<String, String> _inputsFor(TargetSet targets, GlucoseUnit unit) => {
    for (final type in ReadingType.values) ...{
      targetInputKey(type, TargetBoundary.lowMax): UnitConverter.formatValue(
        targets.forType(type).lowMax,
        unit,
      ),
      targetInputKey(type, TargetBoundary.normalMax): UnitConverter.formatValue(
        targets.forType(type).normalMax,
        unit,
      ),
      targetInputKey(type, TargetBoundary.warningMax):
          UnitConverter.formatValue(targets.forType(type).warningMax, unit),
    },
  };
}
