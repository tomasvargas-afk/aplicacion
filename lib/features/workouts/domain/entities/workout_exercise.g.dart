// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkoutExerciseImpl _$$WorkoutExerciseImplFromJson(
  Map<String, dynamic> json,
) => _$WorkoutExerciseImpl(
  id: json['id'] as String?,
  workoutId: json['workout_id'] as String?,
  exerciseId: json['exercise_id'] as String,
  exercise: json['exercises_library'] == null
      ? null
      : Exercise.fromJson(json['exercises_library'] as Map<String, dynamic>),
  sets: (json['sets'] as num?)?.toInt() ?? 3,
  reps: json['reps'] as String? ?? '8-12',
  restSeconds: (json['rest_seconds'] as num?)?.toInt() ?? 60,
  orderIndex: (json['order_index'] as num?)?.toInt() ?? 0,
  targetWeightKg: (json['target_weight_kg'] as num?)?.toDouble(),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$WorkoutExerciseImplToJson(
  _$WorkoutExerciseImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'workout_id': instance.workoutId,
  'exercise_id': instance.exerciseId,
  'sets': instance.sets,
  'reps': instance.reps,
  'rest_seconds': instance.restSeconds,
  'order_index': instance.orderIndex,
  'target_weight_kg': instance.targetWeightKg,
  'notes': instance.notes,
};
