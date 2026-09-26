import 'package:flutter_gluko_apps/core/error/failures.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/entities/reminder.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ReminderRepository {
  Future<Either<Failure, List<Reminder>>> getReminders();

  Stream<List<Reminder>> watchReminders();

  Future<Either<Failure, Reminder>> upsert(Reminder reminder);

  Future<Either<Failure, Unit>> delete(int id);

  Future<Either<Failure, Unit>> setActive(int id, {required bool isActive});

  /// Menyetel pengingat puasa bawaan yang dibuat saat seed database.
  ///
  /// Dipakai onboarding (PRD F-10 AC1) dan layar Pengaturan, sehingga keduanya
  /// mengubah baris yang sama alih-alih membuat pengingat duplikat.
  Future<Either<Failure, Unit>> setFastingReminder({
    required int timeOfMinutes,
    required bool isActive,
  });
}
