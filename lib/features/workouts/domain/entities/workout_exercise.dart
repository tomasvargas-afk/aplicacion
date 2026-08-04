import 'package:freezed_annotation/freezed_annotation.dart';

import 'exercise.dart';

part 'workout_exercise.freezed.dart';
part 'workout_exercise.g.dart';

@freezed
abstract class WorkoutExercise with _$WorkoutExercise {
  const factory WorkoutExercise({
    String? id,
    @JsonKey(name: 'workout_id') String? workoutId,
    @JsonKey(name: 'exercise_id') required String exerciseId,
    @JsonKey(name: 'exercises_library', includeToJson: false) Exercise? exercise,
    @Default(3) int sets,
    @Default('8-12') String reps,
    @JsonKey(name: 'rest_seconds') @Default(60) int restSeconds,
    @JsonKey(name: 'order_index') @Default(0) int orderIndex,
    @JsonKey(name: 'target_weight_kg') double? targetWeightKg,
    String? notes,
  }) = _WorkoutExercise;

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) =>
      _$WorkoutExerciseFromJson(json);
}
