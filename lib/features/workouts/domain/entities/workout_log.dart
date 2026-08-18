import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_log.freezed.dart';
part 'workout_log.g.dart';

@freezed
abstract class WorkoutLog with _$WorkoutLog {
  const factory WorkoutLog({
    String? id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'workout_id') required String workoutId,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    @JsonKey(name: 'calories_burned') double? caloriesBurned,
    String? notes,
  }) = _WorkoutLog;

  factory WorkoutLog.fromJson(Map<String, dynamic> json) =>
      _$WorkoutLogFromJson(json);
}
