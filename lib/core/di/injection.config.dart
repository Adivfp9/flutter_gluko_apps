// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:flutter_gluko_apps/core/di/database_module.dart' as _i528;
import 'package:flutter_gluko_apps/database/app_database.dart' as _i974;
import 'package:flutter_gluko_apps/database/connection/database_key_store.dart'
    as _i397;
import 'package:flutter_gluko_apps/database/daos/glucose_dao.dart' as _i305;
import 'package:flutter_gluko_apps/database/daos/profile_dao.dart' as _i598;
import 'package:flutter_gluko_apps/database/daos/reminder_dao.dart' as _i216;
import 'package:flutter_gluko_apps/database/daos/settings_dao.dart' as _i851;
import 'package:flutter_gluko_apps/database/daos/target_dao.dart' as _i385;
import 'package:flutter_gluko_apps/features/glucose/data/repositories/glucose_repository_impl.dart'
    as _i27;
import 'package:flutter_gluko_apps/features/glucose/domain/repositories/glucose_repository.dart'
    as _i848;
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/add_reading.dart'
    as _i104;
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/build_dashboard_summary.dart'
    as _i239;
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/classify_reading.dart'
    as _i725;
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/delete_reading.dart'
    as _i1073;
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/find_fasting_on.dart'
    as _i360;
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/reclassify_readings.dart'
    as _i146;
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/watch_dashboard.dart'
    as _i39;
import 'package:flutter_gluko_apps/features/glucose/presentation/cubit/dashboard_cubit.dart'
    as _i94;
import 'package:flutter_gluko_apps/features/glucose/presentation/cubit/reading_form_cubit.dart'
    as _i89;
import 'package:flutter_gluko_apps/features/onboarding/presentation/cubit/onboarding_cubit.dart'
    as _i1062;
import 'package:flutter_gluko_apps/features/profile/data/repositories/profile_repository_impl.dart'
    as _i155;
import 'package:flutter_gluko_apps/features/profile/domain/repositories/profile_repository.dart'
    as _i525;
import 'package:flutter_gluko_apps/features/profile/domain/usecases/complete_onboarding.dart'
    as _i93;
import 'package:flutter_gluko_apps/features/profile/domain/usecases/get_profile.dart'
    as _i849;
import 'package:flutter_gluko_apps/features/profile/domain/usecases/save_profile.dart'
    as _i550;
import 'package:flutter_gluko_apps/features/reminder/data/repositories/reminder_repository_impl.dart'
    as _i212;
import 'package:flutter_gluko_apps/features/reminder/domain/repositories/reminder_repository.dart'
    as _i344;
import 'package:flutter_gluko_apps/features/startup/domain/usecases/app_startup.dart'
    as _i391;
import 'package:flutter_gluko_apps/features/target/data/repositories/target_repository_impl.dart'
    as _i224;
import 'package:flutter_gluko_apps/features/target/domain/repositories/target_repository.dart'
    as _i634;
import 'package:flutter_gluko_apps/features/target/domain/usecases/get_targets.dart'
    as _i135;
import 'package:flutter_gluko_apps/features/target/domain/usecases/reset_targets.dart'
    as _i534;
import 'package:flutter_gluko_apps/features/target/domain/usecases/save_targets.dart'
    as _i521;
import 'package:flutter_gluko_apps/features/target/presentation/cubit/target_settings_cubit.dart'
    as _i539;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final databaseModule = _$DatabaseModule();
    gh.factory<_i239.BuildDashboardSummary>(
      () => const _i239.BuildDashboardSummary(),
    );
    gh.factory<_i725.ClassifyReading>(() => const _i725.ClassifyReading());
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => databaseModule.secureStorage,
    );
    gh.lazySingleton<_i397.DatabaseKeyStore>(
      () => _i397.DatabaseKeyStore(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i974.AppDatabase>(
      () => databaseModule.database(gh<_i397.DatabaseKeyStore>()),
    );
    gh.lazySingleton<_i305.GlucoseDao>(
      () => databaseModule.glucoseDao(gh<_i974.AppDatabase>()),
    );
    gh.lazySingleton<_i598.ProfileDao>(
      () => databaseModule.profileDao(gh<_i974.AppDatabase>()),
    );
    gh.lazySingleton<_i385.TargetDao>(
      () => databaseModule.targetDao(gh<_i974.AppDatabase>()),
    );
    gh.lazySingleton<_i216.ReminderDao>(
      () => databaseModule.reminderDao(gh<_i974.AppDatabase>()),
    );
    gh.lazySingleton<_i851.SettingsDao>(
      () => databaseModule.settingsDao(gh<_i974.AppDatabase>()),
    );
    gh.lazySingleton<_i344.ReminderRepository>(
      () => _i212.ReminderRepositoryImpl(gh<_i216.ReminderDao>()),
    );
    gh.lazySingleton<_i848.GlucoseRepository>(
      () => _i27.GlucoseRepositoryImpl(gh<_i305.GlucoseDao>()),
    );
    gh.factory<_i146.ReclassifyReadings>(
      () => _i146.ReclassifyReadings(
        gh<_i848.GlucoseRepository>(),
        gh<_i725.ClassifyReading>(),
      ),
    );
    gh.lazySingleton<_i634.TargetRepository>(
      () => _i224.TargetRepositoryImpl(gh<_i385.TargetDao>()),
    );
    gh.factory<_i1073.DeleteReading>(
      () => _i1073.DeleteReading(gh<_i848.GlucoseRepository>()),
    );
    gh.factory<_i1073.RestoreReading>(
      () => _i1073.RestoreReading(gh<_i848.GlucoseRepository>()),
    );
    gh.factory<_i360.FindFastingOn>(
      () => _i360.FindFastingOn(gh<_i848.GlucoseRepository>()),
    );
    gh.lazySingleton<_i525.ProfileRepository>(
      () => _i155.ProfileRepositoryImpl(gh<_i598.ProfileDao>()),
    );
    gh.factory<_i39.WatchDashboard>(
      () => _i39.WatchDashboard(
        gh<_i848.GlucoseRepository>(),
        gh<_i239.BuildDashboardSummary>(),
      ),
    );
    gh.lazySingleton<_i391.AppStartup>(
      () => _i391.AppStartup(
        gh<_i974.AppDatabase>(),
        gh<_i851.SettingsDao>(),
        gh<_i525.ProfileRepository>(),
      ),
    );
    gh.factory<_i521.SaveTargets>(
      () => _i521.SaveTargets(
        gh<_i634.TargetRepository>(),
        gh<_i525.ProfileRepository>(),
      ),
    );
    gh.factory<_i135.GetTargets>(
      () => _i135.GetTargets(gh<_i634.TargetRepository>()),
    );
    gh.factory<_i534.ResetTargets>(
      () => _i534.ResetTargets(gh<_i521.SaveTargets>()),
    );
    gh.factory<_i849.GetProfile>(
      () => _i849.GetProfile(gh<_i525.ProfileRepository>()),
    );
    gh.factory<_i550.SaveProfile>(
      () => _i550.SaveProfile(gh<_i525.ProfileRepository>()),
    );
    gh.factory<_i104.AddReading>(
      () => _i104.AddReading(
        gh<_i848.GlucoseRepository>(),
        gh<_i634.TargetRepository>(),
        gh<_i725.ClassifyReading>(),
      ),
    );
    gh.factory<_i94.DashboardCubit>(
      () => _i94.DashboardCubit(
        gh<_i39.WatchDashboard>(),
        gh<_i525.ProfileRepository>(),
      ),
    );
    gh.factory<_i539.TargetSettingsCubit>(
      () => _i539.TargetSettingsCubit(
        gh<_i135.GetTargets>(),
        gh<_i521.SaveTargets>(),
        gh<_i534.ResetTargets>(),
        gh<_i849.GetProfile>(),
        gh<_i146.ReclassifyReadings>(),
      ),
    );
    gh.factory<_i89.ReadingFormCubit>(
      () => _i89.ReadingFormCubit(
        gh<_i104.AddReading>(),
        gh<_i135.GetTargets>(),
        gh<_i849.GetProfile>(),
        gh<_i360.FindFastingOn>(),
        gh<_i725.ClassifyReading>(),
      ),
    );
    gh.factory<_i93.CompleteOnboarding>(
      () => _i93.CompleteOnboarding(
        gh<_i550.SaveProfile>(),
        gh<_i634.TargetRepository>(),
        gh<_i344.ReminderRepository>(),
      ),
    );
    gh.factory<_i1062.OnboardingCubit>(
      () => _i1062.OnboardingCubit(gh<_i93.CompleteOnboarding>()),
    );
    return this;
  }
}

class _$DatabaseModule extends _i528.DatabaseModule {}
