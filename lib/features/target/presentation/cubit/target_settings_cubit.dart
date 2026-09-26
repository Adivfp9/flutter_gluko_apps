import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/error/failures.dart';
import 'package:flutter_gluko_apps/core/usecase/usecase.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/reclassify_readings.dart';
import 'package:flutter_gluko_apps/features/profile/domain/usecases/get_profile.dart';
import 'package:flutter_gluko_apps/features/profile/domain/usecases/save_profile.dart';
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
    this._saveProfile,
    this._reclassifyReadings,
  ) : super(const TargetSettingsState());

  final GetTargets _getTargets;
  final SaveTargets _saveTargets;
  final ResetTargets _resetTargets;
  final GetProfile _getProfile;
  final SaveProfile _saveProfile;
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
      ),
    );
  }

  void selectPreset(TargetPreset preset) {
    if (preset == TargetPreset.custom) return;
    emit(
      state.copyWith(
        targets: TargetSet.fromPreset(preset),
        saved: false,
        errorMessage: null,
        infoMessage: null,
      ),
    );
  }

  void updateThreshold(ReadingType type, TargetBoundary boundary, int value) {
    final targets = state.targets;
    if (targets == null) return;
    final current = targets.forType(type);
    final updated = switch (boundary) {
      TargetBoundary.lowMax => current.copyWith(lowMax: value),
      TargetBoundary.normalMax => current.copyWith(normalMax: value),
      TargetBoundary.warningMax => current.copyWith(warningMax: value),
    };
    emit(
      state.copyWith(
        targets: targets.replace(type, updated),
        saved: false,
        errorMessage: null,
        infoMessage: null,
      ),
    );
  }

  void setUnit(GlucoseUnit unit) => emit(
    state.copyWith(
      unit: unit,
      saved: false,
      errorMessage: null,
      infoMessage: null,
    ),
  );

  Future<void> save() async {
    final targets = state.targets;
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
    final targetResult = await _saveTargets(targets);
    final targetFailure = targetResult.getLeft().toNullable();
    if (targetFailure != null) return _saveFailed(targetFailure);

    final updatedProfile = profile.copyWith(
      unit: state.unit,
      preset: targets.preset,
    );
    final profileResult = await _saveProfile(updatedProfile);
    final profileFailure = profileResult.getLeft().toNullable();
    if (profileFailure != null) return _saveFailed(profileFailure);

    emit(
      state.copyWith(
        isSaving: false,
        saved: true,
        profile: updatedProfile,
        infoMessage: 'Target dan satuan berhasil disimpan.',
      ),
    );
  }

  Future<void> reset() async {
    final preset = state.selectedPreset == TargetPreset.custom
        ? TargetPreset.general
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
            saved: true,
            infoMessage: 'Target dikembalikan ke preset ${preset.label}.',
          ),
        );
    }
  }

  Future<void> reclassify() async {
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
}
