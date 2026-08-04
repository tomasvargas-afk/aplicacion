// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GoalImpl _$$GoalImplFromJson(Map<String, dynamic> json) => _$GoalImpl(
  id: json['id'] as String?,
  userId: json['user_id'] as String,
  type: json['type'] as String,
  title: json['title'] as String,
  targetValue: (json['target_value'] as num).toDouble(),
  currentValue: (json['current_value'] as num?)?.toDouble() ?? 0,
  unit: json['unit'] as String?,
  deadline: json['deadline'] == null
      ? null
      : DateTime.parse(json['deadline'] as String),
  status: json['status'] as String? ?? 'active',
);

Map<String, dynamic> _$$GoalImplToJson(_$GoalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'type': instance.type,
      'title': instance.title,
      'target_value': instance.targetValue,
      'current_value': instance.currentValue,
      'unit': instance.unit,
      'deadline': instance.deadline?.toIso8601String(),
      'status': instance.status,
    };
