import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/error/failures.dart';
import 'package:flutter_gluko_apps/core/usecase/usecase.dart';
import 'package:flutter_gluko_apps/core/utils/local_date.dart';
import 'package:flutter_gluko_apps/core/utils/unit_converter.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/repositories/glucose_repository.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/classify_reading.dart';
import 'package:flutter_gluko_apps/features/target/domain/repositories/target_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

enum DuplicateFastingAction { reject, replace, saveAsRandom }

class AddReadingParams {
  const new({
    required this.type,
    required this.valueMgDl,
    required this.measuredAt,
    this.tzOffsetMinutes,
    this.mealContext,
    this.hoursAfterMeal,
    this.symptoms = const <Symptom>[],
    this.note,
    this.fastingConfirmed = true,
    this.duplicateAction = DuplicateFastingAction.reject,
  });

  final ReadingType type;
  final int valueMgDl;
  final DateTime measuredAt;
  final int? tzOffsetMinutes;
  final MealContext? mealContext;
  final double? hoursAfterMeal;
  final List<Symptom> symptoms;
  final String? note;
  final bool fastingConfirmed;
  final DuplicateFastingAction duplicateAction;
}

@injectable
class AddReading implements UseCase<GlucoseReading, AddReadingParams> {
  new(this._readings, this._targets, this._classify) : _now = DateTime.now;

  new withClock(this._readings, this._targets, this._classify, this._now);

  final GlucoseRepository _readings;
  final TargetRepository _targets;
  final ClassifyReading _classify;
  final DateTime Function() _now;

  @override
  Future<Either<Failure, GlucoseReading>> call(AddReadingParams params) async {
    final validation = _validate(params);
    if (validation != null) return Left(validation);

    final measuredAtUtc = params.measuredAt.toUtc();
    final offset =
        params.tzOffsetMinutes ?? params.measuredAt.timeZoneOffset.inMinutes;
    final localDate = LocalDate.fromUtc(measuredAtUtc, offset);

    GlucoseReading? existing;
    var effectiveType = params.type;
    if (params.type == ReadingType.fasting) {
      final existingResult = await _readings.findFastingOn(localDate);
      final lookupFailure = existingResult.getLeft().toNullable();
      if (lookupFailure != null) return Left(lookupFailure);
      existing = existingResult.getRight().toNullable();

      if (existing != null &&
          params.duplicateAction == DuplicateFastingAction.reject) {
        return Left(
          DuplicateFastingFailure(
            existingReadingId: existing.id!,
            existingValueMgDl: existing.valueMgDl,
            localDate: localDate,
          ),
        );
      }
      if (existing != null &&
          params.duplicateAction == DuplicateFastingAction.saveAsRandom) {
        effectiveType = ReadingType.random;
      }
    }

    final targetsResult = await _targets.getTargets();
    final targetFailure = targetsResult.getLeft().toNullable();
    if (targetFailure != null) return Left(targetFailure);
    final targetSet = targetsResult.getRight().toNullable()!;
    final classification = _classify(
      params.valueMgDl,
      targetSet.forType(effectiveType),
    );
    final timestamp = _now().toUtc();

    final reading = GlucoseReading(
      id:
          existing != null &&
              params.duplicateAction == DuplicateFastingAction.replace
          ? existing.id
          : null,
      type: effectiveType,
      valueMgDl: params.valueMgDl,
      measuredAt: measuredAtUtc,
      tzOffsetMinutes: offset,
      status: classification.status,
      isCritical: classification.isCritical,
      mealContext: effectiveType == ReadingType.fasting
          ? null
          : params.mealContext,
      hoursAfterMeal: effectiveType == ReadingType.fasting
          ? null
          : params.hoursAfterMeal,
      symptoms: List.unmodifiable(params.symptoms.toSet()),
      note: _normalizedNote(params.note),
      createdAt:
          existing != null &&
              params.duplicateAction == DuplicateFastingAction.replace
          ? existing.createdAt
          : timestamp,
      updatedAt: timestamp,
    );

    if (reading.id != null) return await _readings.update(reading);
    return await _readings.add(reading);
  }

  ValidationFailure? _validate(AddReadingParams params) {
    if (!UnitConverter.isInValidRange(params.valueMgDl)) {
      return const ValidationFailure(
        'Nilai gula darah harus antara 20 dan 600 mg/dL.',
        field: 'value',
      );
    }

    final measuredAt = params.measuredAt.toUtc();
    final now = _now().toUtc();
    if (measuredAt.isAfter(now)) {
      return const ValidationFailure(
        'Waktu pengukuran tidak boleh di masa depan.',
        field: 'measuredAt',
      );
    }
    if (measuredAt.isBefore(now.subtract(const Duration(days: 365)))) {
      return const ValidationFailure(
        'Waktu pengukuran maksimal satu tahun ke belakang.',
        field: 'measuredAt',
      );
    }

    if (params.type == ReadingType.fasting && !params.fastingConfirmed) {
      return const ValidationFailure(
        'Konfirmasikan puasa minimal 8 jam atau pilih tipe Sewaktu.',
        field: 'fasting',
      );
    }

    if ((_normalizedNote(params.note)?.length ?? 0) > 500) {
      return const ValidationFailure(
        'Catatan maksimal 500 karakter.',
        field: 'note',
      );
    }

    return null;
  }

  String? _normalizedNote(String? note) {
    final trimmed = note?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
