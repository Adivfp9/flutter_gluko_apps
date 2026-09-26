import 'package:flutter_gluko_apps/core/error/failures.dart';
import 'package:flutter_gluko_apps/core/usecase/usecase.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/repositories/glucose_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class FindFastingOn implements UseCase<GlucoseReading?, String> {
  new(this._repository);

  final GlucoseRepository _repository;

  @override
  Future<Either<Failure, GlucoseReading?>> call(String localDate) =>
      _repository.findFastingOn(localDate);
}
