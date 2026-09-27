import 'dart:async';

import 'package:flutter_gluko_apps/features/reminder/domain/entities/scheduled_notification.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/services/notification_scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Implementasi [NotificationScheduler] di atas `flutter_local_notifications`.
///
/// Notifikasi dijadwalkan sebagai pengulangan mingguan
/// (`DateTimeComponents.dayOfWeekAndTime`) sehingga tetap berbunyi walau
/// aplikasi tidak dibuka berhari-hari; `ScheduledNotificationBootReceiver`
/// di manifest memulihkannya setelah reboot (PRD F-07 AC2).
@LazySingleton(as: NotificationScheduler)
class LocalNotificationScheduler implements NotificationScheduler {
  new() : _plugin = FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  final StreamController<String> _taps = StreamController.broadcast();

  static const AndroidNotificationDetails _androidDetails =
      AndroidNotificationDetails(
        'glucose_reminders',
        'Pengingat cek gula darah',
        channelDescription: 'Pengingat jadwal cek gula darah harian.',
        importance: Importance.high,
        priority: Priority.high,
        category: AndroidNotificationCategory.reminder,
      );

  bool _initialized = false;
  bool _launchPayloadTaken = false;

  AndroidFlutterLocalNotificationsPlugin? get _android =>
      _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  @override
  Stream<String> get taps => _taps.stream;

  @override
  Future<void> initialize() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();
    try {
      final zone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(zone.identifier));
    } on Object {
      // Zona tidak dikenali database tz. Target pengguna ada di Indonesia,
      // jadi WIB lebih masuk akal daripada UTC bawaan paket timezone.
      tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
    }

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) _taps.add(payload);
      },
    );
    _initialized = true;
  }

  @override
  Future<void> replaceAll(List<ScheduledNotification> notifications) async {
    await initialize();
    await _plugin.cancelAllPendingNotifications();

    final exact = (await _android?.canScheduleExactNotifications()) ?? false;
    final mode = exact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    for (final n in notifications) {
      await _plugin.zonedSchedule(
        id: n.id,
        title: n.title,
        body: n.body,
        payload: n.payload,
        scheduledDate: tz.TZDateTime.from(n.firstFireAt, tz.local),
        notificationDetails: const NotificationDetails(
          android: _androidDetails,
        ),
        androidScheduleMode: mode,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  @override
  Future<NotificationPermissionStatus> permissionStatus() async {
    final android = _android;
    if (android == null) {
      return const NotificationPermissionStatus(
        notificationsEnabled: true,
        exactAlarms: true,
      );
    }
    return NotificationPermissionStatus(
      notificationsEnabled: await android.areNotificationsEnabled() ?? false,
      exactAlarms: await android.canScheduleExactNotifications() ?? false,
    );
  }

  @override
  Future<NotificationPermissionStatus> requestPermissions() async {
    final android = _android;
    if (android != null) {
      await android.requestNotificationsPermission();
      if (!(await android.canScheduleExactNotifications() ?? false)) {
        await android.requestExactAlarmsPermission();
      }
    }
    return await permissionStatus();
  }

  @override
  Future<String?> takeLaunchPayload() async {
    // Plugin terus melaporkan detail peluncuran yang sama selama proses
    // hidup; tanpa penanda ini form catat terbuka lagi setiap splash tampil.
    if (_launchPayloadTaken) return null;
    _launchPayloadTaken = true;

    await initialize();
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details == null || !details.didNotificationLaunchApp) return null;
    final payload = details.notificationResponse?.payload;
    return payload == null || payload.isEmpty ? null : payload;
  }
}
