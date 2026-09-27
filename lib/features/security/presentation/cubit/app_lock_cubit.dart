import 'package:clock/clock.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gluko_apps/features/security/domain/repositories/security_repository.dart';
import 'package:flutter_gluko_apps/features/security/domain/services/security_services.dart';
import 'package:flutter_gluko_apps/features/security/domain/usecases/reset_app_data.dart';
import 'package:flutter_gluko_apps/features/security/presentation/cubit/app_lock_state.dart';
import 'package:injectable/injectable.dart';

/// Status kunci seluruh aplikasi (PRD F-08).
///
/// Satu instance untuk seluruh umur aplikasi: disediakan di atas router
/// supaya layar kunci bisa menutupi rute mana pun.
@lazySingleton
class AppLockCubit extends Cubit<AppLockState> {
  new(this._repository, this._biometric, this._secureScreen, this._reset)
    : super(const AppLockState());

  /// PRD F-08 AC2: terkunci lagi setelah di background lebih dari 1 menit.
  static const Duration autoLockAfter = Duration(minutes: 1);

  final SecurityRepository _repository;
  final BiometricAuthenticator _biometric;
  final SecureScreen _secureScreen;
  final ResetAppData _reset;

  DateTime? _backgroundedAt;

  Future<void> initialize() async {
    try {
      final settings = await _repository.load();
      await _apply(settings);
      emit(
        state.copyWith(
          status: settings.lockEnabled
              ? LockStatus.locked
              : LockStatus.unlocked,
          lockedUntil: await _repository.lockedUntil(),
        ),
      );
    } on Object {
      // Setelan tak terbaca berarti database bermasalah; isi aplikasi pun
      // tidak akan tampil, jadi mengunci tanpa PIN yang bisa diverifikasi
      // hanya menambah jalan buntu.
      emit(state.copyWith(status: LockStatus.unlocked));
    }
  }

  /// Dipanggil setelah setelan keamanan diubah di layar Keamanan.
  Future<void> reloadSettings() async {
    final settings = await _repository.load();
    await _apply(settings);
    if (!settings.lockEnabled) {
      emit(state.copyWith(status: LockStatus.unlocked));
    }
  }

  Future<void> _apply(LockSettings settings) async {
    final canUseBiometric =
        settings.biometricEnabled && await _biometric.isAvailable();
    await _secureScreen.setSecure(enabled: settings.lockEnabled);
    emit(
      state.copyWith(
        lockEnabled: settings.lockEnabled,
        biometricEnabled: settings.biometricEnabled,
        canUseBiometric: canUseBiometric,
      ),
    );
  }

  void onBackgrounded(DateTime now) {
    if (state.status == LockStatus.unlocked) _backgroundedAt = now;
  }

  void onForegrounded(DateTime now) {
    final since = _backgroundedAt;
    _backgroundedAt = null;
    if (!state.lockEnabled || since == null) return;
    if (now.difference(since) > autoLockAfter) {
      emit(state.copyWith(status: LockStatus.locked, errorMessage: null));
    }
  }

  Future<void> submitPin(String pin, {DateTime? now}) async {
    if (state.isVerifying) return;
    emit(state.copyWith(isVerifying: true, errorMessage: null));

    final at = now ?? clock.now();
    final check = await _repository.verifyPin(pin, now: at);
    if (isClosed) return;

    switch (check.outcome) {
      case PinCheckOutcome.success:
        emit(
          state.copyWith(
            status: LockStatus.unlocked,
            isVerifying: false,
            failedAttempts: 0,
            lockedUntil: null,
          ),
        );
      case PinCheckOutcome.wrong:
        final until = check.lockedUntil;
        final left = PinAttemptPolicy.freeAttempts - check.failedAttempts;
        emit(
          state.copyWith(
            isVerifying: false,
            failedAttempts: check.failedAttempts,
            lockedUntil: until,
            errorMessage: until != null
                ? cooldownMessage(until, at)
                : 'PIN salah. Sisa $left percobaan sebelum dijeda.',
          ),
        );
      case PinCheckOutcome.coolingDown:
        emit(
          state.copyWith(
            isVerifying: false,
            lockedUntil: check.lockedUntil,
            errorMessage: cooldownMessage(check.lockedUntil!, at),
          ),
        );
    }
  }

  Future<void> unlockWithBiometric() async {
    if (!state.canUseBiometric || !state.isLocked) return;
    final ok = await _biometric.authenticate('Buka GlukoTrack');
    if (ok && !isClosed) {
      emit(state.copyWith(status: LockStatus.unlocked, errorMessage: null));
    }
  }

  /// "Lupa PIN" setelah konfirmasi pengguna.
  Future<void> resetAppData() async {
    await _reset();
    await _secureScreen.setSecure(enabled: false);
    emit(const AppLockState(status: LockStatus.unlocked, resetDone: true));
  }

  void acknowledgeReset() => emit(state.copyWith(resetDone: false));

  static String cooldownMessage(DateTime until, DateTime now) {
    final seconds = until.difference(now).inSeconds.clamp(1, 24 * 3600);
    final label = seconds >= 60
        ? '${(seconds / 60).ceil()} menit'
        : '$seconds detik';
    return 'Terlalu banyak percobaan. Coba lagi dalam $label.';
  }
}
