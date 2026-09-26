import 'package:flutter_gluko_apps/core/error/failures.dart';
import 'package:flutter_gluko_apps/core/usecase/usecase.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/repositories/glucose_repository.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/classify_reading.dart';
import 'package:flutter_gluko_apps/features/target/domain/entities/target_set.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReclassifyReadings implements UseCase<int, TargetSet> {
  new(this._repository, this._classify);

  final GlucoseRepository _repository;
  final ClassifyReading _classify;

  @override
  Future<Either<Failure, int>> call(TargetSet params) async {
    final result = await _repository.getAllActive();
    final failure = result.getLeft().toNullable();
    if (failure != null) return Left(failure);

    final now = DateTime.now();
    final readings = result.getRight().toNullable()!;
    final updated = [
      for (final reading in readings)
        reading.copyWith(
          status: _classify(
            reading.valueMgDl,
            params.forType(reading.type),
          ).status,
          isCritical: _classify(
            reading.valueMgDl,
            params.forType(reading.type),
          ).isCritical,
          updatedAt: now,
        ),
    ];
    final saved = await _repository.updateClassifications(updated);
    final saveFailure = saved.getLeft().toNullable();
    if (saveFailure != null) return Left(saveFailure);
    return Right(updated.length);
  }
}
