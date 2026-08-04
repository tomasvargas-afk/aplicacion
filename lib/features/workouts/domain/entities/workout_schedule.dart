import 'package:freezed_annotation/freezed_annotation.dart';

import 'workout.dart';

part 'workout_schedule.freezed.dart';
part 'workout_schedule.g.dart';

@freezed
abstract class WorkoutSchedule with _$WorkoutSchedule {
  const factory WorkoutSchedule({
    String? id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'workout_id') required String workoutId,
    @JsonKey(name: 'scheduled_date') required DateTime scheduledDate,
    @Default('planned') String status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'workouts', includeToJson: false) Workout? workout,
  }) = _WorkoutSchedule;

  factory WorkoutSchedule.fromJson(Map<String, dynamic> json) =>
      _$WorkoutScheduleFromJson(json);
}

extension WorkoutScheduleStatusX on String {
  String get scheduleStatusLabel => switch (this) {
        'completed' => 'Completado',
        'skipped' => 'Omitido',
        _ => 'Planeado',
      };
}
