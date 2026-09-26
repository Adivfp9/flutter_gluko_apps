import 'package:drift/drift.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/database/tables/user_profile_table.dart';

part 'profile_dao.g.dart';

@DriftAccessor(tables: [UserProfileTable])
class ProfileDao extends DatabaseAccessor<AppDatabase> with _$ProfileDaoMixin {
  new(super.attachedDatabase);

  /// Profil selalu satu baris dengan `id = 1` (PRD 8.2).
  static const int profileId = 1;

  Future<UserProfileRow?> find() => (select(
    userProfileTable,
  )..where((t) => t.id.equals(profileId))).getSingleOrNull();

  Stream<UserProfileRow?> watch() => (select(
    userProfileTable,
  )..where((t) => t.id.equals(profileId))).watchSingleOrNull();

  /// Menyimpan profil; membuat barisnya bila onboarding baru pertama kali
  /// dijalankan.
  Future<void> save(UserProfileTableCompanion profile) async {
    await into(userProfileTable)
        .insertOnConflictUpdate(profile.copyWith(id: const Value(profileId)));
  }
}
