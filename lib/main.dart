import 'package:flutter/material.dart';
import 'package:flutter_gluko_apps/app.dart';
import 'package:flutter_gluko_apps/core/di/injection.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/services/notification_scheduler.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/usecases/reminder_sync.dart';
import 'package:flutter_gluko_apps/features/security/presentation/cubit/app_lock_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  final notifications = getIt<NotificationScheduler>();
  try {
    await notifications.initialize();
  } on Object {
    // Aplikasi tetap harus bisa dipakai mencatat walau plugin notifikasi
    // gagal; ReminderSync akan mencoba inisialisasi lagi saat menjadwalkan.
  }

  // PRD F-08 AC2: status kunci dibaca sebelum frame pertama, supaya isi
  // aplikasi tidak sempat tampil sekejap sebelum layar kunci.
  final appLock = getIt<AppLockCubit>();
  await appLock.initialize();

  runApp(
    GlukoTrackApp(
      notificationTaps: notifications.taps,
      onResumed: getIt<ReminderSync>().refresh,
      appLock: appLock,
    ),
  );
}
