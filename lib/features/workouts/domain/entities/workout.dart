import 'package:freezed_annotation/freezed_annotation.dart';

import 'workout_exercise.dart';

part 'workout.freezed.dart';
part 'workout.g.dart';

@freezed
abstract class Workout with _$Workout {
  const factory Workout({
    String? id,
    @JsonKey(name: 'user_id') required String userId,
    required String name,
    @Default('custom') String type,
    String? description,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'workout_exercises', includeToJson: false)
    @Default(<WorkoutExercise>[])
    List<WorkoutExercise> exercises,
  }) = _Workout;

  factory Workout.fromJson(Map<String, dynamic> json) => _$WorkoutFromJson(json);
}

extension WorkoutTypeLabel on String {
  String get workoutTypeLabel => switch (this) {
        'ppl' => 'Push Pull Legs',
        'upper_lower' => 'Upper / Lower',
        'full_body' => 'Full Body',
        'arnold_split' => 'Arnold Split',
        _ => 'Personalizada',
      };
}
