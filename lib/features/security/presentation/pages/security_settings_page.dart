import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gluko_apps/core/di/injection.dart';
import 'package:flutter_gluko_apps/core/theme/app_palette.dart';
import 'package:flutter_gluko_apps/core/theme/app_spacing.dart';
import 'package:flutter_gluko_apps/features/security/domain/repositories/security_repository.dart';
import 'package:flutter_gluko_apps/features/security/domain/services/security_services.dart';
import 'package:flutter_gluko_apps/features/security/presentation/cubit/app_lock_cubit.dart';
import 'package:flutter_gluko_apps/features/security/presentation/cubit/app_lock_state.dart';
import 'package:flutter_gluko_apps/features/security/presentation/pages/lock_screen.dart';

/// Pengaturan › Keamanan (PRD F-08).
class SecuritySettingsPage extends StatefulWidget {
  const new({super.key});

  @override
  State<SecuritySettingsPage> createState() => _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends State<SecuritySettingsPage> {
  final SecurityRepository _repository = getIt<SecurityRepository>();
  final BiometricAuthenticator _biometric = getIt<BiometricAuthenticator>();

  bool _biometricAvailable = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    unawaited(_checkBiometric());
  }

  Future<void> _checkBiometric() async {
    final available = await _biometric.isAvailable();
    if (mounted) setState(() => _biometricAvailable = available);
  }

  void _toast(String message) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));

  Future<void> _run(Future<void> Function() action, String success) async {
    setState(() => _busy = true);
    try {
      await action();
      if (!mounted) return;
      await context.read<AppLockCubit>().reloadSettings();
      _toast(success);
    } on Object catch (e) {
      _toast('Gagal menyimpan: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<String?> _askNewPin() => Navigator.of(context).push<String>(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => const _NewPinPage(),
    ),
  );

  /// Mematikan kunci atau mengganti PIN butuh PIN lama: ponsel yang
  /// dipinjam dalam keadaan terbuka tidak boleh bisa melepas kuncinya.
  Future<bool> _confirmCurrentPin() async {
    final ok = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => _VerifyPinPage(repository: _repository),
      ),
    );
    return ok ?? false;
  }

  Future<void> _toggleLock({required bool enable}) async {
    if (enable) {
      final pin = await _askNewPin();
      if (pin == null) return;
      await _run(() => _repository.enableLock(pin), 'Kunci aplikasi aktif.');
    } else {
      if (!await _confirmCurrentPin()) return;
      await _run(_repository.disableLock, 'Kunci aplikasi dimatikan.');
    }
  }

  Future<void> _changePin() async {
    if (!await _confirmCurrentPin()) return;
    final pin = await _askNewPin();
    if (pin == null) return;
    await _run(() => _repository.changePin(pin), 'PIN diperbarui.');
  }

  Future<void> _toggleBiometric({required bool enable}) async {
    if (enable) {
      final ok = await _biometric.authenticate(
        'Konfirmasi biometrik untuk membuka GlukoTrack',
      );
      if (!ok) return;
    }
    await _run(
      () => _repository.setBiometricEnabled(enabled: enable),
      enable ? 'Biometrik diaktifkan.' : 'Biometrik dimatikan.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final palette = context.palette;

    return BlocBuilder<AppLockCubit, AppLockState>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Keamanan')),
        body: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenGutter,
            vertical: AppSpacing.sm,
          ),
          children: [
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.lock_outline),
                    title: const Text('Kunci dengan PIN'),
                    subtitle: const Text(
                      'Minta PIN 6 digit saat aplikasi dibuka atau kembali '
                      'setelah lebih dari 1 menit.',
                    ),
                    value: state.lockEnabled,
                    onChanged: _busy ? null : (v) => _toggleLock(enable: v),
                  ),
                  if (state.lockEnabled) ...[
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.password),
                      title: const Text('Ganti PIN'),
                      trailing: const Icon(Icons.chevron_right),
                      enabled: !_busy,
                      onTap: _changePin,
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      secondary: const Icon(Icons.fingerprint),
                      title: const Text('Buka dengan biometrik'),
                      subtitle: Text(
                        _biometricAvailable
                            ? 'Sidik jari atau wajah sebagai alternatif PIN.'
                            : 'Belum ada biometrik terdaftar di HP ini.',
                      ),
                      value: state.biometricEnabled && _biometricAvailable,
                      onChanged: _busy || !_biometricAvailable
                          ? null
                          : (v) => _toggleBiometric(enable: v),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Saat kunci aktif, isi layar disembunyikan di daftar aplikasi '
              'terbaru dan screenshot diblokir.',
              style: text.bodyMedium?.copyWith(color: palette.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

/// Membuat PIN baru: masukkan lalu ulangi.
class _NewPinPage extends StatefulWidget {
  const new();

  @override
  State<_NewPinPage> createState() => _NewPinPageState();
}

class _NewPinPageState extends State<_NewPinPage> {
  final GlobalKey<PinPadState> _pad = GlobalKey();
  String? _first;
  String? _error;

  void _onCompleted(String pin) {
    final first = _first;
    if (first == null) {
      setState(() {
        _first = pin;
        _error = null;
      });
      _pad.currentState?.clear();
      return;
    }
    if (pin == first) {
      Navigator.pop(context, pin);
      return;
    }
    setState(() {
      _first = null;
      _error = 'PIN tidak sama. Ulangi dari awal.';
    });
    _pad.currentState?.clear();
  }

  @override
  Widget build(BuildContext context) {
    final confirming = _first != null;
    return _PinScaffold(
      title: confirming ? 'Ulangi PIN' : 'Buat PIN baru',
      message:
          _error ??
          (confirming
              ? 'Masukkan PIN yang sama sekali lagi.'
              : 'Pilih 6 digit yang mudah Anda ingat.'),
      isError: _error != null,
      pad: PinPad(key: _pad, onCompleted: _onCompleted),
    );
  }
}

/// Konfirmasi PIN saat ini; ikut dibatasi percobaannya.
class _VerifyPinPage extends StatefulWidget {
  const new({required this.repository});

  final SecurityRepository repository;

  @override
  State<_VerifyPinPage> createState() => _VerifyPinPageState();
}

class _VerifyPinPageState extends State<_VerifyPinPage> {
  final GlobalKey<PinPadState> _pad = GlobalKey();
  String? _error;
  bool _checking = false;

  Future<void> _onCompleted(String pin) async {
    setState(() => _checking = true);
    final now = clock.now();
    final check = await widget.repository.verifyPin(pin, now: now);
    if (!mounted) return;
    if (check.isSuccess) {
      Navigator.pop(context, true);
      return;
    }
    final until = check.lockedUntil;
    setState(() {
      _checking = false;
      _error = until != null
          ? AppLockCubit.cooldownMessage(until, now)
          : 'PIN salah.';
    });
    _pad.currentState?.clear();
  }

  @override
  Widget build(BuildContext context) => _PinScaffold(
    title: 'Masukkan PIN saat ini',
    message: _error ?? 'Diperlukan untuk mengubah pengaturan kunci.',
    isError: _error != null,
    pad: PinPad(key: _pad, enabled: !_checking, onCompleted: _onCompleted),
  );
}

class _PinScaffold extends StatelessWidget {
  const new({
    required this.title,
    required this.message,
    required this.isError,
    required this.pad,
  });

  final String title;
  final String message;
  final bool isError;
  final Widget pad;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenGutter),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.lg),
              Text(
                message,
                textAlign: TextAlign.center,
                style: text.bodyMedium?.copyWith(
                  color: isError
                      ? Theme.of(context).colorScheme.error
                      : context.palette.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              pad,
            ],
          ),
        ),
      ),
    );
  }
}
