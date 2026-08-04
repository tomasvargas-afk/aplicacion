import 'package:freezed_annotation/freezed_annotation.dart';

import 'diet_plan_meal.dart';

part 'diet_plan.freezed.dart';
part 'diet_plan.g.dart';

@freezed
abstract class DietPlan with _$DietPlan {
  const factory DietPlan({
    String? id,
    @JsonKey(name: 'user_id') required String userId,
    String? name,
    @JsonKey(name: 'formula_used') @Default('mifflin_st_jeor') String formulaUsed,
    required double bmr,
    required double tdee,
    @JsonKey(name: 'daily_calories') required double dailyCalories,
    @JsonKey(name: 'protein_g') required double proteinG,
    @JsonKey(name: 'carbs_g') required double carbsG,
    @JsonKey(name: 'fat_g') required double fatG,
    @JsonKey(name: 'activity_level') required String activityLevel,
    required String goal,
    @JsonKey(name: 'generated_at') DateTime? generatedAt,
    @JsonKey(name: 'diet_plan_meals', includeToJson: false)
    @Default(<DietPlanMeal>[])
    List<DietPlanMeal> meals,
  }) = _DietPlan;

  factory DietPlan.fromJson(Map<String, dynamic> json) => _$DietPlanFromJson(json);
}
