import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_log_set.freezed.dart';
part 'workout_log_set.g.dart';

@freezed
abstract class WorkoutLogSet with _$WorkoutLogSet {
  const factory WorkoutLogSet({
    String? id,
    @JsonKey(name: 'workout_log_id') String? workoutLogId,
    @JsonKey(name: 'exercise_id') required String exerciseId,
    @JsonKey(name: 'set_number') required int setNumber,
    @JsonKey(name: 'reps_done') int? repsDone,
    @JsonKey(name: 'weight_kg') double? weightKg,
  }) = _WorkoutLogSet;

  factory WorkoutLogSet.fromJson(Map<String, dynamic> json) =>
      _$WorkoutLogSetFromJson(json);
}
