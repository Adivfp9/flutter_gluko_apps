import 'package:clock/clock.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/error/failures.dart';
import 'package:flutter_gluko_apps/core/usecase/usecase.dart';
import 'package:flutter_gluko_apps/features/profile/domain/entities/user_profile.dart';
import 'package:flutter_gluko_apps/features/profile/domain/usecases/save_profile.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/repositories/reminder_repository.dart';
import 'package:flutter_gluko_apps/features/target/domain/entities/target_set.dart';
import 'package:flutter_gluko_apps/features/target/domain/repositories/target_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

@immutable
class OnboardingResult {
  const new(this.profile, this.targets);

  final UserProfile profile;
  final TargetSet targets;
}

@immutable
class CompleteOnboardingParams {
  const new({
    required this.diabetesType,
    required this.unit,
    required this.fastingReminderMinutes,
    this.name,
    this.birthYear,
    this.enableFastingReminder = true,
  });

  final DiabetesType diabetesType;
  final GlucoseUnit unit;

  /// Menit sejak tengah malam untuk pengingat cek puasa (PRD F-10 AC1).
  final int fastingReminderMinutes;

  final String? name;
  final int? birthYear;
  final bool enableFastingReminder;
}

/// Menutup onboarding: menyimpan profil, menerapkan preset target sesuai jenis
/// diabetes (PRD 5.1), dan menyetel jam pengingat puasa.
///
/// Ketiganya dijalankan berurutan dan berhenti pada kegagalan pertama, supaya
/// pengguna tidak berakhir dengan profil tersimpan tetapi target masih bawaan.
@injectable
class CompleteOnboarding
    implements UseCase<OnboardingResult, CompleteOnboardingParams> {
  new(this._saveProfile, this._targets, this._reminders);

  final SaveProfile _saveProfile;
  final TargetRepository _targets;
  final ReminderRepository _reminders;

  @override
  Future<Either<Failure, OnboardingResult>> call(
    CompleteOnboardingParams params,
  ) async {
    if (params.fastingReminderMinutes < 0 ||
        params.fastingReminderMinutes > 1439) {
      return const Left(ValidationFailure('Jam pengingat tidak valid.'));
    }

    final preset = params.diabetesType.defaultPreset;
    final profile = UserProfile(
      name: params.name,
      birthYear: params.birthYear,
      diabetesType: params.diabetesType,
      unit: params.unit,
      preset: preset,
      onboardingDone: true,
      createdAt: clock.now(),
    );

    final savedProfile = await _saveProfile(profile);
    if (savedProfile case Left(value: final failure)) {
      return Left(failure);
    }

    final targets = TargetSet.fromPreset(preset);
    final savedTargets = await _targets.saveTargets(targets);
    if (savedTargets case Left(value: final failure)) {
      return Left(failure);
    }

    final scheduled = await _reminders.setFastingReminder(
      timeOfMinutes: params.fastingReminderMinutes,
      isActive: params.enableFastingReminder,
    );

    return scheduled.map((_) => OnboardingResult(profile, targets));
  }
}
