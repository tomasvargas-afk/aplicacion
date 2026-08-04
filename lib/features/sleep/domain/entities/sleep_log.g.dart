// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SleepLogImpl _$$SleepLogImplFromJson(Map<String, dynamic> json) =>
    _$SleepLogImpl(
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      sleepDate: DateTime.parse(json['sleep_date'] as String),
      hours: (json['hours'] as num).toDouble(),
      quality: (json['quality'] as num?)?.toInt(),
      bedTime: json['bed_time'] as String?,
      wakeTime: json['wake_time'] as String?,
    );

Map<String, dynamic> _$$SleepLogImplToJson(_$SleepLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'sleep_date': instance.sleepDate.toIso8601String(),
      'hours': instance.hours,
      'quality': instance.quality,
      'bed_time': instance.bedTime,
      'wake_time': instance.wakeTime,
    };
