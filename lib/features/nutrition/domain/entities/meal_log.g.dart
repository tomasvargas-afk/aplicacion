// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MealLogImpl _$$MealLogImplFromJson(Map<String, dynamic> json) =>
    _$MealLogImpl(
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      customName: json['custom_name'] as String,
      mealType: json['meal_type'] as String,
      calories: (json['calories'] as num?)?.toDouble() ?? 0,
      proteinG: (json['protein_g'] as num?)?.toDouble() ?? 0,
      carbsG: (json['carbs_g'] as num?)?.toDouble() ?? 0,
      fatG: (json['fat_g'] as num?)?.toDouble() ?? 0,
      loggedAt: json['logged_at'] == null
          ? null
          : DateTime.parse(json['logged_at'] as String),
    );

Map<String, dynamic> _$$MealLogImplToJson(_$MealLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'custom_name': instance.customName,
      'meal_type': instance.mealType,
      'calories': instance.calories,
      'protein_g': instance.proteinG,
      'carbs_g': instance.carbsG,
      'fat_g': instance.fatG,
      'logged_at': instance.loggedAt?.toIso8601String(),
    };
