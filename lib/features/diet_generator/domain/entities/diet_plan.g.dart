// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DietPlanImpl _$$DietPlanImplFromJson(Map<String, dynamic> json) =>
    _$DietPlanImpl(
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      name: json['name'] as String?,
      formulaUsed: json['formula_used'] as String? ?? 'mifflin_st_jeor',
      bmr: (json['bmr'] as num).toDouble(),
      tdee: (json['tdee'] as num).toDouble(),
      dailyCalories: (json['daily_calories'] as num).toDouble(),
      proteinG: (json['protein_g'] as num).toDouble(),
      carbsG: (json['carbs_g'] as num).toDouble(),
      fatG: (json['fat_g'] as num).toDouble(),
      activityLevel: json['activity_level'] as String,
      goal: json['goal'] as String,
      generatedAt: json['generated_at'] == null
          ? null
          : DateTime.parse(json['generated_at'] as String),
      meals:
          (json['diet_plan_meals'] as List<dynamic>?)
              ?.map((e) => DietPlanMeal.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <DietPlanMeal>[],
    );

Map<String, dynamic> _$$DietPlanImplToJson(_$DietPlanImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'formula_used': instance.formulaUsed,
      'bmr': instance.bmr,
      'tdee': instance.tdee,
      'daily_calories': instance.dailyCalories,
      'protein_g': instance.proteinG,
      'carbs_g': instance.carbsG,
      'fat_g': instance.fatG,
      'activity_level': instance.activityLevel,
      'goal': instance.goal,
      'generated_at': instance.generatedAt?.toIso8601String(),
    };
