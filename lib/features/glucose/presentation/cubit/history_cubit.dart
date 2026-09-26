import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/utils/local_date.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/reading_group.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/repositories/glucose_repository.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/delete_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/presentation/cubit/history_state.dart';
import 'package:flutter_gluko_apps/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class HistoryCubit extends Cubit<HistoryState> {
  new(
    this._repository,
    this._profiles,
    this._deleteReading,
    this._restoreReading,
  ) : super(const HistoryState());

  final GlucoseRepository _repository;
  final ProfileRepository _profiles;
  final DeleteReading _deleteReading;
  final RestoreReading _restoreReading;

  StreamSubscription<List<GlucoseReading>>? _historySub;
  StreamSubscription<void>? _profileSub;

  void start() {
    _subscribe();

    unawaited(_profileSub?.cancel());
    _profileSub = _profiles.watchProfile().listen(
      (profile) => emit(state.copyWith(unit: profile.unit)),
    );
  }

  void _subscribe() {
    unawaited(_historySub?.cancel());

    // Satu item lebih banyak dari batas halaman dipakai untuk mengetahui
    // apakah masih ada halaman berikutnya, tanpa query COUNT terpisah.
    final probeLimit = state.limit + 1;

    _historySub = _repository
        .watchHistory(
          type: state.typeFilter,
          status: state.statusFilter,
          limit: probeLimit,
        )
        .listen(
          (readings) {
            final hasMore = readings.length > state.limit;
            final visible = hasMore
                ? readings.sublist(0, state.limit)
                : readings;

            emit(
              state.copyWith(
                groups: ReadingGrouper.byLocalDate(visible),
                isLoading: false,
                hasMore: hasMore,
                clearError: true,
              ),
            );
          },
          onError: (Object error) => emit(
            state.copyWith(
              isLoading: false,
              errorMessage: 'Gagal memuat riwayat: $error',
            ),
          ),
        );
  }

  void setTypeFilter(ReadingType? type) {
    if (type == state.typeFilter) return;
    // Filter baru berarti halaman diulang dari awal.
    emit(
      state.copyWith(
        typeFilter: type,
        clearTypeFilter: type == null,
        limit: HistoryState.pageSize,
        isLoading: true,
      ),
    );
    _subscribe();
  }

  void setStatusFilter(GlucoseStatus? status) {
    if (status == state.statusFilter) return;
    emit(
      state.copyWith(
        statusFilter: status,
        clearStatusFilter: status == null,
        limit: HistoryState.pageSize,
        isLoading: true,
      ),
    );
    _subscribe();
  }

  void loadMore() {
    if (!state.hasMore || state.isLoading) return;
    emit(state.copyWith(limit: state.limit + HistoryState.pageSize));
    _subscribe();
  }

  void setViewMode(HistoryViewMode mode) {
    if (mode == state.viewMode) return;
    emit(state.copyWith(viewMode: mode));
    if (mode == HistoryViewMode.calendar) {
      unawaited(loadCalendar(month: state.calendarMonth ?? DateTime.now()));
    }
  }

  /// Memuat titik warna kalender untuk satu bulan (PRD F-05 AC4).
  Future<void> loadCalendar({required DateTime month}) async {
    final first = DateTime(month.year, month.month);
    final last = DateTime(month.year, month.month + 1, 0);

    final result = await _repository.worstStatusPerDay(
      fromLocalDate: LocalDate.ofLocal(first),
      toLocalDate: LocalDate.ofLocal(last),
    );

    switch (result) {
      case Left(value: final failure):
        emit(state.copyWith(errorMessage: failure.message));
      case Right(value: final statuses):
        emit(
          state.copyWith(
            calendarStatuses: statuses,
            calendarMonth: first,
            clearError: true,
          ),
        );
    }
  }

  /// Hapus dengan Undo (PRD F-05 AC3).
  ///
  /// Mengembalikan pesan kegagalan, atau `null` bila berhasil, supaya
  /// pemanggil bisa memutuskan menampilkan snackbar Undo atau pesan error.
  Future<String?> delete(int id) async {
    final result = await _deleteReading(id);
    return result.fold<String?>((failure) => failure.message, (_) => null);
  }

  Future<String?> undoDelete(int id) async {
    final result = await _restoreReading(id);
    return result.fold<String?>((failure) => failure.message, (_) => null);
  }

  @override
  Future<void> close() async {
    await _historySub?.cancel();
    await _profileSub?.cancel();
    return await super.close();
  }
}
