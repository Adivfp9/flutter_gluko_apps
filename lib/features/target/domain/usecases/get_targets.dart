import 'package:flutter_gluko_apps/core/error/failures.dart';
import 'package:flutter_gluko_apps/core/usecase/usecase.dart';
import 'package:flutter_gluko_apps/features/target/domain/entities/target_set.dart';
import 'package:flutter_gluko_apps/features/target/domain/repositories/target_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetTargets implements UseCase<TargetSet, NoParams> {
  new(this._repository);

  final TargetRepository _repository;

  @override
  Future<Either<Failure, TargetSet>> call(NoParams params) =>
      _repository.getTargets();
}
