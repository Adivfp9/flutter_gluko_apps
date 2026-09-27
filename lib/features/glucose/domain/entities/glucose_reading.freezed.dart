// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'glucose_reading.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GlucoseReading {

 ReadingType get type; int get valueMgDl; DateTime get measuredAt; int get tzOffsetMinutes; GlucoseStatus get status; bool get isCritical; int? get id; MealContext? get mealContext; double? get hoursAfterMeal; List<Symptom> get symptoms; String? get note; String get source; DateTime? get createdAt; DateTime? get updatedAt; DateTime? get deletedAt;
/// Create a copy of GlucoseReading
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GlucoseReadingCopyWith<GlucoseReading> get copyWith => _$GlucoseReadingCopyWithImpl<GlucoseReading>(this as GlucoseReading, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GlucoseReading;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GlucoseReading&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.valueMgDl, _this.valueMgDl) || other.valueMgDl == _this.valueMgDl)&&(identical(other.measuredAt, _this.measuredAt) || other.measuredAt == _this.measuredAt)&&(identical(other.tzOffsetMinutes, _this.tzOffsetMinutes) || other.tzOffsetMinutes == _this.tzOffsetMinutes)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.isCritical, _this.isCritical) || other.isCritical == _this.isCritical)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.mealContext, _this.mealContext) || other.mealContext == _this.mealContext)&&(identical(other.hoursAfterMeal, _this.hoursAfterMeal) || other.hoursAfterMeal == _this.hoursAfterMeal)&&const DeepCollectionEquality().equals(other.symptoms, _this.symptoms)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt));
}


@override
int get hashCode {
  final _this = this as GlucoseReading;
  return Object.hash(runtimeType,_this.type,_this.valueMgDl,_this.measuredAt,_this.tzOffsetMinutes,_this.status,_this.isCritical,_this.id,_this.mealContext,_this.hoursAfterMeal,const DeepCollectionEquality().hash(_this.symptoms),_this.note,_this.source,_this.createdAt,_this.updatedAt,_this.deletedAt);
}

@override
String toString() {
  final _this = this as GlucoseReading;
  return 'GlucoseReading(type: ${_this.type}, valueMgDl: ${_this.valueMgDl}, measuredAt: ${_this.measuredAt}, tzOffsetMinutes: ${_this.tzOffsetMinutes}, status: ${_this.status}, isCritical: ${_this.isCritical}, id: ${_this.id}, mealContext: ${_this.mealContext}, hoursAfterMeal: ${_this.hoursAfterMeal}, symptoms: ${_this.symptoms}, note: ${_this.note}, source: ${_this.source}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, deletedAt: ${_this.deletedAt})';
}


}

/// @nodoc
abstract mixin class $GlucoseReadingCopyWith<$Res>  {
  factory $GlucoseReadingCopyWith(GlucoseReading value, $Res Function(GlucoseReading) _then) = _$GlucoseReadingCopyWithImpl;
@useResult
$Res call({
 ReadingType type, int valueMgDl, DateTime measuredAt, int tzOffsetMinutes, GlucoseStatus status, bool isCritical, int? id, MealContext? mealContext, double? hoursAfterMeal, List<Symptom> symptoms, String? note, String source, DateTime? createdAt, DateTime? updatedAt, DateTime? deletedAt
});




}
/// @nodoc
class _$GlucoseReadingCopyWithImpl<$Res>
    implements $GlucoseReadingCopyWith<$Res> {
  _$GlucoseReadingCopyWithImpl(this._self, this._then);

  final GlucoseReading _self;
  final $Res Function(GlucoseReading) _then;

/// Create a copy of GlucoseReading
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? valueMgDl = null,Object? measuredAt = null,Object? tzOffsetMinutes = null,Object? status = null,Object? isCritical = null,Object? id = freezed,Object? mealContext = freezed,Object? hoursAfterMeal = freezed,Object? symptoms = null,Object? note = freezed,Object? source = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? deletedAt = freezed,}) {
  return _then(GlucoseReading(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ReadingType,valueMgDl: null == valueMgDl ? _self.valueMgDl : valueMgDl // ignore: cast_nullable_to_non_nullable
as int,measuredAt: null == measuredAt ? _self.measuredAt : measuredAt // ignore: cast_nullable_to_non_nullable
as DateTime,tzOffsetMinutes: null == tzOffsetMinutes ? _self.tzOffsetMinutes : tzOffsetMinutes // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GlucoseStatus,isCritical: null == isCritical ? _self.isCritical : isCritical // ignore: cast_nullable_to_non_nullable
as bool,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,mealContext: freezed == mealContext ? _self.mealContext : mealContext // ignore: cast_nullable_to_non_nullable
as MealContext?,hoursAfterMeal: freezed == hoursAfterMeal ? _self.hoursAfterMeal : hoursAfterMeal // ignore: cast_nullable_to_non_nullable
as double?,symptoms: null == symptoms ? _self.symptoms : symptoms // ignore: cast_nullable_to_non_nullable
as List<Symptom>,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [GlucoseReading].
extension GlucoseReadingPatterns on GlucoseReading {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GlucoseReading value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GlucoseReading() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GlucoseReading value)  $default,){
final _that = this;
switch (_that) {
case _GlucoseReading():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GlucoseReading value)?  $default,){
final _that = this;
switch (_that) {
case _GlucoseReading() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ReadingType type,  int valueMgDl,  DateTime measuredAt,  int tzOffsetMinutes,  GlucoseStatus status,  bool isCritical,  int? id,  MealContext? mealContext,  double? hoursAfterMeal,  List<Symptom> symptoms,  String? note,  String source,  DateTime? createdAt,  DateTime? updatedAt,  DateTime? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GlucoseReading() when $default != null:
return $default(_that.type,_that.valueMgDl,_that.measuredAt,_that.tzOffsetMinutes,_that.status,_that.isCritical,_that.id,_that.mealContext,_that.hoursAfterMeal,_that.symptoms,_that.note,_that.source,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ReadingType type,  int valueMgDl,  DateTime measuredAt,  int tzOffsetMinutes,  GlucoseStatus status,  bool isCritical,  int? id,  MealContext? mealContext,  double? hoursAfterMeal,  List<Symptom> symptoms,  String? note,  String source,  DateTime? createdAt,  DateTime? updatedAt,  DateTime? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _GlucoseReading():
return $default(_that.type,_that.valueMgDl,_that.measuredAt,_that.tzOffsetMinutes,_that.status,_that.isCritical,_that.id,_that.mealContext,_that.hoursAfterMeal,_that.symptoms,_that.note,_that.source,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ReadingType type,  int valueMgDl,  DateTime measuredAt,  int tzOffsetMinutes,  GlucoseStatus status,  bool isCritical,  int? id,  MealContext? mealContext,  double? hoursAfterMeal,  List<Symptom> symptoms,  String? note,  String source,  DateTime? createdAt,  DateTime? updatedAt,  DateTime? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _GlucoseReading() when $default != null:
return $default(_that.type,_that.valueMgDl,_that.measuredAt,_that.tzOffsetMinutes,_that.status,_that.isCritical,_that.id,_that.mealContext,_that.hoursAfterMeal,_that.symptoms,_that.note,_that.source,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc


class _GlucoseReading extends GlucoseReading {
  const _GlucoseReading({required this.type, required this.valueMgDl, required this.measuredAt, required this.tzOffsetMinutes, required this.status, required this.isCritical, this.id, this.mealContext, this.hoursAfterMeal,  List<Symptom> symptoms = const <Symptom>[], this.note, this.source = 'manual', this.createdAt, this.updatedAt, this.deletedAt}): _symptoms = symptoms,super._();
  

@override final  ReadingType type;
@override final  int valueMgDl;
@override final  DateTime measuredAt;
@override final  int tzOffsetMinutes;
@override final  GlucoseStatus status;
@override final  bool isCritical;
@override final  int? id;
@override final  MealContext? mealContext;
@override final  double? hoursAfterMeal;
 final  List<Symptom> _symptoms;
@override@JsonKey() List<Symptom> get symptoms {
  if (_symptoms is EqualUnmodifiableListView) return _symptoms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_symptoms);
}

@override final  String? note;
@override@JsonKey() final  String source;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override final  DateTime? deletedAt;

/// Create a copy of GlucoseReading
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GlucoseReadingCopyWith<_GlucoseReading> get copyWith => __$GlucoseReadingCopyWithImpl<_GlucoseReading>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GlucoseReading&&(identical(other.type, type) || other.type == type)&&(identical(other.valueMgDl, valueMgDl) || other.valueMgDl == valueMgDl)&&(identical(other.measuredAt, measuredAt) || other.measuredAt == measuredAt)&&(identical(other.tzOffsetMinutes, tzOffsetMinutes) || other.tzOffsetMinutes == tzOffsetMinutes)&&(identical(other.status, status) || other.status == status)&&(identical(other.isCritical, isCritical) || other.isCritical == isCritical)&&(identical(other.id, id) || other.id == id)&&(identical(other.mealContext, mealContext) || other.mealContext == mealContext)&&(identical(other.hoursAfterMeal, hoursAfterMeal) || other.hoursAfterMeal == hoursAfterMeal)&&const DeepCollectionEquality().equals(other.symptoms, _symptoms)&&(identical(other.note, note) || other.note == note)&&(identical(other.source, source) || other.source == source)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,type,valueMgDl,measuredAt,tzOffsetMinutes,status,isCritical,id,mealContext,hoursAfterMeal,const DeepCollectionEquality().hash(_symptoms),note,source,createdAt,updatedAt,deletedAt);
}

@override
String toString() {
    return 'GlucoseReading(type: $type, valueMgDl: $valueMgDl, measuredAt: $measuredAt, tzOffsetMinutes: $tzOffsetMinutes, status: $status, isCritical: $isCritical, id: $id, mealContext: $mealContext, hoursAfterMeal: $hoursAfterMeal, symptoms: $symptoms, note: $note, source: $source, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$GlucoseReadingCopyWith<$Res> implements $GlucoseReadingCopyWith<$Res> {
  factory _$GlucoseReadingCopyWith(_GlucoseReading value, $Res Function(_GlucoseReading) _then) = __$GlucoseReadingCopyWithImpl;
@override @useResult
$Res call({
 ReadingType type, int valueMgDl, DateTime measuredAt, int tzOffsetMinutes, GlucoseStatus status, bool isCritical, int? id, MealContext? mealContext, double? hoursAfterMeal, List<Symptom> symptoms, String? note, String source, DateTime? createdAt, DateTime? updatedAt, DateTime? deletedAt
});




}
/// @nodoc
class __$GlucoseReadingCopyWithImpl<$Res>
    implements _$GlucoseReadingCopyWith<$Res> {
  __$GlucoseReadingCopyWithImpl(this._self, this._then);

  final _GlucoseReading _self;
  final $Res Function(_GlucoseReading) _then;

/// Create a copy of GlucoseReading
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? valueMgDl = null,Object? measuredAt = null,Object? tzOffsetMinutes = null,Object? status = null,Object? isCritical = null,Object? id = freezed,Object? mealContext = freezed,Object? hoursAfterMeal = freezed,Object? symptoms = null,Object? note = freezed,Object? source = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? deletedAt = freezed,}) {
  return _then(_GlucoseReading(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ReadingType,valueMgDl: null == valueMgDl ? _self.valueMgDl : valueMgDl // ignore: cast_nullable_to_non_nullable
as int,measuredAt: null == measuredAt ? _self.measuredAt : measuredAt // ignore: cast_nullable_to_non_nullable
as DateTime,tzOffsetMinutes: null == tzOffsetMinutes ? _self.tzOffsetMinutes : tzOffsetMinutes // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GlucoseStatus,isCritical: null == isCritical ? _self.isCritical : isCritical // ignore: cast_nullable_to_non_nullable
as bool,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,mealContext: freezed == mealContext ? _self.mealContext : mealContext // ignore: cast_nullable_to_non_nullable
as MealContext?,hoursAfterMeal: freezed == hoursAfterMeal ? _self.hoursAfterMeal : hoursAfterMeal // ignore: cast_nullable_to_non_nullable
as double?,symptoms: null == symptoms ? _self._symptoms : symptoms // ignore: cast_nullable_to_non_nullable
as List<Symptom>,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
