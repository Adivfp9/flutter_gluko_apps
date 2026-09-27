import 'package:clock/clock.dart';
import 'package:drift/drift.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/error/failures.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/database/daos/profile_dao.dart';
import 'package:flutter_gluko_apps/features/profile/domain/entities/user_profile.dart';
import 'package:flutter_gluko_apps/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  new(this._dao);

  final ProfileDao _dao;

  @override
  Future<Either<Failure, UserProfile>> getProfile() async {
    try {
      final row = await _dao.find();
      return Right(row == null ? const UserProfile() : _toEntity(row));
    } on Object catch (e) {
      return Left(DatabaseFailure('Gagal membaca profil: $e'));
    }
  }

  @override
  Stream<UserProfile> watchProfile() => _dao.watch().map(
    (row) => row == null ? const UserProfile() : _toEntity(row),
  );

  @override
  Future<Either<Failure, Unit>> saveProfile(UserProfile profile) async {
    try {
      final now = clock.now().millisecondsSinceEpoch;
      await _dao.save(
        UserProfileTableCompanion.insert(
          name: Value(profile.name),
          birthYear: Value(profile.birthYear),
          diabetesType: Value(profile.diabetesType.dbValue),
          unit: Value(profile.unit.dbValue),
          preset: Value(profile.preset.dbValue),
          onboardingDone: Value(profile.onboardingDone),
          createdAt: profile.createdAt?.millisecondsSinceEpoch ?? now,
          updatedAt: now,
        ),
      );
      return const Right(unit);
    } on Object catch (e) {
      return Left(DatabaseFailure('Gagal menyimpan profil: $e'));
    }
  }

  UserProfile _toEntity(UserProfileRow row) => UserProfile(
    name: row.name,
    birthYear: row.birthYear,
    diabetesType: DiabetesType.fromDb(row.diabetesType),
    unit: GlucoseUnit.fromDb(row.unit),
    preset: TargetPreset.fromDb(row.preset),
    onboardingDone: row.onboardingDone,
    createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
  );
}
