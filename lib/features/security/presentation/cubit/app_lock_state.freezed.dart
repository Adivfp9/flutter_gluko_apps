// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_lock_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppLockState {

 LockStatus get status; bool get lockEnabled; bool get biometricEnabled;/// Biometrik aktif di setelan **dan** tersedia di perangkat saat ini.
 bool get canUseBiometric; bool get isVerifying; int get failedAttempts; DateTime? get lockedUntil; String? get errorMessage;/// Sekali pakai: data baru saja dihapus lewat "Lupa PIN".
 bool get resetDone;
/// Create a copy of AppLockState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppLockStateCopyWith<AppLockState> get copyWith => _$AppLockStateCopyWithImpl<AppLockState>(this as AppLockState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AppLockState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppLockState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.lockEnabled, _this.lockEnabled) || other.lockEnabled == _this.lockEnabled)&&(identical(other.biometricEnabled, _this.biometricEnabled) || other.biometricEnabled == _this.biometricEnabled)&&(identical(other.canUseBiometric, _this.canUseBiometric) || other.canUseBiometric == _this.canUseBiometric)&&(identical(other.isVerifying, _this.isVerifying) || other.isVerifying == _this.isVerifying)&&(identical(other.failedAttempts, _this.failedAttempts) || other.failedAttempts == _this.failedAttempts)&&(identical(other.lockedUntil, _this.lockedUntil) || other.lockedUntil == _this.lockedUntil)&&(identical(other.errorMessage, _this.errorMessage) || other.errorMessage == _this.errorMessage)&&(identical(other.resetDone, _this.resetDone) || other.resetDone == _this.resetDone));
}


@override
int get hashCode {
  final _this = this as AppLockState;
  return Object.hash(runtimeType,_this.status,_this.lockEnabled,_this.biometricEnabled,_this.canUseBiometric,_this.isVerifying,_this.failedAttempts,_this.lockedUntil,_this.errorMessage,_this.resetDone);
}

@override
String toString() {
  final _this = this as AppLockState;
  return 'AppLockState(status: ${_this.status}, lockEnabled: ${_this.lockEnabled}, biometricEnabled: ${_this.biometricEnabled}, canUseBiometric: ${_this.canUseBiometric}, isVerifying: ${_this.isVerifying}, failedAttempts: ${_this.failedAttempts}, lockedUntil: ${_this.lockedUntil}, errorMessage: ${_this.errorMessage}, resetDone: ${_this.resetDone})';
}


}

/// @nodoc
abstract mixin class $AppLockStateCopyWith<$Res>  {
  factory $AppLockStateCopyWith(AppLockState value, $Res Function(AppLockState) _then) = _$AppLockStateCopyWithImpl;
@useResult
$Res call({
 LockStatus status, bool lockEnabled, bool biometricEnabled, bool canUseBiometric, bool isVerifying, int failedAttempts, DateTime? lockedUntil, String? errorMessage, bool resetDone
});




}
/// @nodoc
class _$AppLockStateCopyWithImpl<$Res>
    implements $AppLockStateCopyWith<$Res> {
  _$AppLockStateCopyWithImpl(this._self, this._then);

  final AppLockState _self;
  final $Res Function(AppLockState) _then;

/// Create a copy of AppLockState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? lockEnabled = null,Object? biometricEnabled = null,Object? canUseBiometric = null,Object? isVerifying = null,Object? failedAttempts = null,Object? lockedUntil = freezed,Object? errorMessage = freezed,Object? resetDone = null,}) {
  return _then(AppLockState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LockStatus,lockEnabled: null == lockEnabled ? _self.lockEnabled : lockEnabled // ignore: cast_nullable_to_non_nullable
as bool,biometricEnabled: null == biometricEnabled ? _self.biometricEnabled : biometricEnabled // ignore: cast_nullable_to_non_nullable
as bool,canUseBiometric: null == canUseBiometric ? _self.canUseBiometric : canUseBiometric // ignore: cast_nullable_to_non_nullable
as bool,isVerifying: null == isVerifying ? _self.isVerifying : isVerifying // ignore: cast_nullable_to_non_nullable
as bool,failedAttempts: null == failedAttempts ? _self.failedAttempts : failedAttempts // ignore: cast_nullable_to_non_nullable
as int,lockedUntil: freezed == lockedUntil ? _self.lockedUntil : lockedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,resetDone: null == resetDone ? _self.resetDone : resetDone // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AppLockState].
extension AppLockStatePatterns on AppLockState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppLockState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppLockState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppLockState value)  $default,){
final _that = this;
switch (_that) {
case _AppLockState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppLockState value)?  $default,){
final _that = this;
switch (_that) {
case _AppLockState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LockStatus status,  bool lockEnabled,  bool biometricEnabled,  bool canUseBiometric,  bool isVerifying,  int failedAttempts,  DateTime? lockedUntil,  String? errorMessage,  bool resetDone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppLockState() when $default != null:
return $default(_that.status,_that.lockEnabled,_that.biometricEnabled,_that.canUseBiometric,_that.isVerifying,_that.failedAttempts,_that.lockedUntil,_that.errorMessage,_that.resetDone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LockStatus status,  bool lockEnabled,  bool biometricEnabled,  bool canUseBiometric,  bool isVerifying,  int failedAttempts,  DateTime? lockedUntil,  String? errorMessage,  bool resetDone)  $default,) {final _that = this;
switch (_that) {
case _AppLockState():
return $default(_that.status,_that.lockEnabled,_that.biometricEnabled,_that.canUseBiometric,_that.isVerifying,_that.failedAttempts,_that.lockedUntil,_that.errorMessage,_that.resetDone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LockStatus status,  bool lockEnabled,  bool biometricEnabled,  bool canUseBiometric,  bool isVerifying,  int failedAttempts,  DateTime? lockedUntil,  String? errorMessage,  bool resetDone)?  $default,) {final _that = this;
switch (_that) {
case _AppLockState() when $default != null:
return $default(_that.status,_that.lockEnabled,_that.biometricEnabled,_that.canUseBiometric,_that.isVerifying,_that.failedAttempts,_that.lockedUntil,_that.errorMessage,_that.resetDone);case _:
  return null;

}
}

}

/// @nodoc


class _AppLockState extends AppLockState {
  const _AppLockState({this.status = LockStatus.checking, this.lockEnabled = false, this.biometricEnabled = false, this.canUseBiometric = false, this.isVerifying = false, this.failedAttempts = 0, this.lockedUntil, this.errorMessage, this.resetDone = false}): super._();
  

@override@JsonKey() final  LockStatus status;
@override@JsonKey() final  bool lockEnabled;
@override@JsonKey() final  bool biometricEnabled;
/// Biometrik aktif di setelan **dan** tersedia di perangkat saat ini.
@override@JsonKey() final  bool canUseBiometric;
@override@JsonKey() final  bool isVerifying;
@override@JsonKey() final  int failedAttempts;
@override final  DateTime? lockedUntil;
@override final  String? errorMessage;
/// Sekali pakai: data baru saja dihapus lewat "Lupa PIN".
@override@JsonKey() final  bool resetDone;

/// Create a copy of AppLockState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppLockStateCopyWith<_AppLockState> get copyWith => __$AppLockStateCopyWithImpl<_AppLockState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppLockState&&(identical(other.status, status) || other.status == status)&&(identical(other.lockEnabled, lockEnabled) || other.lockEnabled == lockEnabled)&&(identical(other.biometricEnabled, biometricEnabled) || other.biometricEnabled == biometricEnabled)&&(identical(other.canUseBiometric, canUseBiometric) || other.canUseBiometric == canUseBiometric)&&(identical(other.isVerifying, isVerifying) || other.isVerifying == isVerifying)&&(identical(other.failedAttempts, failedAttempts) || other.failedAttempts == failedAttempts)&&(identical(other.lockedUntil, lockedUntil) || other.lockedUntil == lockedUntil)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.resetDone, resetDone) || other.resetDone == resetDone));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,lockEnabled,biometricEnabled,canUseBiometric,isVerifying,failedAttempts,lockedUntil,errorMessage,resetDone);
}

@override
String toString() {
    return 'AppLockState(status: $status, lockEnabled: $lockEnabled, biometricEnabled: $biometricEnabled, canUseBiometric: $canUseBiometric, isVerifying: $isVerifying, failedAttempts: $failedAttempts, lockedUntil: $lockedUntil, errorMessage: $errorMessage, resetDone: $resetDone)';
}


}

/// @nodoc
abstract mixin class _$AppLockStateCopyWith<$Res> implements $AppLockStateCopyWith<$Res> {
  factory _$AppLockStateCopyWith(_AppLockState value, $Res Function(_AppLockState) _then) = __$AppLockStateCopyWithImpl;
@override @useResult
$Res call({
 LockStatus status, bool lockEnabled, bool biometricEnabled, bool canUseBiometric, bool isVerifying, int failedAttempts, DateTime? lockedUntil, String? errorMessage, bool resetDone
});




}
/// @nodoc
class __$AppLockStateCopyWithImpl<$Res>
    implements _$AppLockStateCopyWith<$Res> {
  __$AppLockStateCopyWithImpl(this._self, this._then);

  final _AppLockState _self;
  final $Res Function(_AppLockState) _then;

/// Create a copy of AppLockState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? lockEnabled = null,Object? biometricEnabled = null,Object? canUseBiometric = null,Object? isVerifying = null,Object? failedAttempts = null,Object? lockedUntil = freezed,Object? errorMessage = freezed,Object? resetDone = null,}) {
  return _then(_AppLockState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LockStatus,lockEnabled: null == lockEnabled ? _self.lockEnabled : lockEnabled // ignore: cast_nullable_to_non_nullable
as bool,biometricEnabled: null == biometricEnabled ? _self.biometricEnabled : biometricEnabled // ignore: cast_nullable_to_non_nullable
as bool,canUseBiometric: null == canUseBiometric ? _self.canUseBiometric : canUseBiometric // ignore: cast_nullable_to_non_nullable
as bool,isVerifying: null == isVerifying ? _self.isVerifying : isVerifying // ignore: cast_nullable_to_non_nullable
as bool,failedAttempts: null == failedAttempts ? _self.failedAttempts : failedAttempts // ignore: cast_nullable_to_non_nullable
as int,lockedUntil: freezed == lockedUntil ? _self.lockedUntil : lockedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,resetDone: null == resetDone ? _self.resetDone : resetDone // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
