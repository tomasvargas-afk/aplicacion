// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_plan_meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DietPlanMealImpl _$$DietPlanMealImplFromJson(Map<String, dynamic> json) =>
    _$DietPlanMealImpl(
      id: json['id'] as String?,
      dietPlanId: json['diet_plan_id'] as String?,
      mealType: json['meal_type'] as String,
      suggestedFood: json['suggested_food'] as String,
      calories: (json['calories'] as num).toDouble(),
      proteinG: (json['protein_g'] as num).toDouble(),
      carbsG: (json['carbs_g'] as num).toDouble(),
      fatG: (json['fat_g'] as num).toDouble(),
    );

Map<String, dynamic> _$$DietPlanMealImplToJson(_$DietPlanMealImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'diet_plan_id': instance.dietPlanId,
      'meal_type': instance.mealType,
      'suggested_food': instance.suggestedFood,
      'calories': instance.calories,
      'protein_g': instance.proteinG,
      'carbs_g': instance.carbsG,
      'fat_g': instance.fatG,
    };
