// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WorkoutSchedule _$WorkoutScheduleFromJson(Map<String, dynamic> json) {
  return _WorkoutSchedule.fromJson(json);
}

/// @nodoc
mixin _$WorkoutSchedule {
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'workout_id')
  String get workoutId => throw _privateConstructorUsedError;
  @JsonKey(name: 'scheduled_date')
  DateTime get scheduledDate => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'workouts', includeToJson: false)
  Workout? get workout => throw _privateConstructorUsedError;

  /// Serializes this WorkoutSchedule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutScheduleCopyWith<WorkoutSchedule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutScheduleCopyWith<$Res> {
  factory $WorkoutScheduleCopyWith(
    WorkoutSchedule value,
    $Res Function(WorkoutSchedule) then,
  ) = _$WorkoutScheduleCopyWithImpl<$Res, WorkoutSchedule>;
  @useResult
  $Res call({
    String? id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'workout_id') String workoutId,
    @JsonKey(name: 'scheduled_date') DateTime scheduledDate,
    String status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'workouts', includeToJson: false) Workout? workout,
  });

  $WorkoutCopyWith<$Res>? get workout;
}

/// @nodoc
class _$WorkoutScheduleCopyWithImpl<$Res, $Val extends WorkoutSchedule>
    implements $WorkoutScheduleCopyWith<$Res> {
  _$WorkoutScheduleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = null,
    Object? workoutId = null,
    Object? scheduledDate = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? workout = freezed,
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
            workoutId: null == workoutId
                ? _value.workoutId
                : workoutId // ignore: cast_nullable_to_non_nullable
                      as String,
            scheduledDate: null == scheduledDate
                ? _value.scheduledDate
                : scheduledDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            workout: freezed == workout
                ? _value.workout
                : workout // ignore: cast_nullable_to_non_nullable
                      as Workout?,
          )
          as $Val,
    );
  }

  /// Create a copy of WorkoutSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WorkoutCopyWith<$Res>? get workout {
    if (_value.workout == null) {
      return null;
    }

    return $WorkoutCopyWith<$Res>(_value.workout!, (value) {
      return _then(_value.copyWith(workout: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WorkoutScheduleImplCopyWith<$Res>
    implements $WorkoutScheduleCopyWith<$Res> {
  factory _$$WorkoutScheduleImplCopyWith(
    _$WorkoutScheduleImpl value,
    $Res Function(_$WorkoutScheduleImpl) then,
  ) = __$$WorkoutScheduleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'workout_id') String workoutId,
    @JsonKey(name: 'scheduled_date') DateTime scheduledDate,
    String status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'workouts', includeToJson: false) Workout? workout,
  });

  @override
  $WorkoutCopyWith<$Res>? get workout;
}

/// @nodoc
class __$$WorkoutScheduleImplCopyWithImpl<$Res>
    extends _$WorkoutScheduleCopyWithImpl<$Res, _$WorkoutScheduleImpl>
    implements _$$WorkoutScheduleImplCopyWith<$Res> {
  __$$WorkoutScheduleImplCopyWithImpl(
    _$WorkoutScheduleImpl _value,
    $Res Function(_$WorkoutScheduleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WorkoutSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = null,
    Object? workoutId = null,
    Object? scheduledDate = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? workout = freezed,
  }) {
    return _then(
      _$WorkoutScheduleImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        workoutId: null == workoutId
            ? _value.workoutId
            : workoutId // ignore: cast_nullable_to_non_nullable
                  as String,
        scheduledDate: null == scheduledDate
            ? _value.scheduledDate
            : scheduledDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        workout: freezed == workout
            ? _value.workout
            : workout // ignore: cast_nullable_to_non_nullable
                  as Workout?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutScheduleImpl implements _WorkoutSchedule {
  const _$WorkoutScheduleImpl({
    this.id,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'workout_id') required this.workoutId,
    @JsonKey(name: 'scheduled_date') required this.scheduledDate,
    this.status = 'planned',
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'workouts', includeToJson: false) this.workout,
  });

  factory _$WorkoutScheduleImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutScheduleImplFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'workout_id')
  final String workoutId;
  @override
  @JsonKey(name: 'scheduled_date')
  final DateTime scheduledDate;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'workouts', includeToJson: false)
  final Workout? workout;

  @override
  String toString() {
    return 'WorkoutSchedule(id: $id, userId: $userId, workoutId: $workoutId, scheduledDate: $scheduledDate, status: $status, createdAt: $createdAt, workout: $workout)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutScheduleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.workoutId, workoutId) ||
                other.workoutId == workoutId) &&
            (identical(other.scheduledDate, scheduledDate) ||
                other.scheduledDate == scheduledDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.workout, workout) || other.workout == workout));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    workoutId,
    scheduledDate,
    status,
    createdAt,
    workout,
  );

  /// Create a copy of WorkoutSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutScheduleImplCopyWith<_$WorkoutScheduleImpl> get copyWith =>
      __$$WorkoutScheduleImplCopyWithImpl<_$WorkoutScheduleImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutScheduleImplToJson(this);
  }
}

abstract class _WorkoutSchedule implements WorkoutSchedule {
  const factory _WorkoutSchedule({
    final String? id,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'workout_id') required final String workoutId,
    @JsonKey(name: 'scheduled_date') required final DateTime scheduledDate,
    final String status,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'workouts', includeToJson: false) final Workout? workout,
  }) = _$WorkoutScheduleImpl;

  factory _WorkoutSchedule.fromJson(Map<String, dynamic> json) =
      _$WorkoutScheduleImpl.fromJson;

  @override
  String? get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'workout_id')
  String get workoutId;
  @override
  @JsonKey(name: 'scheduled_date')
  DateTime get scheduledDate;
  @override
  String get status;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'workouts', includeToJson: false)
  Workout? get workout;

  /// Create a copy of WorkoutSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutScheduleImplCopyWith<_$WorkoutScheduleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
