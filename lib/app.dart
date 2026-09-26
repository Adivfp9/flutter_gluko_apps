import 'package:flutter/material.dart';
import 'package:flutter_gluko_apps/core/router/app_router.dart';
import 'package:flutter_gluko_apps/core/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

class GlukoTrackApp extends StatefulWidget {
  const new({super.key, this.router});

  /// Router siap pakai untuk test widget; produksi memakai [createRouter].
  final GoRouter? router;

  @override
  State<GlukoTrackApp> createState() => _GlukoTrackAppState();
}

class _GlukoTrackAppState extends State<GlukoTrackApp> {
  // Router dibuat sekali dan disimpan di state; membuatnya ulang setiap build
  // akan mereset seluruh tumpukan navigasi saat tema atau locale berubah.
  late final GoRouter _router = widget.router ?? createRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GlukoTrack',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // NFR-09: Bahasa Indonesia default, English disiapkan di Sprint 5.6.
      locale: const Locale('id'),
      supportedLocales: const [Locale('id'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
