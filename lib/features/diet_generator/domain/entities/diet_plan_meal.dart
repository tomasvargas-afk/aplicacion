import 'package:freezed_annotation/freezed_annotation.dart';

part 'diet_plan_meal.freezed.dart';
part 'diet_plan_meal.g.dart';

@freezed
abstract class DietPlanMeal with _$DietPlanMeal {
  const factory DietPlanMeal({
    String? id,
    @JsonKey(name: 'diet_plan_id') String? dietPlanId,
    @JsonKey(name: 'meal_type') required String mealType,
    @JsonKey(name: 'suggested_food') required String suggestedFood,
    required double calories,
    @JsonKey(name: 'protein_g') required double proteinG,
    @JsonKey(name: 'carbs_g') required double carbsG,
    @JsonKey(name: 'fat_g') required double fatG,
  }) = _DietPlanMeal;

  factory DietPlanMeal.fromJson(Map<String, dynamic> json) =>
      _$DietPlanMealFromJson(json);
}
