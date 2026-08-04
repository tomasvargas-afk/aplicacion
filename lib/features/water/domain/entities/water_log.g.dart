// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WaterLogImpl _$$WaterLogImplFromJson(Map<String, dynamic> json) =>
    _$WaterLogImpl(
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      loggedDate: DateTime.parse(json['logged_date'] as String),
      amountMl: (json['amount_ml'] as num).toInt(),
      goalMl: (json['goal_ml'] as num?)?.toInt() ?? 2000,
    );

Map<String, dynamic> _$$WaterLogImplToJson(_$WaterLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'logged_date': instance.loggedDate.toIso8601String(),
      'amount_ml': instance.amountMl,
      'goal_ml': instance.goalMl,
    };
