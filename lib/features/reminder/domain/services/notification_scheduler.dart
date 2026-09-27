import 'package:flutter_gluko_apps/features/reminder/domain/entities/scheduled_notification.dart';

/// Status izin yang memengaruhi keandalan pengingat.
class NotificationPermissionStatus {
  const new({required this.notificationsEnabled, required this.exactAlarms});

  /// Android 13+: POST_NOTIFICATIONS diberikan.
  final bool notificationsEnabled;

  /// Android 12+: SCHEDULE_EXACT_ALARM diberikan. Tanpanya pengingat tetap
  /// berbunyi, tetapi bisa terlambat beberapa menit karena Doze.
  final bool exactAlarms;

  bool get isFullyGranted => notificationsEnabled && exactAlarms;
}

/// Pembungkus notifikasi lokal.
///
/// Sengaja berupa interface di domain supaya logika jadwal tidak bergantung
/// pada plugin Android (rencana implementasi B-3).
abstract interface class NotificationScheduler {
  Future<void> initialize();

  /// Mengganti seluruh jadwal milik aplikasi dengan [notifications].
  Future<void> replaceAll(List<ScheduledNotification> notifications);

  Future<NotificationPermissionStatus> permissionStatus();

  /// Meminta izin notifikasi lalu izin alarm tepat waktu.
  Future<NotificationPermissionStatus> requestPermissions();

  /// Payload notifikasi yang membuka aplikasi dari keadaan mati, sekali pakai.
  Future<String?> takeLaunchPayload();

  /// Payload setiap kali notifikasi di-tap saat aplikasi berjalan.
  Stream<String> get taps;
}
