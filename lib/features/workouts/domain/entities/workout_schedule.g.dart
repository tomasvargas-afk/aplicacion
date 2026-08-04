// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkoutScheduleImpl _$$WorkoutScheduleImplFromJson(
  Map<String, dynamic> json,
) => _$WorkoutScheduleImpl(
  id: json['id'] as String?,
  userId: json['user_id'] as String,
  workoutId: json['workout_id'] as String,
  scheduledDate: DateTime.parse(json['scheduled_date'] as String),
  status: json['status'] as String? ?? 'planned',
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  workout: json['workouts'] == null
      ? null
      : Workout.fromJson(json['workouts'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$WorkoutScheduleImplToJson(
  _$WorkoutScheduleImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'workout_id': instance.workoutId,
  'scheduled_date': instance.scheduledDate.toIso8601String(),
  'status': instance.status,
  'created_at': instance.createdAt?.toIso8601String(),
};
