import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:meta/meta.dart';

/// Pengingat cek gula darah (PRD F-07).
@immutable
class Reminder {
  const new({
    required this.label,
    required this.timeOfMinutes,
    this.id,
    this.readingType,
    this.daysMask = everyDay,
    this.isActive = true,
  });

  /// Bit 0 = Senin … bit 6 = Minggu (PRD 8.2).
  static const int everyDay = 127;

  final int? id;
  final String label;

  /// Menit sejak tengah malam, 0–1439.
  final int timeOfMinutes;

  /// Tipe yang akan terisi otomatis saat notifikasi dibuka (PRD F-07 AC3).
  final ReadingType? readingType;

  final int daysMask;
  final bool isActive;

  int get hour => timeOfMinutes ~/ 60;
  int get minute => timeOfMinutes % 60;

  /// `weekday` mengikuti konvensi Dart: 1 = Senin … 7 = Minggu.
  bool runsOnWeekday(int weekday) => (daysMask & (1 << (weekday - 1))) != 0;

  /// Daftar weekday Dart tempat pengingat ini aktif.
  List<int> get activeWeekdays => [
    for (var d = 1; d <= 7; d++)
      if (runsOnWeekday(d)) d,
  ];

  bool get isDaily => daysMask == everyDay;

  /// `HH.mm`, format jam Indonesia seperti pada desain.
  String get formattedTime =>
      '${hour.toString().padLeft(2, '0')}.${minute.toString().padLeft(2, '0')}';

  Reminder copyWith({
    int? id,
    String? label,
    int? timeOfMinutes,
    ReadingType? readingType,
    int? daysMask,
    bool? isActive,
  }) => Reminder(
    id: id ?? this.id,
    label: label ?? this.label,
    timeOfMinutes: timeOfMinutes ?? this.timeOfMinutes,
    readingType: readingType ?? this.readingType,
    daysMask: daysMask ?? this.daysMask,
    isActive: isActive ?? this.isActive,
  );

  @override
  bool operator ==(Object other) =>
      other is Reminder &&
      other.id == id &&
      other.label == label &&
      other.timeOfMinutes == timeOfMinutes &&
      other.readingType == readingType &&
      other.daysMask == daysMask &&
      other.isActive == isActive;

  @override
  int get hashCode =>
      Object.hash(id, label, timeOfMinutes, readingType, daysMask, isActive);
}
