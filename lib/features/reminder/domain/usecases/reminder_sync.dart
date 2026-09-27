import 'dart:async';

import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/utils/local_date.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/repositories/glucose_repository.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/entities/reminder.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/repositories/reminder_repository.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/services/notification_scheduler.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/usecases/plan_reminder_schedule.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

/// Menjaga jadwal notifikasi di OS selalu sesuai database.
///
/// Rekonsiliasi dipicu oleh tiga hal (rencana implementasi §3.3):
/// 1. daftar pengingat berubah;
/// 2. GDP hari ini tersimpan atau dihapus — pengingat puasa hari ini
///    dilewati atau dikembalikan (PRD F-07 AC4);
/// 3. aplikasi dibuka atau kembali dari background ([refresh]), karena
///    tanggal "hari ini" bisa sudah berganti.
@lazySingleton
class ReminderSync {
  new(this._reminders, this._readings, this._scheduler, this._plan);

  final ReminderRepository _reminders;
  final GlucoseRepository _readings;
  final NotificationScheduler _scheduler;
  final PlanReminderSchedule _plan;

  /// Diganti di test agar "hari ini" bisa dipatok.
  @visibleForTesting
  DateTime Function() clock = DateTime.now;

  StreamSubscription<List<Reminder>>? _reminderSub;
  StreamSubscription<List<GlucoseReading>>? _todaySub;

  List<Reminder>? _latestReminders;
  bool _fastingLoggedToday = false;
  String? _subscribedDate;

  /// Rantai sinkronisasi: `replaceAll` tidak boleh berjalan bersamaan,
  /// atau jadwal lama bisa menimpa jadwal yang lebih baru.
  Future<void> _pending = Future.value();

  bool get isRunning => _reminderSub != null;

  void start() {
    if (isRunning) {
      refresh();
      return;
    }
    _reminderSub = _reminders.watchReminders().listen((reminders) {
      _latestReminders = reminders;
      _enqueueSync();
    });
    _watchToday();
  }

  /// Dipanggil saat aplikasi kembali ke depan.
  void refresh() {
    if (!isRunning) return;
    if (_subscribedDate != LocalDate.ofLocal(clock())) {
      _watchToday();
    } else {
      _enqueueSync();
    }
  }

  /// Menunggu seluruh sinkronisasi yang sedang antre; untuk test.
  @visibleForTesting
  Future<void> get idle => _pending;

  void _watchToday() {
    final today = LocalDate.ofLocal(clock());
    _subscribedDate = today;
    _fastingLoggedToday = false;

    unawaited(_todaySub?.cancel());
    _todaySub = _readings
        .watchReadingsBetween(fromLocalDate: today, toLocalDate: today)
        .listen((readings) {
          final logged = readings.any((r) => r.type == ReadingType.fasting);
          if (logged == _fastingLoggedToday && _latestReminders != null) {
            return;
          }
          _fastingLoggedToday = logged;
          _enqueueSync();
        });
  }

  void _enqueueSync() {
    final reminders = _latestReminders;
    if (reminders == null) return;

    _pending = _pending.then((_) async {
      final now = clock();
      final plan = _plan(
        reminders: reminders,
        now: now,
        fastingLoggedDates: {
          if (_fastingLoggedToday) LocalDate.ofLocal(now),
        },
      );
      try {
        await _scheduler.replaceAll(plan);
      } on Object {
        // Kegagalan plugin (mis. izin dicabut) tidak boleh merusak alur
        // pencatatan; sinkronisasi berikutnya akan mencoba lagi.
      }
    });
  }

  Future<void> stop() async {
    await Future.wait([?_reminderSub?.cancel(), ?_todaySub?.cancel()]);
    _reminderSub = null;
    _todaySub = null;
    _latestReminders = null;
    _subscribedDate = null;
  }
}
