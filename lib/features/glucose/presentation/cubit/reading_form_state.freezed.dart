// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reading_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReadingFormState {

 bool get isLoading; bool get isSubmitting; ReadingType get type; GlucoseUnit get unit; String get rawValue; int? get valueMgDl; DateTime? get measuredAt; TargetSet? get targets; Classification? get classification; bool get fastingConfirmed; MealContext? get mealContext; double? get hoursAfterMeal; Set<Symptom> get symptoms; String get note; String? get errorMessage; DuplicateFastingFailure? get duplicateFasting; GlucoseReading? get savedReading;/// Terisi saat form dipakai menyunting catatan lama (PRD F-05 AC3).
 int? get editingId;
/// Create a copy of ReadingFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReadingFormStateCopyWith<ReadingFormState> get copyWith => _$ReadingFormStateCopyWithImpl<ReadingFormState>(this as ReadingFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ReadingFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReadingFormState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.unit, _this.unit) || other.unit == _this.unit)&&(identical(other.rawValue, _this.rawValue) || other.rawValue == _this.rawValue)&&(identical(other.valueMgDl, _this.valueMgDl) || other.valueMgDl == _this.valueMgDl)&&(identical(other.measuredAt, _this.measuredAt) || other.measuredAt == _this.measuredAt)&&(identical(other.targets, _this.targets) || other.targets == _this.targets)&&(identical(other.classification, _this.classification) || other.classification == _this.classification)&&(identical(other.fastingConfirmed, _this.fastingConfirmed) || other.fastingConfirmed == _this.fastingConfirmed)&&(identical(other.mealContext, _this.mealContext) || other.mealContext == _this.mealContext)&&(identical(other.hoursAfterMeal, _this.hoursAfterMeal) || other.hoursAfterMeal == _this.hoursAfterMeal)&&const DeepCollectionEquality().equals(other.symptoms, _this.symptoms)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.errorMessage, _this.errorMessage) || other.errorMessage == _this.errorMessage)&&(identical(other.duplicateFasting, _this.duplicateFasting) || other.duplicateFasting == _this.duplicateFasting)&&(identical(other.savedReading, _this.savedReading) || other.savedReading == _this.savedReading)&&(identical(other.editingId, _this.editingId) || other.editingId == _this.editingId));
}


@override
int get hashCode {
  final _this = this as ReadingFormState;
  return Object.hash(runtimeType,_this.isLoading,_this.isSubmitting,_this.type,_this.unit,_this.rawValue,_this.valueMgDl,_this.measuredAt,_this.targets,_this.classification,_this.fastingConfirmed,_this.mealContext,_this.hoursAfterMeal,const DeepCollectionEquality().hash(_this.symptoms),_this.note,_this.errorMessage,_this.duplicateFasting,_this.savedReading,_this.editingId);
}

@override
String toString() {
  final _this = this as ReadingFormState;
  return 'ReadingFormState(isLoading: ${_this.isLoading}, isSubmitting: ${_this.isSubmitting}, type: ${_this.type}, unit: ${_this.unit}, rawValue: ${_this.rawValue}, valueMgDl: ${_this.valueMgDl}, measuredAt: ${_this.measuredAt}, targets: ${_this.targets}, classification: ${_this.classification}, fastingConfirmed: ${_this.fastingConfirmed}, mealContext: ${_this.mealContext}, hoursAfterMeal: ${_this.hoursAfterMeal}, symptoms: ${_this.symptoms}, note: ${_this.note}, errorMessage: ${_this.errorMessage}, duplicateFasting: ${_this.duplicateFasting}, savedReading: ${_this.savedReading}, editingId: ${_this.editingId})';
}


}

/// @nodoc
abstract mixin class $ReadingFormStateCopyWith<$Res>  {
  factory $ReadingFormStateCopyWith(ReadingFormState value, $Res Function(ReadingFormState) _then) = _$ReadingFormStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isSubmitting, ReadingType type, GlucoseUnit unit, String rawValue, int? valueMgDl, DateTime? measuredAt, TargetSet? targets, Classification? classification, bool fastingConfirmed, MealContext? mealContext, double? hoursAfterMeal, Set<Symptom> symptoms, String note, String? errorMessage, DuplicateFastingFailure? duplicateFasting, GlucoseReading? savedReading, int? editingId
});


$GlucoseReadingCopyWith<$Res>? get savedReading;

}
/// @nodoc
class _$ReadingFormStateCopyWithImpl<$Res>
    implements $ReadingFormStateCopyWith<$Res> {
  _$ReadingFormStateCopyWithImpl(this._self, this._then);

  final ReadingFormState _self;
  final $Res Function(ReadingFormState) _then;

/// Create a copy of ReadingFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isSubmitting = null,Object? type = null,Object? unit = null,Object? rawValue = null,Object? valueMgDl = freezed,Object? measuredAt = freezed,Object? targets = freezed,Object? classification = freezed,Object? fastingConfirmed = null,Object? mealContext = freezed,Object? hoursAfterMeal = freezed,Object? symptoms = null,Object? note = null,Object? errorMessage = freezed,Object? duplicateFasting = freezed,Object? savedReading = freezed,Object? editingId = freezed,}) {
  return _then(ReadingFormState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ReadingType,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as GlucoseUnit,rawValue: null == rawValue ? _self.rawValue : rawValue // ignore: cast_nullable_to_non_nullable
as String,valueMgDl: freezed == valueMgDl ? _self.valueMgDl : valueMgDl // ignore: cast_nullable_to_non_nullable
as int?,measuredAt: freezed == measuredAt ? _self.measuredAt : measuredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,targets: freezed == targets ? _self.targets : targets // ignore: cast_nullable_to_non_nullable
as TargetSet?,classification: freezed == classification ? _self.classification : classification // ignore: cast_nullable_to_non_nullable
as Classification?,fastingConfirmed: null == fastingConfirmed ? _self.fastingConfirmed : fastingConfirmed // ignore: cast_nullable_to_non_nullable
as bool,mealContext: freezed == mealContext ? _self.mealContext : mealContext // ignore: cast_nullable_to_non_nullable
as MealContext?,hoursAfterMeal: freezed == hoursAfterMeal ? _self.hoursAfterMeal : hoursAfterMeal // ignore: cast_nullable_to_non_nullable
as double?,symptoms: null == symptoms ? _self.symptoms : symptoms // ignore: cast_nullable_to_non_nullable
as Set<Symptom>,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,duplicateFasting: freezed == duplicateFasting ? _self.duplicateFasting : duplicateFasting // ignore: cast_nullable_to_non_nullable
as DuplicateFastingFailure?,savedReading: freezed == savedReading ? _self.savedReading : savedReading // ignore: cast_nullable_to_non_nullable
as GlucoseReading?,editingId: freezed == editingId ? _self.editingId : editingId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of ReadingFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GlucoseReadingCopyWith<$Res>? get savedReading {
    if (_self.savedReading == null) {
    return null;
  }

  return $GlucoseReadingCopyWith<$Res>(_self.savedReading!, (value) {
    return _then(_self.copyWith(savedReading: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReadingFormState].
extension ReadingFormStatePatterns on ReadingFormState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReadingFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReadingFormState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReadingFormState value)  $default,){
final _that = this;
switch (_that) {
case _ReadingFormState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReadingFormState value)?  $default,){
final _that = this;
switch (_that) {
case _ReadingFormState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isSubmitting,  ReadingType type,  GlucoseUnit unit,  String rawValue,  int? valueMgDl,  DateTime? measuredAt,  TargetSet? targets,  Classification? classification,  bool fastingConfirmed,  MealContext? mealContext,  double? hoursAfterMeal,  Set<Symptom> symptoms,  String note,  String? errorMessage,  DuplicateFastingFailure? duplicateFasting,  GlucoseReading? savedReading,  int? editingId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReadingFormState() when $default != null:
return $default(_that.isLoading,_that.isSubmitting,_that.type,_that.unit,_that.rawValue,_that.valueMgDl,_that.measuredAt,_that.targets,_that.classification,_that.fastingConfirmed,_that.mealContext,_that.hoursAfterMeal,_that.symptoms,_that.note,_that.errorMessage,_that.duplicateFasting,_that.savedReading,_that.editingId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isSubmitting,  ReadingType type,  GlucoseUnit unit,  String rawValue,  int? valueMgDl,  DateTime? measuredAt,  TargetSet? targets,  Classification? classification,  bool fastingConfirmed,  MealContext? mealContext,  double? hoursAfterMeal,  Set<Symptom> symptoms,  String note,  String? errorMessage,  DuplicateFastingFailure? duplicateFasting,  GlucoseReading? savedReading,  int? editingId)  $default,) {final _that = this;
switch (_that) {
case _ReadingFormState():
return $default(_that.isLoading,_that.isSubmitting,_that.type,_that.unit,_that.rawValue,_that.valueMgDl,_that.measuredAt,_that.targets,_that.classification,_that.fastingConfirmed,_that.mealContext,_that.hoursAfterMeal,_that.symptoms,_that.note,_that.errorMessage,_that.duplicateFasting,_that.savedReading,_that.editingId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isSubmitting,  ReadingType type,  GlucoseUnit unit,  String rawValue,  int? valueMgDl,  DateTime? measuredAt,  TargetSet? targets,  Classification? classification,  bool fastingConfirmed,  MealContext? mealContext,  double? hoursAfterMeal,  Set<Symptom> symptoms,  String note,  String? errorMessage,  DuplicateFastingFailure? duplicateFasting,  GlucoseReading? savedReading,  int? editingId)?  $default,) {final _that = this;
switch (_that) {
case _ReadingFormState() when $default != null:
return $default(_that.isLoading,_that.isSubmitting,_that.type,_that.unit,_that.rawValue,_that.valueMgDl,_that.measuredAt,_that.targets,_that.classification,_that.fastingConfirmed,_that.mealContext,_that.hoursAfterMeal,_that.symptoms,_that.note,_that.errorMessage,_that.duplicateFasting,_that.savedReading,_that.editingId);case _:
  return null;

}
}

}

/// @nodoc


class _ReadingFormState extends ReadingFormState {
  const _ReadingFormState({this.isLoading = false, this.isSubmitting = false, this.type = ReadingType.random, this.unit = GlucoseUnit.mgDl, this.rawValue = '', this.valueMgDl, this.measuredAt, this.targets, this.classification, this.fastingConfirmed = true, this.mealContext, this.hoursAfterMeal,  Set<Symptom> symptoms = const <Symptom>{}, this.note = '', this.errorMessage, this.duplicateFasting, this.savedReading, this.editingId}): _symptoms = symptoms,super._();
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isSubmitting;
@override@JsonKey() final  ReadingType type;
@override@JsonKey() final  GlucoseUnit unit;
@override@JsonKey() final  String rawValue;
@override final  int? valueMgDl;
@override final  DateTime? measuredAt;
@override final  TargetSet? targets;
@override final  Classification? classification;
@override@JsonKey() final  bool fastingConfirmed;
@override final  MealContext? mealContext;
@override final  double? hoursAfterMeal;
 final  Set<Symptom> _symptoms;
@override@JsonKey() Set<Symptom> get symptoms {
  if (_symptoms is EqualUnmodifiableSetView) return _symptoms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_symptoms);
}

@override@JsonKey() final  String note;
@override final  String? errorMessage;
@override final  DuplicateFastingFailure? duplicateFasting;
@override final  GlucoseReading? savedReading;
/// Terisi saat form dipakai menyunting catatan lama (PRD F-05 AC3).
@override final  int? editingId;

/// Create a copy of ReadingFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReadingFormStateCopyWith<_ReadingFormState> get copyWith => __$ReadingFormStateCopyWithImpl<_ReadingFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReadingFormState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.type, type) || other.type == type)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.rawValue, rawValue) || other.rawValue == rawValue)&&(identical(other.valueMgDl, valueMgDl) || other.valueMgDl == valueMgDl)&&(identical(other.measuredAt, measuredAt) || other.measuredAt == measuredAt)&&(identical(other.targets, targets) || other.targets == targets)&&(identical(other.classification, classification) || other.classification == classification)&&(identical(other.fastingConfirmed, fastingConfirmed) || other.fastingConfirmed == fastingConfirmed)&&(identical(other.mealContext, mealContext) || other.mealContext == mealContext)&&(identical(other.hoursAfterMeal, hoursAfterMeal) || other.hoursAfterMeal == hoursAfterMeal)&&const DeepCollectionEquality().equals(other.symptoms, _symptoms)&&(identical(other.note, note) || other.note == note)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.duplicateFasting, duplicateFasting) || other.duplicateFasting == duplicateFasting)&&(identical(other.savedReading, savedReading) || other.savedReading == savedReading)&&(identical(other.editingId, editingId) || other.editingId == editingId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,isSubmitting,type,unit,rawValue,valueMgDl,measuredAt,targets,classification,fastingConfirmed,mealContext,hoursAfterMeal,const DeepCollectionEquality().hash(_symptoms),note,errorMessage,duplicateFasting,savedReading,editingId);
}

@override
String toString() {
    return 'ReadingFormState(isLoading: $isLoading, isSubmitting: $isSubmitting, type: $type, unit: $unit, rawValue: $rawValue, valueMgDl: $valueMgDl, measuredAt: $measuredAt, targets: $targets, classification: $classification, fastingConfirmed: $fastingConfirmed, mealContext: $mealContext, hoursAfterMeal: $hoursAfterMeal, symptoms: $symptoms, note: $note, errorMessage: $errorMessage, duplicateFasting: $duplicateFasting, savedReading: $savedReading, editingId: $editingId)';
}


}

/// @nodoc
abstract mixin class _$ReadingFormStateCopyWith<$Res> implements $ReadingFormStateCopyWith<$Res> {
  factory _$ReadingFormStateCopyWith(_ReadingFormState value, $Res Function(_ReadingFormState) _then) = __$ReadingFormStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isSubmitting, ReadingType type, GlucoseUnit unit, String rawValue, int? valueMgDl, DateTime? measuredAt, TargetSet? targets, Classification? classification, bool fastingConfirmed, MealContext? mealContext, double? hoursAfterMeal, Set<Symptom> symptoms, String note, String? errorMessage, DuplicateFastingFailure? duplicateFasting, GlucoseReading? savedReading, int? editingId
});


@override $GlucoseReadingCopyWith<$Res>? get savedReading;

}
/// @nodoc
class __$ReadingFormStateCopyWithImpl<$Res>
    implements _$ReadingFormStateCopyWith<$Res> {
  __$ReadingFormStateCopyWithImpl(this._self, this._then);

  final _ReadingFormState _self;
  final $Res Function(_ReadingFormState) _then;

/// Create a copy of ReadingFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isSubmitting = null,Object? type = null,Object? unit = null,Object? rawValue = null,Object? valueMgDl = freezed,Object? measuredAt = freezed,Object? targets = freezed,Object? classification = freezed,Object? fastingConfirmed = null,Object? mealContext = freezed,Object? hoursAfterMeal = freezed,Object? symptoms = null,Object? note = null,Object? errorMessage = freezed,Object? duplicateFasting = freezed,Object? savedReading = freezed,Object? editingId = freezed,}) {
  return _then(_ReadingFormState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ReadingType,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as GlucoseUnit,rawValue: null == rawValue ? _self.rawValue : rawValue // ignore: cast_nullable_to_non_nullable
as String,valueMgDl: freezed == valueMgDl ? _self.valueMgDl : valueMgDl // ignore: cast_nullable_to_non_nullable
as int?,measuredAt: freezed == measuredAt ? _self.measuredAt : measuredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,targets: freezed == targets ? _self.targets : targets // ignore: cast_nullable_to_non_nullable
as TargetSet?,classification: freezed == classification ? _self.classification : classification // ignore: cast_nullable_to_non_nullable
as Classification?,fastingConfirmed: null == fastingConfirmed ? _self.fastingConfirmed : fastingConfirmed // ignore: cast_nullable_to_non_nullable
as bool,mealContext: freezed == mealContext ? _self.mealContext : mealContext // ignore: cast_nullable_to_non_nullable
as MealContext?,hoursAfterMeal: freezed == hoursAfterMeal ? _self.hoursAfterMeal : hoursAfterMeal // ignore: cast_nullable_to_non_nullable
as double?,symptoms: null == symptoms ? _self._symptoms : symptoms // ignore: cast_nullable_to_non_nullable
as Set<Symptom>,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,duplicateFasting: freezed == duplicateFasting ? _self.duplicateFasting : duplicateFasting // ignore: cast_nullable_to_non_nullable
as DuplicateFastingFailure?,savedReading: freezed == savedReading ? _self.savedReading : savedReading // ignore: cast_nullable_to_non_nullable
as GlucoseReading?,editingId: freezed == editingId ? _self.editingId : editingId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of ReadingFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GlucoseReadingCopyWith<$Res>? get savedReading {
    if (_self.savedReading == null) {
    return null;
  }

  return $GlucoseReadingCopyWith<$Res>(_self.savedReading!, (value) {
    return _then(_self.copyWith(savedReading: value));
  });
}
}

// dart format on
