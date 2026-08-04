// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_measurement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BodyMeasurementImpl _$$BodyMeasurementImplFromJson(
  Map<String, dynamic> json,
) => _$BodyMeasurementImpl(
  id: json['id'] as String?,
  userId: json['user_id'] as String,
  measuredAt: DateTime.parse(json['measured_at'] as String),
  weightKg: (json['weight_kg'] as num?)?.toDouble(),
  bodyFatPercent: (json['body_fat_percent'] as num?)?.toDouble(),
  muscleMassPercent: (json['muscle_mass_percent'] as num?)?.toDouble(),
  chestCm: (json['chest_cm'] as num?)?.toDouble(),
  waistCm: (json['waist_cm'] as num?)?.toDouble(),
  hipCm: (json['hip_cm'] as num?)?.toDouble(),
  armCm: (json['arm_cm'] as num?)?.toDouble(),
  thighCm: (json['thigh_cm'] as num?)?.toDouble(),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$BodyMeasurementImplToJson(
  _$BodyMeasurementImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'measured_at': instance.measuredAt.toIso8601String(),
  'weight_kg': instance.weightKg,
  'body_fat_percent': instance.bodyFatPercent,
  'muscle_mass_percent': instance.muscleMassPercent,
  'chest_cm': instance.chestCm,
  'waist_cm': instance.waistCm,
  'hip_cm': instance.hipCm,
  'arm_cm': instance.armCm,
  'thigh_cm': instance.thighCm,
  'notes': instance.notes,
};
