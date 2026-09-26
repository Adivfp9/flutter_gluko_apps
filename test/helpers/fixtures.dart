import 'package:drift/drift.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';

/// Companion pembacaan dengan nilai wajar, supaya tiap test hanya menyebut
/// field yang benar-benar sedang diuji.
GlucoseReadingsTableCompanion readingCompanion({
  int valueMgDl = 98,
  ReadingType type = ReadingType.fasting,
  String localDate = '2026-09-26',
  GlucoseStatus status = GlucoseStatus.normal,
  DateTime? measuredAt,
  int tzOffsetMin = 420,
  String? note,
  bool isCritical = false,
  MealContext? mealContext,
  double? hoursAfterMeal,
}) {
  final at = measuredAt ?? DateTime.utc(2026, 9, 25, 23, 12);
  final ms = at.millisecondsSinceEpoch;

  return GlucoseReadingsTableCompanion.insert(
    readingType: type.dbValue,
    valueMgDl: valueMgDl,
    measuredAt: ms,
    tzOffsetMin: tzOffsetMin,
    localDate: localDate,
    status: status.dbValue,
    isCritical: Value(isCritical),
    mealContext: Value(mealContext?.dbValue),
    hoursAfterMeal: Value(hoursAfterMeal),
    note: Value(note),
    createdAt: ms,
    updatedAt: ms,
  );
}
