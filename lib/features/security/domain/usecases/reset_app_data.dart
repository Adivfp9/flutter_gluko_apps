import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/services/notification_scheduler.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/usecases/reminder_sync.dart';
import 'package:flutter_gluko_apps/features/security/domain/repositories/security_repository.dart';
import 'package:injectable/injectable.dart';

/// "Lupa PIN" → hapus semua data dan mulai dari onboarding.
///
/// Gate Sprint 4: lupa PIN harus punya jalan keluar. PIN tidak bisa
/// dipulihkan (hanya hash-nya yang tersimpan), jadi jalan keluarnya adalah
/// memulai ulang aplikasi; data bisa dikembalikan dari file `.gtbak`.
@lazySingleton
class ResetAppData {
  new(this._database, this._security, this._reminderSync, this._scheduler);

  final AppDatabase _database;
  final SecurityRepository _security;
  final ReminderSync _reminderSync;
  final NotificationScheduler _scheduler;

  Future<void> call() async {
    // Sinkronisasi dihentikan dulu: seed ulang membuat pengingat puasa
    // bawaan aktif lagi, padahal onboarding belum diulang.
    await _reminderSync.stop();
    try {
      await _scheduler.replaceAll(const []);
    } on Object {
      // Notifikasi yang tersisa hanya membuka form catat; tidak cukup
      // penting untuk menggagalkan reset.
    }
    await _database.wipeAllData();
    await _security.clearSecrets();
  }
}
