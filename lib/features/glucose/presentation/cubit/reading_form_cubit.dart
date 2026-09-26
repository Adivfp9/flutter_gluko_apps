import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/error/failures.dart';
import 'package:flutter_gluko_apps/core/usecase/usecase.dart';
import 'package:flutter_gluko_apps/core/utils/local_date.dart';
import 'package:flutter_gluko_apps/core/utils/unit_converter.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/add_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/classify_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/find_fasting_on.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/update_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/presentation/cubit/reading_form_state.dart';
import 'package:flutter_gluko_apps/features/profile/domain/usecases/get_profile.dart';
import 'package:flutter_gluko_apps/features/target/domain/usecases/get_targets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReadingFormCubit extends Cubit<ReadingFormState> {
  new(
    this._addReading,
    this._updateReading,
    this._getTargets,
    this._getProfile,
    this._findFastingOn,
    this._classify,
  ) : _now = DateTime.now,
      super(const ReadingFormState());

  new withClock(
    this._addReading,
    this._updateReading,
    this._getTargets,
    this._getProfile,
    this._findFastingOn,
    this._classify,
    this._now,
  ) : super(const ReadingFormState());

  final AddReading _addReading;
  final UpdateReading _updateReading;
  final GetTargets _getTargets;
  final GetProfile _getProfile;
  final FindFastingOn _findFastingOn;
  final ClassifyReading _classify;
  final DateTime Function() _now;

  Future<void> initialize({ReadingType? initialType}) async {
    emit(
      state.copyWith(
        isLoading: true,
        isSubmitting: false,
        rawValue: '',
        valueMgDl: null,
        classification: null,
        fastingConfirmed: true,
        mealContext: null,
        hoursAfterMeal: null,
        symptoms: const <Symptom>{},
        note: '',
        errorMessage: null,
        savedReading: null,
        duplicateFasting: null,
      ),
    );

    final profileResult = await _getProfile(const NoParams());
    final profileFailure = profileResult.getLeft().toNullable();
    if (profileFailure != null) return _initializationFailed(profileFailure);

    final targetsResult = await _getTargets(const NoParams());
    final targetsFailure = targetsResult.getLeft().toNullable();
    if (targetsFailure != null) return _initializationFailed(targetsFailure);

    final now = _now();
    var type = initialType;
    if (type == null) {
      type = ReadingType.random;
      if (now.hour >= 4 && now.hour < 10) {
        final existingResult = await _findFastingOn(LocalDate.ofLocal(now));
        final failure = existingResult.getLeft().toNullable();
        if (failure != null) return _initializationFailed(failure);
        if (existingResult.getRight().toNullable() == null) {
          type = ReadingType.fasting;
        }
      }
    }

    emit(
      state.copyWith(
        isLoading: false,
        type: type,
        unit: profileResult.getRight().toNullable()!.unit,
        targets: targetsResult.getRight().toNullable(),
        measuredAt: now,
        mealContext: type == ReadingType.postprandial2h
            ? MealContext.afterMeal
            : null,
        hoursAfterMeal: type == ReadingType.postprandial2h ? 2 : null,
      ),
    );
    _refreshClassification();
  }

  /// Memuat form untuk menyunting catatan lama (PRD F-05 AC3).
  ///
  /// Seluruh field diisi dari catatan yang ada, termasuk waktu pengukurannya,
  /// supaya menyimpan tanpa mengubah apa pun tidak menggeser data.
  Future<void> initializeForEdit(GlucoseReading reading) async {
    emit(
      state.copyWith(
        isLoading: true,
        isSubmitting: false,
        errorMessage: null,
        savedReading: null,
        duplicateFasting: null,
      ),
    );

    final profileResult = await _getProfile(const NoParams());
    final profileFailure = profileResult.getLeft().toNullable();
    if (profileFailure != null) return _initializationFailed(profileFailure);

    final targetsResult = await _getTargets(const NoParams());
    final targetsFailure = targetsResult.getLeft().toNullable();
    if (targetsFailure != null) return _initializationFailed(targetsFailure);

    final unit = profileResult.getRight().toNullable()!.unit;

    emit(
      state.copyWith(
        isLoading: false,
        editingId: reading.id,
        type: reading.type,
        unit: unit,
        targets: targetsResult.getRight().toNullable(),
        valueMgDl: reading.valueMgDl,
        rawValue: UnitConverter.formatValue(reading.valueMgDl, unit),
        measuredAt: reading.measuredAtLocal,
        mealContext: reading.mealContext,
        hoursAfterMeal: reading.hoursAfterMeal,
        symptoms: reading.symptoms.toSet(),
        note: reading.note ?? '',
        // Catatan puasa yang sudah tersimpan berarti konfirmasinya pernah
        // diberikan; tidak perlu diminta ulang saat menyunting.
        fastingConfirmed: true,
      ),
    );
    _refreshClassification();
  }

  void setValue(String raw) {
    final value = UnitConverter.parseToMgDl(raw, state.unit);
    emit(
      state.copyWith(
        rawValue: raw,
        valueMgDl: value,
        errorMessage: null,
        savedReading: null,
      ),
    );
    _refreshClassification();
  }

  void setType(ReadingType type) {
    final isPostprandial = type == ReadingType.postprandial2h;
    final keepRandomMealTiming =
        type == ReadingType.random &&
        state.mealContext == MealContext.afterMeal;
    emit(
      state.copyWith(
        type: type,
        mealContext: type == ReadingType.fasting
            ? null
            : isPostprandial
            ? MealContext.afterMeal
            : state.mealContext,
        hoursAfterMeal: isPostprandial
            ? state.hoursAfterMeal ?? 2
            : keepRandomMealTiming
            ? state.hoursAfterMeal ?? 2
            : null,
        duplicateFasting: null,
        errorMessage: null,
        savedReading: null,
      ),
    );
    _refreshClassification();
  }

  void setMeasuredAt(DateTime value) => emit(
    state.copyWith(
      measuredAt: value,
      duplicateFasting: null,
      errorMessage: null,
    ),
  );

  void setFastingConfirmed({required bool value}) =>
      emit(state.copyWith(fastingConfirmed: value, errorMessage: null));

  void setMealContext(MealContext? value) => emit(
    state.copyWith(
      mealContext: value,
      hoursAfterMeal: value == MealContext.afterMeal
          ? state.hoursAfterMeal ?? 2
          : null,
      errorMessage: null,
    ),
  );

  void setHoursAfterMeal(double? value) =>
      emit(state.copyWith(hoursAfterMeal: value, errorMessage: null));

  void toggleSymptom(Symptom symptom) {
    final selected = {...state.symptoms};
    selected.contains(symptom)
        ? selected.remove(symptom)
        : selected.add(symptom);
    emit(state.copyWith(symptoms: selected, errorMessage: null));
  }

  void setNote(String value) =>
      emit(state.copyWith(note: value, errorMessage: null));

  void appendKey(String key) {
    if (key == 'C') return setValue('');
    if (key == '⌫') {
      if (state.rawValue.isNotEmpty) {
        setValue(state.rawValue.substring(0, state.rawValue.length - 1));
      }
      return;
    }
    final separator = state.unit == GlucoseUnit.mmolL ? ',' : '';
    if (key == separator && state.rawValue.contains(separator)) return;
    final maxLength = state.unit == GlucoseUnit.mgDl ? 3 : 4;
    if (state.rawValue.length >= maxLength) return;
    if (state.rawValue.isEmpty && key == '0') return;
    setValue('${state.rawValue}$key');
  }

  Future<void> submit({
    DuplicateFastingAction duplicateAction = DuplicateFastingAction.reject,
  }) async {
    if (!state.canSubmit) {
      emit(state.copyWith(errorMessage: _validationMessage()));
      return;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        errorMessage: null,
        duplicateFasting: null,
        savedReading: null,
      ),
    );
    final editingId = state.editingId;
    final result = editingId == null
        ? await _addReading(
            AddReadingParams(
              type: state.type,
              valueMgDl: state.valueMgDl!,
              measuredAt: state.measuredAt!,
              mealContext: state.mealContext,
              hoursAfterMeal: state.hoursAfterMeal,
              symptoms: state.symptoms.toList(growable: false),
              note: state.note,
              fastingConfirmed: state.fastingConfirmed,
              duplicateAction: duplicateAction,
            ),
          )
        : await _updateReading(
            UpdateReadingParams(
              id: editingId,
              type: state.type,
              valueMgDl: state.valueMgDl!,
              measuredAt: state.measuredAt!,
              mealContext: state.mealContext,
              hoursAfterMeal: state.hoursAfterMeal,
              symptoms: state.symptoms.toList(growable: false),
              note: state.note,
            ),
          );

    switch (result) {
      case Left(value: final DuplicateFastingFailure failure):
        emit(
          state.copyWith(
            isSubmitting: false,
            duplicateFasting: failure,
            errorMessage: failure.message,
          ),
        );
      case Left(value: final failure):
        emit(
          state.copyWith(isSubmitting: false, errorMessage: failure.message),
        );
      case Right(value: final reading):
        emit(
          state.copyWith(
            isSubmitting: false,
            duplicateFasting: null,
            savedReading: reading,
          ),
        );
    }
  }

  Future<void> resolveDuplicate(DuplicateFastingAction action) =>
      submit(duplicateAction: action);

  void dismissDuplicate() =>
      emit(state.copyWith(duplicateFasting: null, errorMessage: null));

  void _refreshClassification() {
    final value = state.valueMgDl;
    final targets = state.targets;
    emit(
      state.copyWith(
        classification: value == null || targets == null
            ? null
            : _classify(value, targets.forType(state.type)),
      ),
    );
  }

  void _initializationFailed(Failure failure) =>
      emit(state.copyWith(isLoading: false, errorMessage: failure.message));

  String _validationMessage() {
    if (state.valueMgDl == null) return 'Masukkan nilai gula darah.';
    if (!UnitConverter.isInValidRange(state.valueMgDl!)) {
      return 'Nilai gula darah harus antara 20 dan 600 mg/dL.';
    }
    if (state.type == ReadingType.fasting && !state.fastingConfirmed) {
      return 'Konfirmasikan puasa minimal 8 jam atau pilih tipe Sewaktu.';
    }
    if (state.note.trim().length > 500) {
      return 'Catatan maksimal 500 karakter.';
    }
    return 'Lengkapi data pengukuran terlebih dahulu.';
  }
}
