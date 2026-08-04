// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sleep_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SleepLog _$SleepLogFromJson(Map<String, dynamic> json) {
  return _SleepLog.fromJson(json);
}

/// @nodoc
mixin _$SleepLog {
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sleep_date')
  DateTime get sleepDate => throw _privateConstructorUsedError;
  double get hours => throw _privateConstructorUsedError;
  int? get quality => throw _privateConstructorUsedError;

  /// Stored as "HH:mm" (Postgres `time`).
  @JsonKey(name: 'bed_time')
  String? get bedTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'wake_time')
  String? get wakeTime => throw _privateConstructorUsedError;

  /// Serializes this SleepLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SleepLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SleepLogCopyWith<SleepLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SleepLogCopyWith<$Res> {
  factory $SleepLogCopyWith(SleepLog value, $Res Function(SleepLog) then) =
      _$SleepLogCopyWithImpl<$Res, SleepLog>;
  @useResult
  $Res call({
    String? id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'sleep_date') DateTime sleepDate,
    double hours,
    int? quality,
    @JsonKey(name: 'bed_time') String? bedTime,
    @JsonKey(name: 'wake_time') String? wakeTime,
  });
}

/// @nodoc
class _$SleepLogCopyWithImpl<$Res, $Val extends SleepLog>
    implements $SleepLogCopyWith<$Res> {
  _$SleepLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SleepLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = null,
    Object? sleepDate = null,
    Object? hours = null,
    Object? quality = freezed,
    Object? bedTime = freezed,
    Object? wakeTime = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            sleepDate: null == sleepDate
                ? _value.sleepDate
                : sleepDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            hours: null == hours
                ? _value.hours
                : hours // ignore: cast_nullable_to_non_nullable
                      as double,
            quality: freezed == quality
                ? _value.quality
                : quality // ignore: cast_nullable_to_non_nullable
                      as int?,
            bedTime: freezed == bedTime
                ? _value.bedTime
                : bedTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            wakeTime: freezed == wakeTime
                ? _value.wakeTime
                : wakeTime // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SleepLogImplCopyWith<$Res>
    implements $SleepLogCopyWith<$Res> {
  factory _$$SleepLogImplCopyWith(
    _$SleepLogImpl value,
    $Res Function(_$SleepLogImpl) then,
  ) = __$$SleepLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'sleep_date') DateTime sleepDate,
    double hours,
    int? quality,
    @JsonKey(name: 'bed_time') String? bedTime,
    @JsonKey(name: 'wake_time') String? wakeTime,
  });
}

/// @nodoc
class __$$SleepLogImplCopyWithImpl<$Res>
    extends _$SleepLogCopyWithImpl<$Res, _$SleepLogImpl>
    implements _$$SleepLogImplCopyWith<$Res> {
  __$$SleepLogImplCopyWithImpl(
    _$SleepLogImpl _value,
    $Res Function(_$SleepLogImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SleepLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = null,
    Object? sleepDate = null,
    Object? hours = null,
    Object? quality = freezed,
    Object? bedTime = freezed,
    Object? wakeTime = freezed,
  }) {
    return _then(
      _$SleepLogImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        sleepDate: null == sleepDate
            ? _value.sleepDate
            : sleepDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        hours: null == hours
            ? _value.hours
            : hours // ignore: cast_nullable_to_non_nullable
                  as double,
        quality: freezed == quality
            ? _value.quality
            : quality // ignore: cast_nullable_to_non_nullable
                  as int?,
        bedTime: freezed == bedTime
            ? _value.bedTime
            : bedTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        wakeTime: freezed == wakeTime
            ? _value.wakeTime
            : wakeTime // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SleepLogImpl implements _SleepLog {
  const _$SleepLogImpl({
    this.id,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'sleep_date') required this.sleepDate,
    required this.hours,
    this.quality,
    @JsonKey(name: 'bed_time') this.bedTime,
    @JsonKey(name: 'wake_time') this.wakeTime,
  });

  factory _$SleepLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$SleepLogImplFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'sleep_date')
  final DateTime sleepDate;
  @override
  final double hours;
  @override
  final int? quality;

  /// Stored as "HH:mm" (Postgres `time`).
  @override
  @JsonKey(name: 'bed_time')
  final String? bedTime;
  @override
  @JsonKey(name: 'wake_time')
  final String? wakeTime;

  @override
  String toString() {
    return 'SleepLog(id: $id, userId: $userId, sleepDate: $sleepDate, hours: $hours, quality: $quality, bedTime: $bedTime, wakeTime: $wakeTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SleepLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.sleepDate, sleepDate) ||
                other.sleepDate == sleepDate) &&
            (identical(other.hours, hours) || other.hours == hours) &&
            (identical(other.quality, quality) || other.quality == quality) &&
            (identical(other.bedTime, bedTime) || other.bedTime == bedTime) &&
            (identical(other.wakeTime, wakeTime) ||
                other.wakeTime == wakeTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    sleepDate,
    hours,
    quality,
    bedTime,
    wakeTime,
  );

  /// Create a copy of SleepLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SleepLogImplCopyWith<_$SleepLogImpl> get copyWith =>
      __$$SleepLogImplCopyWithImpl<_$SleepLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SleepLogImplToJson(this);
  }
}

abstract class _SleepLog implements SleepLog {
  const factory _SleepLog({
    final String? id,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'sleep_date') required final DateTime sleepDate,
    required final double hours,
    final int? quality,
    @JsonKey(name: 'bed_time') final String? bedTime,
    @JsonKey(name: 'wake_time') final String? wakeTime,
  }) = _$SleepLogImpl;

  factory _SleepLog.fromJson(Map<String, dynamic> json) =
      _$SleepLogImpl.fromJson;

  @override
  String? get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'sleep_date')
  DateTime get sleepDate;
  @override
  double get hours;
  @override
  int? get quality;

  /// Stored as "HH:mm" (Postgres `time`).
  @override
  @JsonKey(name: 'bed_time')
  String? get bedTime;
  @override
  @JsonKey(name: 'wake_time')
  String? get wakeTime;

  /// Create a copy of SleepLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SleepLogImplCopyWith<_$SleepLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
