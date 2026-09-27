import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/features/trend/domain/entities/trend_summary.dart';
import 'package:meta/meta.dart';

/// State layar Tren (S-08).
@immutable
class TrendState {
  const new({
    this.summary,
    this.period = TrendPeriod.twoWeeks,
    this.visibleTypes = const {ReadingType.fasting, ReadingType.random},
    this.unit = GlucoseUnit.mgDl,
    this.isLoading = true,
    this.errorMessage,
  });

  final TrendSummary? summary;
  final TrendPeriod period;

  /// Garis yang sedang ditampilkan (PRD F-06 AC1: GDP dan GDS bisa di-toggle).
  final Set<ReadingType> visibleTypes;

  final GlucoseUnit unit;
  final bool isLoading;
  final String? errorMessage;

  bool isVisible(ReadingType type) => visibleTypes.contains(type);

  TrendState copyWith({
    TrendSummary? summary,
    TrendPeriod? period,
    Set<ReadingType>? visibleTypes,
    GlucoseUnit? unit,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) => TrendState(
    summary: summary ?? this.summary,
    period: period ?? this.period,
    visibleTypes: visibleTypes ?? this.visibleTypes,
    unit: unit ?? this.unit,
    isLoading: isLoading ?? this.isLoading,
    errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
  );

  @override
  bool operator ==(Object other) =>
      other is TrendState &&
      identical(other.summary, summary) &&
      other.period == period &&
      other.visibleTypes.length == visibleTypes.length &&
      other.visibleTypes.containsAll(visibleTypes) &&
      other.unit == unit &&
      other.isLoading == isLoading &&
      other.errorMessage == errorMessage;

  @override
  int get hashCode => Object.hash(
    summary,
    period,
    Object.hashAllUnordered(visibleTypes),
    unit,
    isLoading,
    errorMessage,
  );
}
