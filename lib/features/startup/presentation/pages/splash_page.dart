import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gluko_apps/core/di/injection.dart';
import 'package:flutter_gluko_apps/core/router/app_router.dart';
import 'package:flutter_gluko_apps/core/theme/app_palette.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/services/notification_scheduler.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/usecases/reminder_sync.dart';
import 'package:flutter_gluko_apps/features/startup/domain/usecases/app_startup.dart';
import 'package:go_router/go_router.dart';

/// S-01 Splash.
///
/// Menjalankan pekerjaan awal (pembersihan soft delete) lalu mengarahkan ke
/// onboarding atau beranda. Dibuat sebagai rute tersendiri, bukan logika di
/// `redirect` go_router, supaya pemeriksaan database yang asinkron tidak
/// menahan seluruh navigasi.
class SplashPage extends StatefulWidget {
  const new({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    String target;
    String? launchPayload;
    try {
      final result = await getIt<AppStartup>().run();
      target = result.onboardingDone ? AppRoute.dashboard : AppRoute.onboarding;
      if (result.onboardingDone) {
        // Jadwal direkonsiliasi setiap aplikasi dibuka (rencana §3.3).
        getIt<ReminderSync>().start();
        launchPayload = await _takeLaunchPayload();
      }
    } on Object {
      // Kalau pemeriksaan gagal, arahkan ke onboarding: lebih aman meminta
      // pengguna menyetujui disclaimer lagi daripada membuka layar kosong.
      target = AppRoute.onboarding;
    }

    if (!mounted) return;
    final router = GoRouter.of(context)..goNamed(target);
    // Aplikasi dibuka dari notifikasi: beranda tetap di bawah form catat,
    // sehingga tombol kembali tidak menutup aplikasi (PRD F-07 AC3).
    if (launchPayload != null) unawaited(router.push(launchPayload));
  }

  Future<String?> _takeLaunchPayload() async {
    try {
      return await getIt<NotificationScheduler>().takeLaunchPayload();
    } on Object {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: palette.brandSoft,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Icon(
                Icons.water_drop_outlined,
                size: 48,
                color: palette.brandStrong,
              ),
            ),
            const SizedBox(height: 24),
            Text('GlukoTrack', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
