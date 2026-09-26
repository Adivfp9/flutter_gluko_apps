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
import 'package:meta/meta.dart';

@immutable
class UpdateReadingParams {
  const new({
    required this.id,
    required this.type,
    required this.valueMgDl,
    required this.measuredAt,
    this.mealContext,
    this.hoursAfterMeal,
    this.symptoms = const [],
    this.note = '',
  });

  final int id;
  final ReadingType type;
  final int valueMgDl;
  final DateTime measuredAt;
  final MealContext? mealContext;
  final double? hoursAfterMeal;
  final List<Symptom> symptoms;
  final String note;
}

/// Menyunting catatan yang sudah tersimpan (PRD F-05 AC3).
///
/// Status dihitung ulang memakai target yang berlaku **saat penyuntingan**.
/// Ini konsisten dengan F-02 AC2: status adalah snapshot pada saat nilainya
/// ditetapkan, dan menyunting nilai berarti menetapkannya ulang.
@injectable
class UpdateReading implements UseCase<GlucoseReading, UpdateReadingParams> {
  const new(this._repository, this._targets, this._classify);

  final GlucoseRepository _repository;
  final TargetRepository _targets;
  final ClassifyReading _classify;

  @override
  Future<Either<Failure, GlucoseReading>> call(
    UpdateReadingParams params,
  ) async {
    if (!UnitConverter.isInValidRange(params.valueMgDl)) {
      return const Left(
        ValidationFailure(
          'Nilai harus antara ${UnitConverter.minMgDl} dan '
          '${UnitConverter.maxMgDl} mg/dL.',
          field: 'value',
        ),
      );
    }

    final now = DateTime.now();
    if (params.measuredAt.isAfter(now)) {
      return const Left(
        ValidationFailure(
          'Waktu pengukuran tidak boleh di masa depan.',
          field: 'measuredAt',
        ),
      );
    }
    if (params.measuredAt.isBefore(
      DateTime(now.year - 1, now.month, now.day),
    )) {
      return const Left(
        ValidationFailure(
          'Waktu pengukuran maksimal satu tahun ke belakang.',
          field: 'measuredAt',
        ),
      );
    }
    if (params.note.trim().length > 500) {
      return const Left(
        ValidationFailure('Catatan maksimal 500 karakter.', field: 'note'),
      );
    }

    final existingResult = await _repository.findById(params.id);
    if (existingResult case Left(value: final failure)) {
      return Left(failure);
    }
    final existing = existingResult.getOrElse((_) => null);
    if (existing == null) return const Left(NotFoundFailure());

    final targetsResult = await _targets.getTargets();
    if (targetsResult case Left(value: final failure)) {
      return Left(failure);
    }
    final targets = targetsResult.getOrElse(
      (_) => throw StateError('unreachable'),
    );

    final classification = _classify(
      params.valueMgDl,
      targets.forType(params.type),
    );

    final tzOffset = params.measuredAt.timeZoneOffset.inMinutes;

    // Pindah tipe ke Puasa hanya boleh bila tanggal itu belum punya GDP lain.
    if (params.type == ReadingType.fasting) {
      final localDate = LocalDate.fromUtc(params.measuredAt.toUtc(), tzOffset);
      final existingFasting = await _repository.findFastingOn(localDate);
      if (existingFasting case Right(value: final other?)
          when other.id != params.id) {
        return Left(
          DuplicateFastingFailure(
            existingReadingId: other.id!,
            existingValueMgDl: other.valueMgDl,
            localDate: localDate,
          ),
        );
      }
    }

    return await _repository.update(
      existing.copyWith(
        type: params.type,
        valueMgDl: params.valueMgDl,
        measuredAt: params.measuredAt.toUtc(),
        tzOffsetMinutes: tzOffset,
        status: classification.status,
        isCritical: classification.isCritical,
        mealContext: params.type == ReadingType.fasting
            ? null
            : params.mealContext,
        hoursAfterMeal: params.type == ReadingType.fasting
            ? null
            : params.hoursAfterMeal,
        symptoms: params.symptoms,
        note: params.note.trim().isEmpty ? null : params.note.trim(),
        updatedAt: now,
      ),
    );
  }
}
