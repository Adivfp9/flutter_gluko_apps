// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BackupState {

 DateTime? get lastBackupAt;/// Teks proses yang sedang berjalan, mis. "Mengenkripsi…"; `null` = diam.
 String? get busyLabel;/// File sudah dipilih, menunggu passphrase.
 bool get hasPendingFile;/// Backup berhasil dibuka, menunggu konfirmasi timpa.
 BackupPreview? get preview; String? get errorMessage; String? get infoMessage;/// Sekali pakai: restore baru saja selesai.
 bool get restored;
/// Create a copy of BackupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupStateCopyWith<BackupState> get copyWith => _$BackupStateCopyWithImpl<BackupState>(this as BackupState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BackupState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupState&&(identical(other.lastBackupAt, _this.lastBackupAt) || other.lastBackupAt == _this.lastBackupAt)&&(identical(other.busyLabel, _this.busyLabel) || other.busyLabel == _this.busyLabel)&&(identical(other.hasPendingFile, _this.hasPendingFile) || other.hasPendingFile == _this.hasPendingFile)&&(identical(other.preview, _this.preview) || other.preview == _this.preview)&&(identical(other.errorMessage, _this.errorMessage) || other.errorMessage == _this.errorMessage)&&(identical(other.infoMessage, _this.infoMessage) || other.infoMessage == _this.infoMessage)&&(identical(other.restored, _this.restored) || other.restored == _this.restored));
}


@override
int get hashCode {
  final _this = this as BackupState;
  return Object.hash(runtimeType,_this.lastBackupAt,_this.busyLabel,_this.hasPendingFile,_this.preview,_this.errorMessage,_this.infoMessage,_this.restored);
}

@override
String toString() {
  final _this = this as BackupState;
  return 'BackupState(lastBackupAt: ${_this.lastBackupAt}, busyLabel: ${_this.busyLabel}, hasPendingFile: ${_this.hasPendingFile}, preview: ${_this.preview}, errorMessage: ${_this.errorMessage}, infoMessage: ${_this.infoMessage}, restored: ${_this.restored})';
}


}

/// @nodoc
abstract mixin class $BackupStateCopyWith<$Res>  {
  factory $BackupStateCopyWith(BackupState value, $Res Function(BackupState) _then) = _$BackupStateCopyWithImpl;
@useResult
$Res call({
 DateTime? lastBackupAt, String? busyLabel, bool hasPendingFile, BackupPreview? preview, String? errorMessage, String? infoMessage, bool restored
});




}
/// @nodoc
class _$BackupStateCopyWithImpl<$Res>
    implements $BackupStateCopyWith<$Res> {
  _$BackupStateCopyWithImpl(this._self, this._then);

  final BackupState _self;
  final $Res Function(BackupState) _then;

/// Create a copy of BackupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lastBackupAt = freezed,Object? busyLabel = freezed,Object? hasPendingFile = null,Object? preview = freezed,Object? errorMessage = freezed,Object? infoMessage = freezed,Object? restored = null,}) {
  return _then(BackupState(
lastBackupAt: freezed == lastBackupAt ? _self.lastBackupAt : lastBackupAt // ignore: cast_nullable_to_non_nullable
as DateTime?,busyLabel: freezed == busyLabel ? _self.busyLabel : busyLabel // ignore: cast_nullable_to_non_nullable
as String?,hasPendingFile: null == hasPendingFile ? _self.hasPendingFile : hasPendingFile // ignore: cast_nullable_to_non_nullable
as bool,preview: freezed == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as BackupPreview?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,infoMessage: freezed == infoMessage ? _self.infoMessage : infoMessage // ignore: cast_nullable_to_non_nullable
as String?,restored: null == restored ? _self.restored : restored // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BackupState].
extension BackupStatePatterns on BackupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupState value)  $default,){
final _that = this;
switch (_that) {
case _BackupState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupState value)?  $default,){
final _that = this;
switch (_that) {
case _BackupState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime? lastBackupAt,  String? busyLabel,  bool hasPendingFile,  BackupPreview? preview,  String? errorMessage,  String? infoMessage,  bool restored)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupState() when $default != null:
return $default(_that.lastBackupAt,_that.busyLabel,_that.hasPendingFile,_that.preview,_that.errorMessage,_that.infoMessage,_that.restored);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime? lastBackupAt,  String? busyLabel,  bool hasPendingFile,  BackupPreview? preview,  String? errorMessage,  String? infoMessage,  bool restored)  $default,) {final _that = this;
switch (_that) {
case _BackupState():
return $default(_that.lastBackupAt,_that.busyLabel,_that.hasPendingFile,_that.preview,_that.errorMessage,_that.infoMessage,_that.restored);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime? lastBackupAt,  String? busyLabel,  bool hasPendingFile,  BackupPreview? preview,  String? errorMessage,  String? infoMessage,  bool restored)?  $default,) {final _that = this;
switch (_that) {
case _BackupState() when $default != null:
return $default(_that.lastBackupAt,_that.busyLabel,_that.hasPendingFile,_that.preview,_that.errorMessage,_that.infoMessage,_that.restored);case _:
  return null;

}
}

}

/// @nodoc


class _BackupState extends BackupState {
  const _BackupState({this.lastBackupAt, this.busyLabel, this.hasPendingFile = false, this.preview, this.errorMessage, this.infoMessage, this.restored = false}): super._();
  

@override final  DateTime? lastBackupAt;
/// Teks proses yang sedang berjalan, mis. "Mengenkripsi…"; `null` = diam.
@override final  String? busyLabel;
/// File sudah dipilih, menunggu passphrase.
@override@JsonKey() final  bool hasPendingFile;
/// Backup berhasil dibuka, menunggu konfirmasi timpa.
@override final  BackupPreview? preview;
@override final  String? errorMessage;
@override final  String? infoMessage;
/// Sekali pakai: restore baru saja selesai.
@override@JsonKey() final  bool restored;

/// Create a copy of BackupState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupStateCopyWith<_BackupState> get copyWith => __$BackupStateCopyWithImpl<_BackupState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupState&&(identical(other.lastBackupAt, lastBackupAt) || other.lastBackupAt == lastBackupAt)&&(identical(other.busyLabel, busyLabel) || other.busyLabel == busyLabel)&&(identical(other.hasPendingFile, hasPendingFile) || other.hasPendingFile == hasPendingFile)&&(identical(other.preview, preview) || other.preview == preview)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.infoMessage, infoMessage) || other.infoMessage == infoMessage)&&(identical(other.restored, restored) || other.restored == restored));
}


@override
int get hashCode {
    return Object.hash(runtimeType,lastBackupAt,busyLabel,hasPendingFile,preview,errorMessage,infoMessage,restored);
}

@override
String toString() {
    return 'BackupState(lastBackupAt: $lastBackupAt, busyLabel: $busyLabel, hasPendingFile: $hasPendingFile, preview: $preview, errorMessage: $errorMessage, infoMessage: $infoMessage, restored: $restored)';
}


}

/// @nodoc
abstract mixin class _$BackupStateCopyWith<$Res> implements $BackupStateCopyWith<$Res> {
  factory _$BackupStateCopyWith(_BackupState value, $Res Function(_BackupState) _then) = __$BackupStateCopyWithImpl;
@override @useResult
$Res call({
 DateTime? lastBackupAt, String? busyLabel, bool hasPendingFile, BackupPreview? preview, String? errorMessage, String? infoMessage, bool restored
});




}
/// @nodoc
class __$BackupStateCopyWithImpl<$Res>
    implements _$BackupStateCopyWith<$Res> {
  __$BackupStateCopyWithImpl(this._self, this._then);

  final _BackupState _self;
  final $Res Function(_BackupState) _then;

/// Create a copy of BackupState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lastBackupAt = freezed,Object? busyLabel = freezed,Object? hasPendingFile = null,Object? preview = freezed,Object? errorMessage = freezed,Object? infoMessage = freezed,Object? restored = null,}) {
  return _then(_BackupState(
lastBackupAt: freezed == lastBackupAt ? _self.lastBackupAt : lastBackupAt // ignore: cast_nullable_to_non_nullable
as DateTime?,busyLabel: freezed == busyLabel ? _self.busyLabel : busyLabel // ignore: cast_nullable_to_non_nullable
as String?,hasPendingFile: null == hasPendingFile ? _self.hasPendingFile : hasPendingFile // ignore: cast_nullable_to_non_nullable
as bool,preview: freezed == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as BackupPreview?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,infoMessage: freezed == infoMessage ? _self.infoMessage : infoMessage // ignore: cast_nullable_to_non_nullable
as String?,restored: null == restored ? _self.restored : restored // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
