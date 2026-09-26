import 'package:flutter_gluko_apps/core/error/failures.dart';
import 'package:flutter_gluko_apps/features/profile/domain/entities/user_profile.dart';
import 'package:flutter_gluko_apps/features/target/domain/entities/target_set.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class TargetRepository {
  Future<Either<Failure, TargetSet>> getTargets();

  Stream<TargetSet> watchTargets();

  Future<Either<Failure, Unit>> saveTargets(TargetSet targets);

  Future<Either<Failure, Unit>> saveTargetsAndProfile(
    TargetSet targets,
    UserProfile profile,
  );
}
