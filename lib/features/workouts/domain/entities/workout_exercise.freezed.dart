// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_exercise.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WorkoutExercise _$WorkoutExerciseFromJson(Map<String, dynamic> json) {
  return _WorkoutExercise.fromJson(json);
}

/// @nodoc
mixin _$WorkoutExercise {
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'workout_id')
  String? get workoutId => throw _privateConstructorUsedError;
  @JsonKey(name: 'exercise_id')
  String get exerciseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'exercises_library', includeToJson: false)
  Exercise? get exercise => throw _privateConstructorUsedError;
  int get sets => throw _privateConstructorUsedError;
  String get reps => throw _privateConstructorUsedError;
  @JsonKey(name: 'rest_seconds')
  int get restSeconds => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_index')
  int get orderIndex => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_weight_kg')
  double? get targetWeightKg => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this WorkoutExercise to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutExercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutExerciseCopyWith<WorkoutExercise> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutExerciseCopyWith<$Res> {
  factory $WorkoutExerciseCopyWith(
    WorkoutExercise value,
    $Res Function(WorkoutExercise) then,
  ) = _$WorkoutExerciseCopyWithImpl<$Res, WorkoutExercise>;
  @useResult
  $Res call({
    String? id,
    @JsonKey(name: 'workout_id') String? workoutId,
    @JsonKey(name: 'exercise_id') String exerciseId,
    @JsonKey(name: 'exercises_library', includeToJson: false)
    Exercise? exercise,
    int sets,
    String reps,
    @JsonKey(name: 'rest_seconds') int restSeconds,
    @JsonKey(name: 'order_index') int orderIndex,
    @JsonKey(name: 'target_weight_kg') double? targetWeightKg,
    String? notes,
  });

  $ExerciseCopyWith<$Res>? get exercise;
}

/// @nodoc
class _$WorkoutExerciseCopyWithImpl<$Res, $Val extends WorkoutExercise>
    implements $WorkoutExerciseCopyWith<$Res> {
  _$WorkoutExerciseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutExercise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? workoutId = freezed,
    Object? exerciseId = null,
    Object? exercise = freezed,
    Object? sets = null,
    Object? reps = null,
    Object? restSeconds = null,
    Object? orderIndex = null,
    Object? targetWeightKg = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            workoutId: freezed == workoutId
                ? _value.workoutId
                : workoutId // ignore: cast_nullable_to_non_nullable
                      as String?,
            exerciseId: null == exerciseId
                ? _value.exerciseId
                : exerciseId // ignore: cast_nullable_to_non_nullable
                      as String,
            exercise: freezed == exercise
                ? _value.exercise
                : exercise // ignore: cast_nullable_to_non_nullable
                      as Exercise?,
            sets: null == sets
                ? _value.sets
                : sets // ignore: cast_nullable_to_non_nullable
                      as int,
            reps: null == reps
                ? _value.reps
                : reps // ignore: cast_nullable_to_non_nullable
                      as String,
            restSeconds: null == restSeconds
                ? _value.restSeconds
                : restSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            orderIndex: null == orderIndex
                ? _value.orderIndex
                : orderIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            targetWeightKg: freezed == targetWeightKg
                ? _value.targetWeightKg
                : targetWeightKg // ignore: cast_nullable_to_non_nullable
                      as double?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of WorkoutExercise
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExerciseCopyWith<$Res>? get exercise {
    if (_value.exercise == null) {
      return null;
    }

    return $ExerciseCopyWith<$Res>(_value.exercise!, (value) {
      return _then(_value.copyWith(exercise: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WorkoutExerciseImplCopyWith<$Res>
    implements $WorkoutExerciseCopyWith<$Res> {
  factory _$$WorkoutExerciseImplCopyWith(
    _$WorkoutExerciseImpl value,
    $Res Function(_$WorkoutExerciseImpl) then,
  ) = __$$WorkoutExerciseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    @JsonKey(name: 'workout_id') String? workoutId,
    @JsonKey(name: 'exercise_id') String exerciseId,
    @JsonKey(name: 'exercises_library', includeToJson: false)
    Exercise? exercise,
    int sets,
    String reps,
    @JsonKey(name: 'rest_seconds') int restSeconds,
    @JsonKey(name: 'order_index') int orderIndex,
    @JsonKey(name: 'target_weight_kg') double? targetWeightKg,
    String? notes,
  });

  @override
  $ExerciseCopyWith<$Res>? get exercise;
}

/// @nodoc
class __$$WorkoutExerciseImplCopyWithImpl<$Res>
    extends _$WorkoutExerciseCopyWithImpl<$Res, _$WorkoutExerciseImpl>
    implements _$$WorkoutExerciseImplCopyWith<$Res> {
  __$$WorkoutExerciseImplCopyWithImpl(
    _$WorkoutExerciseImpl _value,
    $Res Function(_$WorkoutExerciseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WorkoutExercise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? workoutId = freezed,
    Object? exerciseId = null,
    Object? exercise = freezed,
    Object? sets = null,
    Object? reps = null,
    Object? restSeconds = null,
    Object? orderIndex = null,
    Object? targetWeightKg = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$WorkoutExerciseImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        workoutId: freezed == workoutId
            ? _value.workoutId
            : workoutId // ignore: cast_nullable_to_non_nullable
                  as String?,
        exerciseId: null == exerciseId
            ? _value.exerciseId
            : exerciseId // ignore: cast_nullable_to_non_nullable
                  as String,
        exercise: freezed == exercise
            ? _value.exercise
            : exercise // ignore: cast_nullable_to_non_nullable
                  as Exercise?,
        sets: null == sets
            ? _value.sets
            : sets // ignore: cast_nullable_to_non_nullable
                  as int,
        reps: null == reps
            ? _value.reps
            : reps // ignore: cast_nullable_to_non_nullable
                  as String,
        restSeconds: null == restSeconds
            ? _value.restSeconds
            : restSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        orderIndex: null == orderIndex
            ? _value.orderIndex
            : orderIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        targetWeightKg: freezed == targetWeightKg
            ? _value.targetWeightKg
            : targetWeightKg // ignore: cast_nullable_to_non_nullable
                  as double?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutExerciseImpl implements _WorkoutExercise {
  const _$WorkoutExerciseImpl({
    this.id,
    @JsonKey(name: 'workout_id') this.workoutId,
    @JsonKey(name: 'exercise_id') required this.exerciseId,
    @JsonKey(name: 'exercises_library', includeToJson: false) this.exercise,
    this.sets = 3,
    this.reps = '8-12',
    @JsonKey(name: 'rest_seconds') this.restSeconds = 60,
    @JsonKey(name: 'order_index') this.orderIndex = 0,
    @JsonKey(name: 'target_weight_kg') this.targetWeightKg,
    this.notes,
  });

  factory _$WorkoutExerciseImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutExerciseImplFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey(name: 'workout_id')
  final String? workoutId;
  @override
  @JsonKey(name: 'exercise_id')
  final String exerciseId;
  @override
  @JsonKey(name: 'exercises_library', includeToJson: false)
  final Exercise? exercise;
  @override
  @JsonKey()
  final int sets;
  @override
  @JsonKey()
  final String reps;
  @override
  @JsonKey(name: 'rest_seconds')
  final int restSeconds;
  @override
  @JsonKey(name: 'order_index')
  final int orderIndex;
  @override
  @JsonKey(name: 'target_weight_kg')
  final double? targetWeightKg;
  @override
  final String? notes;

  @override
  String toString() {
    return 'WorkoutExercise(id: $id, workoutId: $workoutId, exerciseId: $exerciseId, exercise: $exercise, sets: $sets, reps: $reps, restSeconds: $restSeconds, orderIndex: $orderIndex, targetWeightKg: $targetWeightKg, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutExerciseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workoutId, workoutId) ||
                other.workoutId == workoutId) &&
            (identical(other.exerciseId, exerciseId) ||
                other.exerciseId == exerciseId) &&
            (identical(other.exercise, exercise) ||
                other.exercise == exercise) &&
            (identical(other.sets, sets) || other.sets == sets) &&
            (identical(other.reps, reps) || other.reps == reps) &&
            (identical(other.restSeconds, restSeconds) ||
                other.restSeconds == restSeconds) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex) &&
            (identical(other.targetWeightKg, targetWeightKg) ||
                other.targetWeightKg == targetWeightKg) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    workoutId,
    exerciseId,
    exercise,
    sets,
    reps,
    restSeconds,
    orderIndex,
    targetWeightKg,
    notes,
  );

  /// Create a copy of WorkoutExercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutExerciseImplCopyWith<_$WorkoutExerciseImpl> get copyWith =>
      __$$WorkoutExerciseImplCopyWithImpl<_$WorkoutExerciseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutExerciseImplToJson(this);
  }
}

abstract class _WorkoutExercise implements WorkoutExercise {
  const factory _WorkoutExercise({
    final String? id,
    @JsonKey(name: 'workout_id') final String? workoutId,
    @JsonKey(name: 'exercise_id') required final String exerciseId,
    @JsonKey(name: 'exercises_library', includeToJson: false)
    final Exercise? exercise,
    final int sets,
    final String reps,
    @JsonKey(name: 'rest_seconds') final int restSeconds,
    @JsonKey(name: 'order_index') final int orderIndex,
    @JsonKey(name: 'target_weight_kg') final double? targetWeightKg,
    final String? notes,
  }) = _$WorkoutExerciseImpl;

  factory _WorkoutExercise.fromJson(Map<String, dynamic> json) =
      _$WorkoutExerciseImpl.fromJson;

  @override
  String? get id;
  @override
  @JsonKey(name: 'workout_id')
  String? get workoutId;
  @override
  @JsonKey(name: 'exercise_id')
  String get exerciseId;
  @override
  @JsonKey(name: 'exercises_library', includeToJson: false)
  Exercise? get exercise;
  @override
  int get sets;
  @override
  String get reps;
  @override
  @JsonKey(name: 'rest_seconds')
  int get restSeconds;
  @override
  @JsonKey(name: 'order_index')
  int get orderIndex;
  @override
  @JsonKey(name: 'target_weight_kg')
  double? get targetWeightKg;
  @override
  String? get notes;

  /// Create a copy of WorkoutExercise
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutExerciseImplCopyWith<_$WorkoutExerciseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
