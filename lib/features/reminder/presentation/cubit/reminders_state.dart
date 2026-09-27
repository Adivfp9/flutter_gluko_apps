import 'package:flutter_gluko_apps/features/reminder/domain/entities/reminder.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/services/notification_scheduler.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminders_state.freezed.dart';

/// State layar S-11 Pengingat.
@freezed
abstract class RemindersState with _$RemindersState {
  const factory({
    @Default(true) bool isLoading,
    @Default(<Reminder>[]) List<Reminder> reminders,
    NotificationPermissionStatus? permission,
    String? errorMessage,
    String? infoMessage,
  }) = _RemindersState;

  const new _();

  /// Banner izin hanya tampil bila ada pengingat aktif yang terdampak.
  bool get needsPermission =>
      permission != null &&
      !permission!.isFullyGranted &&
      reminders.any((r) => r.isActive);
}
