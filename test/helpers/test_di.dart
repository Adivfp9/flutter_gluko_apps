import 'package:flutter_gluko_apps/core/di/injection.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/features/glucose/data/repositories/glucose_repository_impl.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/repositories/glucose_repository.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/build_dashboard_summary.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/watch_dashboard.dart';
import 'package:flutter_gluko_apps/features/glucose/presentation/cubit/dashboard_cubit.dart';
import 'package:flutter_gluko_apps/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_gluko_apps/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_gluko_apps/features/target/data/repositories/target_repository_impl.dart';
import 'package:flutter_gluko_apps/features/target/domain/repositories/target_repository.dart';
import 'package:flutter_gluko_apps/features/trend/domain/usecases/build_trend_summary.dart';
import 'package:flutter_gluko_apps/features/trend/presentation/cubit/trend_cubit.dart';

import 'test_database.dart';

/// Menyusun dependency injection untuk test widget di atas database in-memory.
///
/// Registrasi dilakukan manual, bukan lewat `getIt.init()` hasil injectable,
/// karena modul produksi membuka database terenkripsi lewat path_provider dan
/// Android Keystore — keduanya tidak tersedia di test host.
AppDatabase configureTestDependencies() {
  final db = createTestDatabase();

  getIt
    ..registerSingleton<AppDatabase>(db)
    ..registerSingleton<GlucoseRepository>(GlucoseRepositoryImpl(db.glucoseDao))
    ..registerSingleton<ProfileRepository>(ProfileRepositoryImpl(db.profileDao))
    ..registerSingleton<TargetRepository>(TargetRepositoryImpl(db.targetDao))
    ..registerFactory<DashboardCubit>(
      () => DashboardCubit(
        WatchDashboard(
          getIt<GlucoseRepository>(),
          const BuildDashboardSummary(),
        ),
        getIt<ProfileRepository>(),
      ),
    )
    ..registerFactory<TrendCubit>(
      () => TrendCubit(
        getIt<GlucoseRepository>(),
        getIt<TargetRepository>(),
        getIt<ProfileRepository>(),
        const BuildTrendSummary(),
      ),
    );

  return db;
}

/// Melepas seluruh registrasi; dipanggil pada `tearDown`.
Future<void> resetTestDependencies() => getIt.reset();
