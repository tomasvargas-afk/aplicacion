import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise.freezed.dart';
part 'exercise.g.dart';

@freezed
abstract class Exercise with _$Exercise {
  const factory Exercise({
    String? id,
    required String name,
    @JsonKey(name: 'muscle_group') String? muscleGroup,
    String? equipment,
    String? description,
    @JsonKey(name: 'video_url') String? videoUrl,
    @JsonKey(name: 'is_custom') @Default(false) bool isCustom,
  }) = _Exercise;

  factory Exercise.fromJson(Map<String, dynamic> json) => _$ExerciseFromJson(json);
}
