// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminders_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RemindersState {

 bool get isLoading; List<Reminder> get reminders; NotificationPermissionStatus? get permission; String? get errorMessage; String? get infoMessage;
/// Create a copy of RemindersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemindersStateCopyWith<RemindersState> get copyWith => _$RemindersStateCopyWithImpl<RemindersState>(this as RemindersState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RemindersState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemindersState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&const DeepCollectionEquality().equals(other.reminders, _this.reminders)&&(identical(other.permission, _this.permission) || other.permission == _this.permission)&&(identical(other.errorMessage, _this.errorMessage) || other.errorMessage == _this.errorMessage)&&(identical(other.infoMessage, _this.infoMessage) || other.infoMessage == _this.infoMessage));
}


@override
int get hashCode {
  final _this = this as RemindersState;
  return Object.hash(runtimeType,_this.isLoading,const DeepCollectionEquality().hash(_this.reminders),_this.permission,_this.errorMessage,_this.infoMessage);
}

@override
String toString() {
  final _this = this as RemindersState;
  return 'RemindersState(isLoading: ${_this.isLoading}, reminders: ${_this.reminders}, permission: ${_this.permission}, errorMessage: ${_this.errorMessage}, infoMessage: ${_this.infoMessage})';
}


}

/// @nodoc
abstract mixin class $RemindersStateCopyWith<$Res>  {
  factory $RemindersStateCopyWith(RemindersState value, $Res Function(RemindersState) _then) = _$RemindersStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, List<Reminder> reminders, NotificationPermissionStatus? permission, String? errorMessage, String? infoMessage
});




}
/// @nodoc
class _$RemindersStateCopyWithImpl<$Res>
    implements $RemindersStateCopyWith<$Res> {
  _$RemindersStateCopyWithImpl(this._self, this._then);

  final RemindersState _self;
  final $Res Function(RemindersState) _then;

/// Create a copy of RemindersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? reminders = null,Object? permission = freezed,Object? errorMessage = freezed,Object? infoMessage = freezed,}) {
  return _then(RemindersState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,reminders: null == reminders ? _self.reminders : reminders // ignore: cast_nullable_to_non_nullable
as List<Reminder>,permission: freezed == permission ? _self.permission : permission // ignore: cast_nullable_to_non_nullable
as NotificationPermissionStatus?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,infoMessage: freezed == infoMessage ? _self.infoMessage : infoMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RemindersState].
extension RemindersStatePatterns on RemindersState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RemindersState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RemindersState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RemindersState value)  $default,){
final _that = this;
switch (_that) {
case _RemindersState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RemindersState value)?  $default,){
final _that = this;
switch (_that) {
case _RemindersState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  List<Reminder> reminders,  NotificationPermissionStatus? permission,  String? errorMessage,  String? infoMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RemindersState() when $default != null:
return $default(_that.isLoading,_that.reminders,_that.permission,_that.errorMessage,_that.infoMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  List<Reminder> reminders,  NotificationPermissionStatus? permission,  String? errorMessage,  String? infoMessage)  $default,) {final _that = this;
switch (_that) {
case _RemindersState():
return $default(_that.isLoading,_that.reminders,_that.permission,_that.errorMessage,_that.infoMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  List<Reminder> reminders,  NotificationPermissionStatus? permission,  String? errorMessage,  String? infoMessage)?  $default,) {final _that = this;
switch (_that) {
case _RemindersState() when $default != null:
return $default(_that.isLoading,_that.reminders,_that.permission,_that.errorMessage,_that.infoMessage);case _:
  return null;

}
}

}

/// @nodoc


class _RemindersState extends RemindersState {
  const _RemindersState({this.isLoading = true,  List<Reminder> reminders = const <Reminder>[], this.permission, this.errorMessage, this.infoMessage}): _reminders = reminders,super._();
  

@override@JsonKey() final  bool isLoading;
 final  List<Reminder> _reminders;
@override@JsonKey() List<Reminder> get reminders {
  if (_reminders is EqualUnmodifiableListView) return _reminders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reminders);
}

@override final  NotificationPermissionStatus? permission;
@override final  String? errorMessage;
@override final  String? infoMessage;

/// Create a copy of RemindersState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemindersStateCopyWith<_RemindersState> get copyWith => __$RemindersStateCopyWithImpl<_RemindersState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemindersState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.reminders, _reminders)&&(identical(other.permission, permission) || other.permission == permission)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.infoMessage, infoMessage) || other.infoMessage == infoMessage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_reminders),permission,errorMessage,infoMessage);
}

@override
String toString() {
    return 'RemindersState(isLoading: $isLoading, reminders: $reminders, permission: $permission, errorMessage: $errorMessage, infoMessage: $infoMessage)';
}


}

/// @nodoc
abstract mixin class _$RemindersStateCopyWith<$Res> implements $RemindersStateCopyWith<$Res> {
  factory _$RemindersStateCopyWith(_RemindersState value, $Res Function(_RemindersState) _then) = __$RemindersStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<Reminder> reminders, NotificationPermissionStatus? permission, String? errorMessage, String? infoMessage
});




}
/// @nodoc
class __$RemindersStateCopyWithImpl<$Res>
    implements _$RemindersStateCopyWith<$Res> {
  __$RemindersStateCopyWithImpl(this._self, this._then);

  final _RemindersState _self;
  final $Res Function(_RemindersState) _then;

/// Create a copy of RemindersState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? reminders = null,Object? permission = freezed,Object? errorMessage = freezed,Object? infoMessage = freezed,}) {
  return _then(_RemindersState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,reminders: null == reminders ? _self._reminders : reminders // ignore: cast_nullable_to_non_nullable
as List<Reminder>,permission: freezed == permission ? _self.permission : permission // ignore: cast_nullable_to_non_nullable
as NotificationPermissionStatus?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,infoMessage: freezed == infoMessage ? _self.infoMessage : infoMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
