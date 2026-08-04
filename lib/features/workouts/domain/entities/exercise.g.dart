// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExerciseImpl _$$ExerciseImplFromJson(Map<String, dynamic> json) =>
    _$ExerciseImpl(
      id: json['id'] as String?,
      name: json['name'] as String,
      muscleGroup: json['muscle_group'] as String?,
      equipment: json['equipment'] as String?,
      description: json['description'] as String?,
      videoUrl: json['video_url'] as String?,
      isCustom: json['is_custom'] as bool? ?? false,
    );

Map<String, dynamic> _$$ExerciseImplToJson(_$ExerciseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'muscle_group': instance.muscleGroup,
      'equipment': instance.equipment,
      'description': instance.description,
      'video_url': instance.videoUrl,
      'is_custom': instance.isCustom,
    };
