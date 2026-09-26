import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/error/failures.dart';
import 'package:flutter_gluko_apps/core/utils/unit_converter.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/classify_reading.dart';
import 'package:flutter_gluko_apps/features/target/domain/entities/target_set.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reading_form_state.freezed.dart';

@freezed
abstract class ReadingFormState with _$ReadingFormState {
  const factory({
    @Default(false) bool isLoading,
    @Default(false) bool isSubmitting,
    @Default(ReadingType.random) ReadingType type,
    @Default(GlucoseUnit.mgDl) GlucoseUnit unit,
    @Default('') String rawValue,
    int? valueMgDl,
    DateTime? measuredAt,
    TargetSet? targets,
    Classification? classification,
    @Default(true) bool fastingConfirmed,
    MealContext? mealContext,
    double? hoursAfterMeal,
    @Default(<Symptom>{}) Set<Symptom> symptoms,
    @Default('') String note,
    String? errorMessage,
    DuplicateFastingFailure? duplicateFasting,
    GlucoseReading? savedReading,
  }) = _ReadingFormState;

  const new _();

  bool get isReady => !isLoading && measuredAt != null && targets != null;

  bool get canSubmit =>
      isReady &&
      !isSubmitting &&
      valueMgDl != null &&
      UnitConverter.isInValidRange(valueMgDl!) &&
      (type != ReadingType.fasting || fastingConfirmed) &&
      note.trim().length <= 500;
}
