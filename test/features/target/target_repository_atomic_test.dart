import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_gluko_apps/features/profile/domain/entities/user_profile.dart';
import 'package:flutter_gluko_apps/features/target/data/repositories/target_repository_impl.dart';
import 'package:flutter_gluko_apps/features/target/domain/entities/target_set.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_database.dart';

void main() {
  test('target di-rollback bila penyimpanan profil gagal', () async {
    final db = createTestDatabase();
    addTearDown(db.close);
    final targets = TargetRepositoryImpl(db.targetDao);
    final profiles = ProfileRepositoryImpl(db.profileDao);
    await profiles.saveProfile(const UserProfile(onboardingDone: true));
    await db.customStatement('''
      CREATE TRIGGER fail_profile_update
      BEFORE UPDATE ON user_profile
      BEGIN
        SELECT RAISE(ABORT, 'profile write failed');
      END;
    ''');

    final result = await targets.saveTargetsAndProfile(
      TargetSet.fromPreset(TargetPreset.diabetes),
      const UserProfile(
        unit: GlucoseUnit.mmolL,
        preset: TargetPreset.diabetes,
        onboardingDone: true,
      ),
    );

    expect(result.isLeft(), isTrue);
    final storedTargets = (await targets.getTargets()).getRight().toNullable()!;
    expect(storedTargets.preset, TargetPreset.general);
    final storedProfile = (await profiles.getProfile())
        .getRight()
        .toNullable()!;
    expect(storedProfile.unit, GlucoseUnit.mgDl);
    expect(storedProfile.preset, TargetPreset.general);
  });
}
