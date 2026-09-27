import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/entities/reminder.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/repositories/reminder_repository.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/services/notification_scheduler.dart';
import 'package:flutter_gluko_apps/features/reminder/presentation/cubit/reminders_state.dart';
import 'package:injectable/injectable.dart';

/// Layar S-11: daftar, tambah, ubah, dan hapus pengingat (PRD F-07 AC1).
///
/// Cubit ini hanya menulis ke database. Penjadwalan ulang notifikasi
/// dikerjakan `ReminderSync`, yang mendengarkan stream pengingat yang sama.
@injectable
class RemindersCubit extends Cubit<RemindersState> {
  new(this._repository, this._scheduler) : super(const RemindersState());

  final ReminderRepository _repository;
  final NotificationScheduler _scheduler;

  StreamSubscription<List<Reminder>>? _sub;

  void start() {
    unawaited(_sub?.cancel());
    _sub = _repository.watchReminders().listen(
      (reminders) =>
          emit(state.copyWith(reminders: reminders, isLoading: false)),
      onError: (Object e) => emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Gagal memuat pengingat: $e',
        ),
      ),
    );
    unawaited(refreshPermission());
  }

  Future<void> refreshPermission() async {
    try {
      final status = await _scheduler.permissionStatus();
      if (!isClosed) emit(state.copyWith(permission: status));
    } on Object {
      // Status izin hanya informasi; kegagalannya tidak menghalangi layar.
    }
  }

  Future<void> requestPermissions() async {
    try {
      final status = await _scheduler.requestPermissions();
      if (!isClosed) emit(state.copyWith(permission: status));
    } on Object catch (e) {
      if (!isClosed) {
        emit(state.copyWith(errorMessage: 'Gagal meminta izin: $e'));
      }
    }
  }

  /// Mengembalikan `true` bila tersimpan, agar dialog tahu kapan menutup.
  Future<bool> save(Reminder reminder) async {
    final result = await _repository.upsert(reminder);
    if (isClosed) return result.isRight();
    return result.match<bool>(
      (failure) {
        emit(state.copyWith(errorMessage: failure.message));
        return false;
      },
      (_) {
        emit(
          state.copyWith(
            infoMessage: reminder.id == null
                ? 'Pengingat ditambahkan.'
                : 'Pengingat diperbarui.',
          ),
        );
        return true;
      },
    );
  }

  Future<void> setActive(Reminder reminder, {required bool isActive}) async {
    final id = reminder.id;
    if (id == null) return;
    final result = await _repository.setActive(id, isActive: isActive);
    result.match((failure) {
      if (!isClosed) emit(state.copyWith(errorMessage: failure.message));
    }, (_) {});
  }

  Future<void> delete(Reminder reminder) async {
    final id = reminder.id;
    if (id == null) return;
    final result = await _repository.delete(id);
    if (isClosed) return;
    result.match(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => emit(state.copyWith(infoMessage: 'Pengingat dihapus.')),
    );
  }

  void clearMessages() =>
      emit(state.copyWith(errorMessage: null, infoMessage: null));

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return await super.close();
  }
}
