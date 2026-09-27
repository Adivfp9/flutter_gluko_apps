import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/dashboard_summary.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/watch_dashboard.dart';
import 'package:flutter_gluko_apps/features/glucose/presentation/cubit/dashboard_state.dart';
import 'package:flutter_gluko_apps/features/profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DashboardCubit extends Cubit<DashboardState> {
  new(this._watchDashboard, this._profiles) : super(const DashboardState());

  final WatchDashboard _watchDashboard;
  final ProfileRepository _profiles;

  StreamSubscription<DashboardSummary>? _summarySub;
  StreamSubscription<void>? _profileSub;

  /// Tanggal acuan langganan yang sedang berjalan, dipakai untuk mendeteksi
  /// pergantian hari saat aplikasi kembali dari background.
  DateTime? _subscribedFor;

  void start({DateTime? now}) {
    final reference = now ?? DateTime.now();
    _subscribedFor = reference;

    unawaited(_summarySub?.cancel());
    _summarySub = _watchDashboard(reference).listen(
      (summary) => emit(
        state.copyWith(summary: summary, isLoading: false, clearError: true),
      ),
      onError: (Object error) => emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Gagal memuat beranda: $error',
        ),
      ),
    );

    unawaited(_profileSub?.cancel());
    _profileSub = _profiles.watchProfile().listen(
      (profile) => emit(
        state.copyWith(unit: profile.unit, userName: profile.greetingName()),
      ),
    );
  }

  /// Dipanggil saat aplikasi kembali aktif.
  ///
  /// Jendela tanggal beranda ditetapkan saat berlangganan, jadi melewati
  /// tengah malam tanpa berlangganan ulang akan membuat "hari ini" tertinggal.
  void refreshIfDayChanged({DateTime? now}) {
    final current = now ?? DateTime.now();
    final previous = _subscribedFor;
    if (previous == null) return;

    final sameDay =
        previous.year == current.year &&
        previous.month == current.month &&
        previous.day == current.day;
    if (!sameDay) start(now: current);
  }

  @override
  Future<void> close() async {
    // Dibatalkan serentak: pembatalan berurutan menunda stream drift kedua
    // sampai setelah widget dilepas (lihat TrendCubit.close).
    await Future.wait([?_summarySub?.cancel(), ?_profileSub?.cancel()]);
    return await super.close();
  }
}
