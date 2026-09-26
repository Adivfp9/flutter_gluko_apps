import 'package:flutter_gluko_apps/core/error/failures.dart';
import 'package:flutter_gluko_apps/features/profile/domain/entities/user_profile.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ProfileRepository {
  /// Mengembalikan profil tersimpan, atau profil default bila onboarding
  /// belum pernah dijalankan.
  Future<Either<Failure, UserProfile>> getProfile();

  Stream<UserProfile> watchProfile();

  Future<Either<Failure, Unit>> saveProfile(UserProfile profile);
}
