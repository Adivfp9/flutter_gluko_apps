import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gluko_apps/core/theme/app_palette.dart';
import 'package:flutter_gluko_apps/core/theme/app_spacing.dart';
import 'package:flutter_gluko_apps/features/security/presentation/cubit/app_lock_cubit.dart';
import 'package:flutter_gluko_apps/features/security/presentation/cubit/app_lock_state.dart';

/// S-01 bagian kunci (temuan D-3: belum didesain; disusun dari keypad form
/// catat dan warna brand splash).
class LockScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final GlobalKey<PinPadState> _pad = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Biometrik langsung ditawarkan saat layar kunci muncul, seperti
    // kebiasaan aplikasi perbankan; PIN tetap tersedia bila dibatalkan.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(context.read<AppLockCubit>().unlockWithBiometric());
      }
    });
  }

  Future<void> _forgotPin(BuildContext context) async {
    final cubit = context.read<AppLockCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const _ForgotPinDialog(),
    );
    if (confirmed ?? false) await cubit.resetAppData();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final text = Theme.of(context).textTheme;

    return BlocConsumer<AppLockCubit, AppLockState>(
      listenWhen: (a, b) => a.errorMessage != b.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null) {
          unawaited(HapticFeedback.mediumImpact());
          _pad.currentState?.clear();
        }
      },
      builder: (context, state) {
        final cubit = context.read<AppLockCubit>();
        return Scaffold(
          backgroundColor: palette.surface,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenGutter,
                      vertical: AppSpacing.xl,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock_outline,
                          size: 48,
                          color: palette.brandStrong,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text('Masukkan PIN', style: text.titleLarge),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          state.errorMessage ?? 'Data kesehatan Anda terkunci.',
                          textAlign: TextAlign.center,
                          style: text.bodyMedium?.copyWith(
                            color: state.errorMessage == null
                                ? palette.textSecondary
                                : Theme.of(context).colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        PinPad(
                          key: _pad,
                          enabled: !state.isVerifying,
                          onCompleted: cubit.submitPin,
                          extraKey: state.canUseBiometric
                              ? IconButton(
                                  tooltip: 'Buka dengan biometrik',
                                  iconSize: 32,
                                  onPressed: cubit.unlockWithBiometric,
                                  icon: const Icon(Icons.fingerprint),
                                )
                              : null,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        TextButton(
                          onPressed: () => _forgotPin(context),
                          child: const Text('Lupa PIN?'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ForgotPinDialog extends StatefulWidget {
  const new();

  @override
  State<_ForgotPinDialog> createState() => _ForgotPinDialogState();
}

class _ForgotPinDialogState extends State<_ForgotPinDialog> {
  static const String _phrase = 'HAPUS';
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final confirmed = _controller.text.trim().toUpperCase() == _phrase;
    final scheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: const Text('Lupa PIN?'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PIN tidak bisa dipulihkan karena hanya tersimpan di HP ini '
              'dalam bentuk terenkripsi.\n\n'
              'Satu-satunya cara membuka aplikasi adalah menghapus semua '
              'catatan, target, dan pengingat, lalu memulai dari awal. Jika '
              'punya file backup (.gtbak), Anda bisa memulihkannya setelah '
              'itu.',
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _controller,
              autofocus: true,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'Ketik HAPUS untuk melanjutkan',
              ),
              onChanged: (_) => setState(() {}),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Batal'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: scheme.error,
            foregroundColor: scheme.onError,
          ),
          onPressed: confirmed ? () => Navigator.pop(context, true) : null,
          child: const Text('Hapus semua data'),
        ),
      ],
    );
  }
}

/// Indikator 6 titik + keypad angka untuk PIN.
class PinPad extends StatefulWidget {
  const new({
    required this.onCompleted,
    super.key,
    this.enabled = true,
    this.extraKey,
  });

  static const int length = 6;

  final ValueChanged<String> onCompleted;
  final bool enabled;

  /// Tombol di kiri bawah keypad, misalnya biometrik.
  final Widget? extraKey;

  @override
  State<PinPad> createState() => PinPadState();
}

class PinPadState extends State<PinPad> {
  String _value = '';

  void clear() => setState(() => _value = '');

  void _tap(String digit) {
    if (!widget.enabled || _value.length >= PinPad.length) return;
    setState(() => _value += digit);
    if (_value.length == PinPad.length) widget.onCompleted(_value);
  }

  void _backspace() {
    if (_value.isEmpty) return;
    setState(() => _value = _value.substring(0, _value.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    Widget key(String digit) => _PadKey(
      label: digit,
      onTap: widget.enabled ? () => _tap(digit) : null,
    );

    return Column(
      children: [
        Semantics(
          label: '${_value.length} dari ${PinPad.length} digit terisi',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < PinPad.length; i++)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i < _value.length
                        ? palette.brandStrong
                        : Colors.transparent,
                    border: Border.all(color: palette.brandStrong, width: 2),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        for (final row in const [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
        ])
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [for (final d in row) key(d)],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 88,
              height: 72,
              child: Center(child: widget.extraKey),
            ),
            key('0'),
            SizedBox(
              width: 88,
              height: 72,
              child: IconButton(
                tooltip: 'Hapus digit',
                onPressed: _value.isEmpty ? null : _backspace,
                icon: const Icon(Icons.backspace_outlined),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PadKey extends StatelessWidget {
  const new({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88,
      height: 72,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Material(
          color: context.palette.fieldFill,
          borderRadius: BorderRadius.circular(AppRadius.key),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.key),
            onTap: onTap,
            child: Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
