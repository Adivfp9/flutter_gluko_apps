import 'package:flutter/material.dart';
import 'package:flutter_gluko_apps/app.dart';
import 'package:flutter_gluko_apps/core/di/injection.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/services/notification_scheduler.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/usecases/reminder_sync.dart';

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

  runApp(
    GlukoTrackApp(
      notificationTaps: notifications.taps,
      onResumed: getIt<ReminderSync>().refresh,
    ),
  );
}
