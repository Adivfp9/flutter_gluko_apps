// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingState {

 OnboardingStep get step; bool get disclaimerAccepted; GlucoseUnit get unit; DiabetesType get diabetesType; String get name; int? get birthYear;/// Default 06.00 (PRD F-07 AC1).
 int get fastingReminderMinutes; bool get fastingReminderEnabled; bool get isSubmitting; bool get isDone; String? get errorMessage;
/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingStateCopyWith<OnboardingState> get copyWith => _$OnboardingStateCopyWithImpl<OnboardingState>(this as OnboardingState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OnboardingState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingState&&(identical(other.step, _this.step) || other.step == _this.step)&&(identical(other.disclaimerAccepted, _this.disclaimerAccepted) || other.disclaimerAccepted == _this.disclaimerAccepted)&&(identical(other.unit, _this.unit) || other.unit == _this.unit)&&(identical(other.diabetesType, _this.diabetesType) || other.diabetesType == _this.diabetesType)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.birthYear, _this.birthYear) || other.birthYear == _this.birthYear)&&(identical(other.fastingReminderMinutes, _this.fastingReminderMinutes) || other.fastingReminderMinutes == _this.fastingReminderMinutes)&&(identical(other.fastingReminderEnabled, _this.fastingReminderEnabled) || other.fastingReminderEnabled == _this.fastingReminderEnabled)&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&(identical(other.isDone, _this.isDone) || other.isDone == _this.isDone)&&(identical(other.errorMessage, _this.errorMessage) || other.errorMessage == _this.errorMessage));
}


@override
int get hashCode {
  final _this = this as OnboardingState;
  return Object.hash(runtimeType,_this.step,_this.disclaimerAccepted,_this.unit,_this.diabetesType,_this.name,_this.birthYear,_this.fastingReminderMinutes,_this.fastingReminderEnabled,_this.isSubmitting,_this.isDone,_this.errorMessage);
}

@override
String toString() {
  final _this = this as OnboardingState;
  return 'OnboardingState(step: ${_this.step}, disclaimerAccepted: ${_this.disclaimerAccepted}, unit: ${_this.unit}, diabetesType: ${_this.diabetesType}, name: ${_this.name}, birthYear: ${_this.birthYear}, fastingReminderMinutes: ${_this.fastingReminderMinutes}, fastingReminderEnabled: ${_this.fastingReminderEnabled}, isSubmitting: ${_this.isSubmitting}, isDone: ${_this.isDone}, errorMessage: ${_this.errorMessage})';
}


}

/// @nodoc
abstract mixin class $OnboardingStateCopyWith<$Res>  {
  factory $OnboardingStateCopyWith(OnboardingState value, $Res Function(OnboardingState) _then) = _$OnboardingStateCopyWithImpl;
@useResult
$Res call({
 OnboardingStep step, bool disclaimerAccepted, GlucoseUnit unit, DiabetesType diabetesType, String name, int? birthYear, int fastingReminderMinutes, bool fastingReminderEnabled, bool isSubmitting, bool isDone, String? errorMessage
});




}
/// @nodoc
class _$OnboardingStateCopyWithImpl<$Res>
    implements $OnboardingStateCopyWith<$Res> {
  _$OnboardingStateCopyWithImpl(this._self, this._then);

  final OnboardingState _self;
  final $Res Function(OnboardingState) _then;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? step = null,Object? disclaimerAccepted = null,Object? unit = null,Object? diabetesType = null,Object? name = null,Object? birthYear = freezed,Object? fastingReminderMinutes = null,Object? fastingReminderEnabled = null,Object? isSubmitting = null,Object? isDone = null,Object? errorMessage = freezed,}) {
  return _then(OnboardingState(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as OnboardingStep,disclaimerAccepted: null == disclaimerAccepted ? _self.disclaimerAccepted : disclaimerAccepted // ignore: cast_nullable_to_non_nullable
as bool,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as GlucoseUnit,diabetesType: null == diabetesType ? _self.diabetesType : diabetesType // ignore: cast_nullable_to_non_nullable
as DiabetesType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,birthYear: freezed == birthYear ? _self.birthYear : birthYear // ignore: cast_nullable_to_non_nullable
as int?,fastingReminderMinutes: null == fastingReminderMinutes ? _self.fastingReminderMinutes : fastingReminderMinutes // ignore: cast_nullable_to_non_nullable
as int,fastingReminderEnabled: null == fastingReminderEnabled ? _self.fastingReminderEnabled : fastingReminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isDone: null == isDone ? _self.isDone : isDone // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingState].
extension OnboardingStatePatterns on OnboardingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingState value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingState value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( OnboardingStep step,  bool disclaimerAccepted,  GlucoseUnit unit,  DiabetesType diabetesType,  String name,  int? birthYear,  int fastingReminderMinutes,  bool fastingReminderEnabled,  bool isSubmitting,  bool isDone,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.step,_that.disclaimerAccepted,_that.unit,_that.diabetesType,_that.name,_that.birthYear,_that.fastingReminderMinutes,_that.fastingReminderEnabled,_that.isSubmitting,_that.isDone,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( OnboardingStep step,  bool disclaimerAccepted,  GlucoseUnit unit,  DiabetesType diabetesType,  String name,  int? birthYear,  int fastingReminderMinutes,  bool fastingReminderEnabled,  bool isSubmitting,  bool isDone,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _OnboardingState():
return $default(_that.step,_that.disclaimerAccepted,_that.unit,_that.diabetesType,_that.name,_that.birthYear,_that.fastingReminderMinutes,_that.fastingReminderEnabled,_that.isSubmitting,_that.isDone,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( OnboardingStep step,  bool disclaimerAccepted,  GlucoseUnit unit,  DiabetesType diabetesType,  String name,  int? birthYear,  int fastingReminderMinutes,  bool fastingReminderEnabled,  bool isSubmitting,  bool isDone,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.step,_that.disclaimerAccepted,_that.unit,_that.diabetesType,_that.name,_that.birthYear,_that.fastingReminderMinutes,_that.fastingReminderEnabled,_that.isSubmitting,_that.isDone,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingState extends OnboardingState {
  const _OnboardingState({this.step = OnboardingStep.welcome, this.disclaimerAccepted = false, this.unit = GlucoseUnit.mgDl, this.diabetesType = DiabetesType.unknown, this.name = '', this.birthYear, this.fastingReminderMinutes = 6 * 60, this.fastingReminderEnabled = true, this.isSubmitting = false, this.isDone = false, this.errorMessage}): super._();
  

@override@JsonKey() final  OnboardingStep step;
@override@JsonKey() final  bool disclaimerAccepted;
@override@JsonKey() final  GlucoseUnit unit;
@override@JsonKey() final  DiabetesType diabetesType;
@override@JsonKey() final  String name;
@override final  int? birthYear;
/// Default 06.00 (PRD F-07 AC1).
@override@JsonKey() final  int fastingReminderMinutes;
@override@JsonKey() final  bool fastingReminderEnabled;
@override@JsonKey() final  bool isSubmitting;
@override@JsonKey() final  bool isDone;
@override final  String? errorMessage;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingStateCopyWith<_OnboardingState> get copyWith => __$OnboardingStateCopyWithImpl<_OnboardingState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingState&&(identical(other.step, step) || other.step == step)&&(identical(other.disclaimerAccepted, disclaimerAccepted) || other.disclaimerAccepted == disclaimerAccepted)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.diabetesType, diabetesType) || other.diabetesType == diabetesType)&&(identical(other.name, name) || other.name == name)&&(identical(other.birthYear, birthYear) || other.birthYear == birthYear)&&(identical(other.fastingReminderMinutes, fastingReminderMinutes) || other.fastingReminderMinutes == fastingReminderMinutes)&&(identical(other.fastingReminderEnabled, fastingReminderEnabled) || other.fastingReminderEnabled == fastingReminderEnabled)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.isDone, isDone) || other.isDone == isDone)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,step,disclaimerAccepted,unit,diabetesType,name,birthYear,fastingReminderMinutes,fastingReminderEnabled,isSubmitting,isDone,errorMessage);
}

@override
String toString() {
    return 'OnboardingState(step: $step, disclaimerAccepted: $disclaimerAccepted, unit: $unit, diabetesType: $diabetesType, name: $name, birthYear: $birthYear, fastingReminderMinutes: $fastingReminderMinutes, fastingReminderEnabled: $fastingReminderEnabled, isSubmitting: $isSubmitting, isDone: $isDone, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$OnboardingStateCopyWith<$Res> implements $OnboardingStateCopyWith<$Res> {
  factory _$OnboardingStateCopyWith(_OnboardingState value, $Res Function(_OnboardingState) _then) = __$OnboardingStateCopyWithImpl;
@override @useResult
$Res call({
 OnboardingStep step, bool disclaimerAccepted, GlucoseUnit unit, DiabetesType diabetesType, String name, int? birthYear, int fastingReminderMinutes, bool fastingReminderEnabled, bool isSubmitting, bool isDone, String? errorMessage
});




}
/// @nodoc
class __$OnboardingStateCopyWithImpl<$Res>
    implements _$OnboardingStateCopyWith<$Res> {
  __$OnboardingStateCopyWithImpl(this._self, this._then);

  final _OnboardingState _self;
  final $Res Function(_OnboardingState) _then;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? step = null,Object? disclaimerAccepted = null,Object? unit = null,Object? diabetesType = null,Object? name = null,Object? birthYear = freezed,Object? fastingReminderMinutes = null,Object? fastingReminderEnabled = null,Object? isSubmitting = null,Object? isDone = null,Object? errorMessage = freezed,}) {
  return _then(_OnboardingState(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as OnboardingStep,disclaimerAccepted: null == disclaimerAccepted ? _self.disclaimerAccepted : disclaimerAccepted // ignore: cast_nullable_to_non_nullable
as bool,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as GlucoseUnit,diabetesType: null == diabetesType ? _self.diabetesType : diabetesType // ignore: cast_nullable_to_non_nullable
as DiabetesType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,birthYear: freezed == birthYear ? _self.birthYear : birthYear // ignore: cast_nullable_to_non_nullable
as int?,fastingReminderMinutes: null == fastingReminderMinutes ? _self.fastingReminderMinutes : fastingReminderMinutes // ignore: cast_nullable_to_non_nullable
as int,fastingReminderEnabled: null == fastingReminderEnabled ? _self.fastingReminderEnabled : fastingReminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isDone: null == isDone ? _self.isDone : isDone // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
