import 'package:clock/clock.dart';
import 'package:drift/drift.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/error/failures.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/database/daos/reminder_dao.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/entities/reminder.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/repositories/reminder_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ReminderRepository)
class ReminderRepositoryImpl implements ReminderRepository {
  new(this._dao);

  final ReminderDao _dao;

  @override
  Future<Either<Failure, List<Reminder>>> getReminders() async {
    try {
      return Right((await _dao.all()).map(_toEntity).toList());
    } on Object catch (e) {
      return Left(DatabaseFailure('Gagal membaca pengingat: $e'));
    }
  }

  @override
  Stream<List<Reminder>> watchReminders() =>
      _dao.watchAll().map((rows) => rows.map(_toEntity).toList());

  @override
  Future<Either<Failure, Reminder>> upsert(Reminder reminder) async {
    if (reminder.timeOfMinutes < 0 || reminder.timeOfMinutes > 1439) {
      return const Left(ValidationFailure('Jam pengingat tidak valid.'));
    }
    if (reminder.daysMask == 0) {
      return const Left(
        ValidationFailure('Pilih minimal satu hari untuk pengingat ini.'),
      );
    }

    try {
      final companion = RemindersTableCompanion.insert(
        label: reminder.label,
        readingType: Value(reminder.readingType?.dbValue),
        timeOfMinutes: reminder.timeOfMinutes,
        daysMask: Value(reminder.daysMask),
        isActive: Value(reminder.isActive),
        createdAt: clock.now().millisecondsSinceEpoch,
      );

      if (reminder.id == null) {
        final id = await _dao.insertReminder(companion);
        return Right(reminder.copyWith(id: id));
      }

      await _dao.updateReminder(
        reminder.id!,
        RemindersTableCompanion(
          label: Value(reminder.label),
          readingType: Value(reminder.readingType?.dbValue),
          timeOfMinutes: Value(reminder.timeOfMinutes),
          daysMask: Value(reminder.daysMask),
          isActive: Value(reminder.isActive),
        ),
      );
      return Right(reminder);
    } on Object catch (e) {
      return Left(DatabaseFailure('Gagal menyimpan pengingat: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> delete(int id) async {
    try {
      await _dao.deleteReminder(id);
      return const Right(unit);
    } on Object catch (e) {
      return Left(DatabaseFailure('Gagal menghapus pengingat: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> setActive(
    int id, {
    required bool isActive,
  }) async {
    try {
      await _dao.setActive(id, isActive: isActive);
      return const Right(unit);
    } on Object catch (e) {
      return Left(DatabaseFailure('Gagal mengubah pengingat: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> setFastingReminder({
    required int timeOfMinutes,
    required bool isActive,
  }) async {
    if (timeOfMinutes < 0 || timeOfMinutes > 1439) {
      return const Left(ValidationFailure('Jam pengingat tidak valid.'));
    }

    try {
      final rows = await _dao.all();
      final existing = rows
          .where((r) => r.readingType == ReadingType.fasting.dbValue)
          .firstOrNull;

      if (existing == null) {
        await _dao.insertReminder(
          RemindersTableCompanion.insert(
            label: 'Cek gula darah puasa',
            readingType: Value(ReadingType.fasting.dbValue),
            timeOfMinutes: timeOfMinutes,
            isActive: Value(isActive),
            createdAt: clock.now().millisecondsSinceEpoch,
          ),
        );
      } else {
        await _dao.updateReminder(
          existing.id,
          RemindersTableCompanion(
            timeOfMinutes: Value(timeOfMinutes),
            isActive: Value(isActive),
          ),
        );
      }
      return const Right(unit);
    } on Object catch (e) {
      return Left(DatabaseFailure('Gagal menyimpan pengingat puasa: $e'));
    }
  }

  Reminder _toEntity(ReminderRow row) => Reminder(
    id: row.id,
    label: row.label,
    timeOfMinutes: row.timeOfMinutes,
    readingType: row.readingType == null
        ? null
        : ReadingType.fromDb(row.readingType!),
    daysMask: row.daysMask,
    isActive: row.isActive,
  );
}
