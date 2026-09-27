import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gluko_apps/core/router/app_router.dart';
import 'package:flutter_gluko_apps/core/theme/app_palette.dart';
import 'package:flutter_gluko_apps/core/theme/app_theme.dart';
import 'package:flutter_gluko_apps/features/security/presentation/cubit/app_lock_cubit.dart';
import 'package:flutter_gluko_apps/features/security/presentation/cubit/app_lock_state.dart';
import 'package:flutter_gluko_apps/features/security/presentation/pages/lock_screen.dart';
import 'package:flutter_gluko_apps/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class GlukoTrackApp extends StatefulWidget {
  const new({
    super.key,
    this.router,
    this.notificationTaps,
    this.onResumed,
    this.appLock,
  });

  /// Router siap pakai untuk test widget; produksi memakai [createRouter].
  final GoRouter? router;

  /// Payload notifikasi yang di-tap saat aplikasi berjalan; berisi lokasi
  /// go_router, misalnya `/catat?type=fasting` (PRD F-07 AC3).
  final Stream<String>? notificationTaps;

  /// Dipanggil setiap aplikasi kembali ke depan.
  final VoidCallback? onResumed;

  /// Kunci aplikasi (PRD F-08). `null` di test widget yang tidak menguji
  /// kunci, sehingga tidak perlu menyiapkan Keystore dan biometrik.
  final AppLockCubit? appLock;

  @override
  State<GlukoTrackApp> createState() => _GlukoTrackAppState();
}

class _GlukoTrackAppState extends State<GlukoTrackApp> {
  // Router dibuat sekali dan disimpan di state; membuatnya ulang setiap build
  // akan mereset seluruh tumpukan navigasi saat tema atau locale berubah.
  late final GoRouter _router = widget.router ?? createRouter();

  StreamSubscription<String>? _tapSub;
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _tapSub = widget.notificationTaps?.listen(
      (location) => unawaited(_router.push(location)),
    );
    _lifecycle = AppLifecycleListener(
      onPause: () => widget.appLock?.onBackgrounded(clock.now()),
      onResume: () {
        widget.appLock?.onForegrounded(clock.now());
        widget.onResumed?.call();
      },
    );
  }

  @override
  void dispose() {
    unawaited(_tapSub?.cancel());
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = MaterialApp.router(
      title: 'GlukoTrack',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // NFR-09: Bahasa Indonesia default. String aplikasi dari gen-l10n
      // (lib/l10n/*.arb, Sprint 5.6); English sudah tersedia sebagai ARB
      // kedua dan tinggal diaktifkan dengan melepas `locale` tetap ini.
      locale: const Locale('id'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: widget.appLock == null
          ? null
          : (context, child) => _LockGate(
              onReset: () => _router.goNamed(AppRoute.onboarding),
              child: child ?? const SizedBox.shrink(),
            ),
    );

    final lock = widget.appLock;
    return lock == null ? app : BlocProvider.value(value: lock, child: app);
  }
}

/// Menutupi seluruh rute dengan layar kunci selama terkunci.
///
/// Layar kunci diletakkan di atas Navigator router (bukan sebagai rute)
/// supaya tidak bisa dilewati dengan tombol kembali atau deep link.
class _LockGate extends StatelessWidget {
  const new({required this.child, required this.onReset});

  final Widget child;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppLockCubit, AppLockState>(
      listenWhen: (a, b) => !a.resetDone && b.resetDone,
      listener: (context, state) {
        onReset();
        context.read<AppLockCubit>().acknowledgeReset();
      },
      buildWhen: (a, b) => a.status != b.status,
      builder: (context, state) => Stack(
        children: [
          // Isi aplikasi tetap terpasang agar posisi navigasi tidak hilang,
          // tetapi disembunyikan dari pembaca layar selama terkunci.
          ExcludeSemantics(
            excluding: state.status != LockStatus.unlocked,
            child: child,
          ),
          if (state.status == LockStatus.checking)
            Positioned.fill(child: ColoredBox(color: context.palette.surface)),
          if (state.status == LockStatus.locked)
            Positioned.fill(
              // Navigator sendiri: dialog "Lupa PIN" butuh Navigator dan
              // Overlay, sementara widget ini berada di atas Navigator router.
              child: Navigator(
                onGenerateRoute: (_) =>
                    MaterialPageRoute<void>(builder: (_) => const LockScreen()),
              ),
            ),
        ],
      ),
    );
  }
}
