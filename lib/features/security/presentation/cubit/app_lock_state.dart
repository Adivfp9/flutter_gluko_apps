import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_lock_state.freezed.dart';

enum LockStatus {
  /// Setelan kunci belum terbaca; layar ditutup polos agar isi tidak
  /// sempat terlihat sekejap sebelum layar kunci muncul.
  checking,
  unlocked,
  locked,
}

@freezed
abstract class AppLockState with _$AppLockState {
  const factory({
    @Default(LockStatus.checking) LockStatus status,
    @Default(false) bool lockEnabled,
    @Default(false) bool biometricEnabled,

    /// Biometrik aktif di setelan **dan** tersedia di perangkat saat ini.
    @Default(false) bool canUseBiometric,
    @Default(false) bool isVerifying,
    @Default(0) int failedAttempts,
    DateTime? lockedUntil,
    String? errorMessage,

    /// Sekali pakai: data baru saja dihapus lewat "Lupa PIN".
    @Default(false) bool resetDone,
  }) = _AppLockState;

  const new _();

  bool get isLocked => status == LockStatus.locked;
}
