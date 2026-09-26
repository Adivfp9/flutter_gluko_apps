import 'package:flutter/material.dart';
import 'package:flutter_gluko_apps/core/router/app_shell.dart';
import 'package:flutter_gluko_apps/features/glucose/presentation/pages/dashboard_page.dart';
import 'package:flutter_gluko_apps/features/glucose/presentation/pages/history_page.dart';
import 'package:flutter_gluko_apps/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:flutter_gluko_apps/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter_gluko_apps/features/startup/presentation/pages/splash_page.dart';
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
  static const String record = 'record';
  static const String splash = 'splash';
  static const String onboarding = 'onboarding';
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
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
