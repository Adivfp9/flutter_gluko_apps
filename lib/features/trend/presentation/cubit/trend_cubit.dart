import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/utils/local_date.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/repositories/glucose_repository.dart';
import 'package:flutter_gluko_apps/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_gluko_apps/features/target/domain/entities/target_set.dart';
import 'package:flutter_gluko_apps/features/target/domain/repositories/target_repository.dart';
import 'package:flutter_gluko_apps/features/trend/domain/entities/trend_summary.dart';
import 'package:flutter_gluko_apps/features/trend/domain/usecases/build_trend_summary.dart';
import 'package:flutter_gluko_apps/features/trend/presentation/cubit/trend_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class TrendCubit extends Cubit<TrendState> {
  new(this._readings, this._targets, this._profiles, this._build)
    : super(const TrendState());

  final GlucoseRepository _readings;
  final TargetRepository _targets;
  final ProfileRepository _profiles;
  final BuildTrendSummary _build;

  StreamSubscription<List<GlucoseReading>>? _readingsSub;
  StreamSubscription<void>? _profileSub;
  StreamSubscription<TargetSet>? _targetSub;

  TargetSet? _currentTargets;
  List<GlucoseReading>? _lastReadings;

  /// Waktu acuan tetap untuk test; `null` berarti memakai jam saat ini.
  DateTime? _fixedNow;

  DateTime get _now => _fixedNow ?? DateTime.now();

  void start({DateTime? now}) {
    _fixedNow = now;

    unawaited(_targetSub?.cancel());
    _targetSub = _targets.watchTargets().listen((targets) {
      _currentTargets = targets;
      // Target hanya menggeser pita; data pembacaan tidak perlu dimuat ulang.
      _rebuild();
    });

    unawaited(_profileSub?.cancel());
    _profileSub = _profiles.watchProfile().listen(
      (profile) => emit(state.copyWith(unit: profile.unit)),
    );

    _subscribe();
  }

  void setPeriod(TrendPeriod period) {
    if (period == state.period) return;
    emit(state.copyWith(period: period, isLoading: true));
    _subscribe();
  }

  void toggleType(ReadingType type) {
    final next = {...state.visibleTypes};
    if (!next.remove(type)) next.add(type);
    // Menyembunyikan semua garis membuat grafik kosong tanpa penjelasan;
    // minimal satu tipe selalu tampil.
    if (next.isEmpty) return;
    emit(state.copyWith(visibleTypes: next));
  }

  void _subscribe() {
    final reference = _now;
    final from = DateTime(
      reference.year,
      reference.month,
      reference.day - (state.period.days - 1),
    );

    unawaited(_readingsSub?.cancel());
    _lastReadings = null;
    _readingsSub = _readings
        .watchReadingsBetween(
          fromLocalDate: LocalDate.ofLocal(from),
          toLocalDate: LocalDate.ofLocal(reference),
        )
        .listen(
          (readings) {
            _lastReadings = readings;
            _rebuild();
          },
          onError: (Object error) => emit(
            state.copyWith(
              isLoading: false,
              errorMessage: 'Gagal memuat tren: $error',
            ),
          ),
        );
  }

  void _rebuild() {
    final readings = _lastReadings;
    if (readings == null || isClosed) return;
    emit(
      state.copyWith(
        summary: _build(
          readings: readings,
          period: state.period,
          now: _now,
          // Pita target mengikuti tipe puasa: itu yang paling sering
          // dipantau harian dan yang ditandai pada desain.
          band: _currentTargets?.forType(ReadingType.fasting),
        ),
        isLoading: false,
        clearError: true,
      ),
    );
  }

  @override
  Future<void> close() async {
    // Dibatalkan serentak: pembatalan berurutan menunda sisa stream drift
    // sampai setelah widget dilepas.
    await Future.wait([
      ?_readingsSub?.cancel(),
      ?_profileSub?.cancel(),
      ?_targetSub?.cancel(),
    ]);
    return await super.close();
  }
}
