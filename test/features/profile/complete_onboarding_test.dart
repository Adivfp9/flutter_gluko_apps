import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/error/failures.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_gluko_apps/features/profile/domain/usecases/complete_onboarding.dart';
import 'package:flutter_gluko_apps/features/profile/domain/usecases/save_profile.dart';
import 'package:flutter_gluko_apps/features/reminder/data/repositories/reminder_repository_impl.dart';
import 'package:flutter_gluko_apps/features/target/data/repositories/target_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late CompleteOnboarding completeOnboarding;
  late ProfileRepositoryImpl profiles;
  late TargetRepositoryImpl targets;

  setUp(() {
    db = createTestDatabase();
    profiles = ProfileRepositoryImpl(db.profileDao);
    targets = TargetRepositoryImpl(db.targetDao);
    completeOnboarding = CompleteOnboarding(
      SaveProfile(profiles),
      targets,
      ReminderRepositoryImpl(db.reminderDao),
    );
  });

  tearDown(() => db.close());

  test('menyimpan profil, preset diabetes, dan jam pengingat', () async {
    final result = await completeOnboarding(
      const CompleteOnboardingParams(
        diabetesType: DiabetesType.type2,
        unit: GlucoseUnit.mmolL,
        fastingReminderMinutes: 5 * 60 + 30,
        name: 'Adi',
        birthYear: 1985,
      ),
    );

    expect(result.isRight(), isTrue);

    final profile = (await profiles.getProfile()).getOrElse(
      (_) => throw StateError('profil tidak terbaca'),
    );
    expect(profile.onboardingDone, isTrue);
    expect(profile.name, 'Adi');
    expect(profile.birthYear, 1985);
    expect(profile.diabetesType, DiabetesType.type2);
    expect(profile.unit, GlucoseUnit.mmolL);
    // PRD 5.1: tipe 2 harus memilih preset Diabetes.
    expect(profile.preset, TargetPreset.diabetes);

    final saved = (await targets.getTargets()).getOrElse(
      (_) => throw StateError('target tidak terbaca'),
    );
    expect(saved.forType(ReadingType.fasting).normalMax, 130);
    expect(saved.forType(ReadingType.random).warningMax, 250);
    expect(saved.preset, TargetPreset.diabetes);

    final reminders = await db.reminderDao.all();
    expect(reminders.single.timeOfMinutes, 330);
    expect(reminders.single.isActive, isTrue);
  });

  test('jenis diabetes "tidak tahu" tetap memakai preset Umum', () async {
    await completeOnboarding(
      const CompleteOnboardingParams(
        diabetesType: DiabetesType.unknown,
        unit: GlucoseUnit.mgDl,
        fastingReminderMinutes: 360,
      ),
    );

    final saved = (await targets.getTargets()).getOrElse(
      (_) => throw StateError('target tidak terbaca'),
    );
    expect(saved.forType(ReadingType.fasting).normalMax, 99);
    expect(saved.preset, TargetPreset.general);
  });

  test('tidak memakai pengingat kedua saat dijalankan ulang', () async {
    await completeOnboarding(
      const CompleteOnboardingParams(
        diabetesType: DiabetesType.none,
        unit: GlucoseUnit.mgDl,
        fastingReminderMinutes: 360,
      ),
    );
    await completeOnboarding(
      const CompleteOnboardingParams(
        diabetesType: DiabetesType.none,
        unit: GlucoseUnit.mgDl,
        fastingReminderMinutes: 420,
      ),
    );

    final reminders = await db.reminderDao.all();
    expect(reminders.length, 1, reason: 'pengingat puasa harus di-update');
    expect(reminders.single.timeOfMinutes, 420);

    final profiles2 = await db.profileDao.find();
    expect(profiles2, isNotNull, reason: 'profil tetap satu baris id = 1');
  });

  test('menolak jam pengingat di luar 0..1439', () async {
    final result = await completeOnboarding(
      const CompleteOnboardingParams(
        diabetesType: DiabetesType.none,
        unit: GlucoseUnit.mgDl,
        fastingReminderMinutes: 1440,
      ),
    );

    expect(result.isLeft(), isTrue);
    expect(result.getLeft().toNullable(), isA<ValidationFailure>());

    // Gagal di validasi berarti tidak boleh ada efek samping.
    final profile = await db.profileDao.find();
    expect(profile, isNull);
  });

  test('menolak tahun lahir di masa depan', () async {
    final result = await completeOnboarding(
      CompleteOnboardingParams(
        diabetesType: DiabetesType.none,
        unit: GlucoseUnit.mgDl,
        fastingReminderMinutes: 360,
        birthYear: DateTime.now().year + 1,
      ),
    );

    expect(result.isLeft(), isTrue);
    expect(await db.profileDao.find(), isNull);
  });
}
