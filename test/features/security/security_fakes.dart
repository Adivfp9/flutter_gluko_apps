import 'package:flutter_gluko_apps/features/reminder/domain/entities/scheduled_notification.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/services/notification_scheduler.dart';
import 'package:flutter_gluko_apps/features/security/domain/services/security_services.dart';

class FakeSecretStore implements SecretStore {
  final Map<String, String> values = {};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;

  @override
  Future<void> delete(String key) async => values.remove(key);
}

class FakeBiometric implements BiometricAuthenticator {
  bool available = true;
  bool succeed = true;
  int prompts = 0;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<bool> authenticate(String reason) async {
    prompts++;
    return succeed;
  }
}

class FakeSecureScreen implements SecureScreen {
  bool? secure;

  @override
  Future<void> setSecure({required bool enabled}) async => secure = enabled;
}

class RecordingScheduler implements NotificationScheduler {
  List<ScheduledNotification>? last;

  @override
  Future<void> replaceAll(List<ScheduledNotification> notifications) async =>
      last = notifications;

  @override
  Future<void> initialize() async {}

  @override
  Future<NotificationPermissionStatus> permissionStatus() async =>
      const NotificationPermissionStatus(
        notificationsEnabled: true,
        exactAlarms: true,
      );

  @override
  Future<NotificationPermissionStatus> requestPermissions() =>
      permissionStatus();

  @override
  Future<String?> takeLaunchPayload() async => null;

  @override
  Stream<String> get taps => const Stream.empty();
}
