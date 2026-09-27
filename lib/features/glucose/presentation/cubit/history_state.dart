import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/reading_group.dart';
import 'package:meta/meta.dart';

/// Dua tampilan riwayat (PRD F-05 AC4).
enum HistoryViewMode { list, calendar }

/// State layar Riwayat (S-06).
@immutable
class HistoryState {
  const new({
    this.groups = const [],
    this.calendarStatuses = const {},
    this.viewMode = HistoryViewMode.list,
    this.typeFilter,
    this.statusFilter,
    this.unit = GlucoseUnit.mgDl,
    this.limit = pageSize,
    this.isLoading = true,
    this.hasMore = false,
    this.calendarMonth,
    this.errorMessage,
  });

  /// PRD F-05 AC1: paginasi 30 item.
  static const int pageSize = 30;

  final List<ReadingGroup> groups;

  /// Status terburuk per tanggal untuk tampilan kalender.
  final Map<String, GlucoseStatus> calendarStatuses;

  final HistoryViewMode viewMode;

  /// `null` berarti "Semua".
  final ReadingType? typeFilter;
  final GlucoseStatus? statusFilter;

  final GlucoseUnit unit;
  final int limit;
  final bool isLoading;

  /// Masih ada halaman berikutnya untuk dimuat.
  final bool hasMore;

  /// Bulan yang sedang ditampilkan pada mode kalender.
  final DateTime? calendarMonth;

  final String? errorMessage;

  bool get isEmpty => groups.isEmpty;

  bool get hasActiveFilter => typeFilter != null || statusFilter != null;

  int get totalReadings =>
      groups.fold(0, (sum, group) => sum + group.readings.length);

  HistoryState copyWith({
    List<ReadingGroup>? groups,
    Map<String, GlucoseStatus>? calendarStatuses,
    HistoryViewMode? viewMode,
    ReadingType? typeFilter,
    GlucoseStatus? statusFilter,
    GlucoseUnit? unit,
    int? limit,
    bool? isLoading,
    bool? hasMore,
    DateTime? calendarMonth,
    String? errorMessage,
    bool clearTypeFilter = false,
    bool clearStatusFilter = false,
    bool clearError = false,
  }) => HistoryState(
    groups: groups ?? this.groups,
    calendarStatuses: calendarStatuses ?? this.calendarStatuses,
    viewMode: viewMode ?? this.viewMode,
    typeFilter: clearTypeFilter ? null : (typeFilter ?? this.typeFilter),
    statusFilter: clearStatusFilter
        ? null
        : (statusFilter ?? this.statusFilter),
    unit: unit ?? this.unit,
    limit: limit ?? this.limit,
    isLoading: isLoading ?? this.isLoading,
    hasMore: hasMore ?? this.hasMore,
    calendarMonth: calendarMonth ?? this.calendarMonth,
    errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
  );

  @override
  bool operator ==(Object other) =>
      other is HistoryState &&
      _sameGroups(other.groups, groups) &&
      other.calendarStatuses.length == calendarStatuses.length &&
      other.viewMode == viewMode &&
      other.typeFilter == typeFilter &&
      other.statusFilter == statusFilter &&
      other.unit == unit &&
      other.limit == limit &&
      other.isLoading == isLoading &&
      other.hasMore == hasMore &&
      other.calendarMonth == calendarMonth &&
      other.errorMessage == errorMessage;

  static bool _sameGroups(List<ReadingGroup> a, List<ReadingGroup> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(groups),
    calendarStatuses.length,
    viewMode,
    typeFilter,
    statusFilter,
    unit,
    limit,
    isLoading,
    hasMore,
    calendarMonth,
    errorMessage,
  );
}
