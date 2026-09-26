import 'package:flutter_gluko_apps/core/error/failures.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/glucose_reading.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class GlucoseRepository {
  Future<Either<Failure, GlucoseReading?>> findById(int id);

  Future<Either<Failure, GlucoseReading?>> findFastingOn(String localDate);

  Future<Either<Failure, GlucoseReading>> add(GlucoseReading reading);

  Future<Either<Failure, GlucoseReading>> update(GlucoseReading reading);

  Future<Either<Failure, List<GlucoseReading>>> getAllActive();

  Future<Either<Failure, Unit>> updateClassifications(
    List<GlucoseReading> readings,
  );
}
