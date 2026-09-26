// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'target_settings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TargetSettingsState {

 bool get isLoading; bool get isSaving; bool get isReclassifying; TargetSet? get targets; UserProfile? get profile; GlucoseUnit get unit; Map<String, String> get thresholdInputs; TargetPreset get basePreset; bool get hasUnsavedChanges; bool get saved; String? get errorMessage; String? get infoMessage;
/// Create a copy of TargetSettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TargetSettingsStateCopyWith<TargetSettingsState> get copyWith => _$TargetSettingsStateCopyWithImpl<TargetSettingsState>(this as TargetSettingsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TargetSettingsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TargetSettingsState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isSaving, _this.isSaving) || other.isSaving == _this.isSaving)&&(identical(other.isReclassifying, _this.isReclassifying) || other.isReclassifying == _this.isReclassifying)&&(identical(other.targets, _this.targets) || other.targets == _this.targets)&&(identical(other.profile, _this.profile) || other.profile == _this.profile)&&(identical(other.unit, _this.unit) || other.unit == _this.unit)&&const DeepCollectionEquality().equals(other.thresholdInputs, _this.thresholdInputs)&&(identical(other.basePreset, _this.basePreset) || other.basePreset == _this.basePreset)&&(identical(other.hasUnsavedChanges, _this.hasUnsavedChanges) || other.hasUnsavedChanges == _this.hasUnsavedChanges)&&(identical(other.saved, _this.saved) || other.saved == _this.saved)&&(identical(other.errorMessage, _this.errorMessage) || other.errorMessage == _this.errorMessage)&&(identical(other.infoMessage, _this.infoMessage) || other.infoMessage == _this.infoMessage));
}


@override
int get hashCode {
  final _this = this as TargetSettingsState;
  return Object.hash(runtimeType,_this.isLoading,_this.isSaving,_this.isReclassifying,_this.targets,_this.profile,_this.unit,const DeepCollectionEquality().hash(_this.thresholdInputs),_this.basePreset,_this.hasUnsavedChanges,_this.saved,_this.errorMessage,_this.infoMessage);
}

@override
String toString() {
  final _this = this as TargetSettingsState;
  return 'TargetSettingsState(isLoading: ${_this.isLoading}, isSaving: ${_this.isSaving}, isReclassifying: ${_this.isReclassifying}, targets: ${_this.targets}, profile: ${_this.profile}, unit: ${_this.unit}, thresholdInputs: ${_this.thresholdInputs}, basePreset: ${_this.basePreset}, hasUnsavedChanges: ${_this.hasUnsavedChanges}, saved: ${_this.saved}, errorMessage: ${_this.errorMessage}, infoMessage: ${_this.infoMessage})';
}


}

/// @nodoc
abstract mixin class $TargetSettingsStateCopyWith<$Res>  {
  factory $TargetSettingsStateCopyWith(TargetSettingsState value, $Res Function(TargetSettingsState) _then) = _$TargetSettingsStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isSaving, bool isReclassifying, TargetSet? targets, UserProfile? profile, GlucoseUnit unit, Map<String, String> thresholdInputs, TargetPreset basePreset, bool hasUnsavedChanges, bool saved, String? errorMessage, String? infoMessage
});


$UserProfileCopyWith<$Res>? get profile;

}
/// @nodoc
class _$TargetSettingsStateCopyWithImpl<$Res>
    implements $TargetSettingsStateCopyWith<$Res> {
  _$TargetSettingsStateCopyWithImpl(this._self, this._then);

  final TargetSettingsState _self;
  final $Res Function(TargetSettingsState) _then;

/// Create a copy of TargetSettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isSaving = null,Object? isReclassifying = null,Object? targets = freezed,Object? profile = freezed,Object? unit = null,Object? thresholdInputs = null,Object? basePreset = null,Object? hasUnsavedChanges = null,Object? saved = null,Object? errorMessage = freezed,Object? infoMessage = freezed,}) {
  return _then(TargetSettingsState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,isReclassifying: null == isReclassifying ? _self.isReclassifying : isReclassifying // ignore: cast_nullable_to_non_nullable
as bool,targets: freezed == targets ? _self.targets : targets // ignore: cast_nullable_to_non_nullable
as TargetSet?,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as UserProfile?,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as GlucoseUnit,thresholdInputs: null == thresholdInputs ? _self.thresholdInputs : thresholdInputs // ignore: cast_nullable_to_non_nullable
as Map<String, String>,basePreset: null == basePreset ? _self.basePreset : basePreset // ignore: cast_nullable_to_non_nullable
as TargetPreset,hasUnsavedChanges: null == hasUnsavedChanges ? _self.hasUnsavedChanges : hasUnsavedChanges // ignore: cast_nullable_to_non_nullable
as bool,saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,infoMessage: freezed == infoMessage ? _self.infoMessage : infoMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of TargetSettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserProfileCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $UserProfileCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// Adds pattern-matching-related methods to [TargetSettingsState].
extension TargetSettingsStatePatterns on TargetSettingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TargetSettingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TargetSettingsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TargetSettingsState value)  $default,){
final _that = this;
switch (_that) {
case _TargetSettingsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TargetSettingsState value)?  $default,){
final _that = this;
switch (_that) {
case _TargetSettingsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isSaving,  bool isReclassifying,  TargetSet? targets,  UserProfile? profile,  GlucoseUnit unit,  Map<String, String> thresholdInputs,  TargetPreset basePreset,  bool hasUnsavedChanges,  bool saved,  String? errorMessage,  String? infoMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TargetSettingsState() when $default != null:
return $default(_that.isLoading,_that.isSaving,_that.isReclassifying,_that.targets,_that.profile,_that.unit,_that.thresholdInputs,_that.basePreset,_that.hasUnsavedChanges,_that.saved,_that.errorMessage,_that.infoMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isSaving,  bool isReclassifying,  TargetSet? targets,  UserProfile? profile,  GlucoseUnit unit,  Map<String, String> thresholdInputs,  TargetPreset basePreset,  bool hasUnsavedChanges,  bool saved,  String? errorMessage,  String? infoMessage)  $default,) {final _that = this;
switch (_that) {
case _TargetSettingsState():
return $default(_that.isLoading,_that.isSaving,_that.isReclassifying,_that.targets,_that.profile,_that.unit,_that.thresholdInputs,_that.basePreset,_that.hasUnsavedChanges,_that.saved,_that.errorMessage,_that.infoMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isSaving,  bool isReclassifying,  TargetSet? targets,  UserProfile? profile,  GlucoseUnit unit,  Map<String, String> thresholdInputs,  TargetPreset basePreset,  bool hasUnsavedChanges,  bool saved,  String? errorMessage,  String? infoMessage)?  $default,) {final _that = this;
switch (_that) {
case _TargetSettingsState() when $default != null:
return $default(_that.isLoading,_that.isSaving,_that.isReclassifying,_that.targets,_that.profile,_that.unit,_that.thresholdInputs,_that.basePreset,_that.hasUnsavedChanges,_that.saved,_that.errorMessage,_that.infoMessage);case _:
  return null;

}
}

}

/// @nodoc


class _TargetSettingsState extends TargetSettingsState {
  const _TargetSettingsState({this.isLoading = false, this.isSaving = false, this.isReclassifying = false, this.targets, this.profile, this.unit = GlucoseUnit.mgDl,  Map<String, String> thresholdInputs = const <String, String>{}, this.basePreset = TargetPreset.general, this.hasUnsavedChanges = false, this.saved = false, this.errorMessage, this.infoMessage}): _thresholdInputs = thresholdInputs,super._();
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isSaving;
@override@JsonKey() final  bool isReclassifying;
@override final  TargetSet? targets;
@override final  UserProfile? profile;
@override@JsonKey() final  GlucoseUnit unit;
 final  Map<String, String> _thresholdInputs;
@override@JsonKey() Map<String, String> get thresholdInputs {
  if (_thresholdInputs is EqualUnmodifiableMapView) return _thresholdInputs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_thresholdInputs);
}

@override@JsonKey() final  TargetPreset basePreset;
@override@JsonKey() final  bool hasUnsavedChanges;
@override@JsonKey() final  bool saved;
@override final  String? errorMessage;
@override final  String? infoMessage;

/// Create a copy of TargetSettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TargetSettingsStateCopyWith<_TargetSettingsState> get copyWith => __$TargetSettingsStateCopyWithImpl<_TargetSettingsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TargetSettingsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.isReclassifying, isReclassifying) || other.isReclassifying == isReclassifying)&&(identical(other.targets, targets) || other.targets == targets)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.unit, unit) || other.unit == unit)&&const DeepCollectionEquality().equals(other.thresholdInputs, _thresholdInputs)&&(identical(other.basePreset, basePreset) || other.basePreset == basePreset)&&(identical(other.hasUnsavedChanges, hasUnsavedChanges) || other.hasUnsavedChanges == hasUnsavedChanges)&&(identical(other.saved, saved) || other.saved == saved)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.infoMessage, infoMessage) || other.infoMessage == infoMessage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,isSaving,isReclassifying,targets,profile,unit,const DeepCollectionEquality().hash(_thresholdInputs),basePreset,hasUnsavedChanges,saved,errorMessage,infoMessage);
}

@override
String toString() {
    return 'TargetSettingsState(isLoading: $isLoading, isSaving: $isSaving, isReclassifying: $isReclassifying, targets: $targets, profile: $profile, unit: $unit, thresholdInputs: $thresholdInputs, basePreset: $basePreset, hasUnsavedChanges: $hasUnsavedChanges, saved: $saved, errorMessage: $errorMessage, infoMessage: $infoMessage)';
}


}

/// @nodoc
abstract mixin class _$TargetSettingsStateCopyWith<$Res> implements $TargetSettingsStateCopyWith<$Res> {
  factory _$TargetSettingsStateCopyWith(_TargetSettingsState value, $Res Function(_TargetSettingsState) _then) = __$TargetSettingsStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isSaving, bool isReclassifying, TargetSet? targets, UserProfile? profile, GlucoseUnit unit, Map<String, String> thresholdInputs, TargetPreset basePreset, bool hasUnsavedChanges, bool saved, String? errorMessage, String? infoMessage
});


@override $UserProfileCopyWith<$Res>? get profile;

}
/// @nodoc
class __$TargetSettingsStateCopyWithImpl<$Res>
    implements _$TargetSettingsStateCopyWith<$Res> {
  __$TargetSettingsStateCopyWithImpl(this._self, this._then);

  final _TargetSettingsState _self;
  final $Res Function(_TargetSettingsState) _then;

/// Create a copy of TargetSettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isSaving = null,Object? isReclassifying = null,Object? targets = freezed,Object? profile = freezed,Object? unit = null,Object? thresholdInputs = null,Object? basePreset = null,Object? hasUnsavedChanges = null,Object? saved = null,Object? errorMessage = freezed,Object? infoMessage = freezed,}) {
  return _then(_TargetSettingsState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,isReclassifying: null == isReclassifying ? _self.isReclassifying : isReclassifying // ignore: cast_nullable_to_non_nullable
as bool,targets: freezed == targets ? _self.targets : targets // ignore: cast_nullable_to_non_nullable
as TargetSet?,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as UserProfile?,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as GlucoseUnit,thresholdInputs: null == thresholdInputs ? _self._thresholdInputs : thresholdInputs // ignore: cast_nullable_to_non_nullable
as Map<String, String>,basePreset: null == basePreset ? _self.basePreset : basePreset // ignore: cast_nullable_to_non_nullable
as TargetPreset,hasUnsavedChanges: null == hasUnsavedChanges ? _self.hasUnsavedChanges : hasUnsavedChanges // ignore: cast_nullable_to_non_nullable
as bool,saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,infoMessage: freezed == infoMessage ? _self.infoMessage : infoMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of TargetSettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserProfileCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $UserProfileCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}

// dart format on
