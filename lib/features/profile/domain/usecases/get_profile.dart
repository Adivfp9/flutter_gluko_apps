import 'package:flutter_gluko_apps/core/error/failures.dart';
import 'package:flutter_gluko_apps/core/usecase/usecase.dart';
import 'package:flutter_gluko_apps/features/profile/domain/entities/user_profile.dart';
import 'package:flutter_gluko_apps/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProfile implements UseCase<UserProfile, NoParams> {
  new(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, UserProfile>> call(NoParams params) =>
      _repository.getProfile();
}
