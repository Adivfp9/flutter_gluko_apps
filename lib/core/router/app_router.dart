import 'package:flutter/material.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/router/app_shell.dart';
import 'package:flutter_gluko_apps/features/glucose/presentation/pages/dashboard_page.dart';
import 'package:flutter_gluko_apps/features/glucose/presentation/pages/history_page.dart';
import 'package:flutter_gluko_apps/features/glucose/presentation/pages/reading_detail_page.dart';
import 'package:flutter_gluko_apps/features/glucose/presentation/pages/reading_form_page.dart';
import 'package:flutter_gluko_apps/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:flutter_gluko_apps/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter_gluko_apps/features/startup/presentation/pages/splash_page.dart';
import 'package:flutter_gluko_apps/features/target/presentation/pages/target_settings_page.dart';
import 'package:flutter_gluko_apps/features/trend/presentation/pages/trend_page.dart';
import 'package:go_router/go_router.dart';

/// Nama rute, dipakai lewat `context.goNamed` agar path tidak tersebar
/// sebagai string di seluruh kode.
///
/// F-07 AC3: notifikasi membuka form catat dengan tipe sudah terisi, jadi
/// [record] harus bisa dituju sebagai deep link dari luar aplikasi.
abstract final class AppRoute {
  static const String dashboard = 'dashboard';
  static const String history = 'history';
  static const String trend = 'trend';
  static const String settings = 'settings';
  static const String readingDetail = 'readingDetail';
  static const String record = 'record';
  static const String splash = 'splash';
  static const String onboarding = 'onboarding';
  static const String target = 'target';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// [initialLocation] hanya dipakai test widget untuk melompati splash, yang
/// butuh dependency injection lengkap.
GoRouter createRouter({String initialLocation = '/'}) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/onboarding',
        name: AppRoute.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/catat',
        name: AppRoute.record,
        builder: (context, state) {
          final rawType = state.uri.queryParameters['type'];
          ReadingType? initialType;
          for (final type in ReadingType.values) {
            if (type.dbValue == rawType) initialType = type;
          }
          // `?edit=<id>` membuka form dalam mode sunting (PRD F-05 AC3).
          final editId = int.tryParse(state.uri.queryParameters['edit'] ?? '');
          return ReadingFormPage(initialType: initialType, editId: editId);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/catatan/:id',
        name: AppRoute.readingDetail,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          if (id == null) {
            return const Scaffold(
              body: Center(child: Text('Catatan tidak ditemukan.')),
            );
          }
          return ReadingDetailPage(readingId: id);
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/beranda',
                name: AppRoute.dashboard,
                builder: (context, state) => const DashboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/riwayat',
                name: AppRoute.history,
                builder: (context, state) => const HistoryPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tren',
                name: AppRoute.trend,
                builder: (context, state) => const TrendPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/pengaturan',
                name: AppRoute.settings,
                builder: (context, state) => const SettingsPage(),
                routes: [
                  GoRoute(
                    path: 'target',
                    name: AppRoute.target,
                    builder: (context, state) => const TargetSettingsPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
