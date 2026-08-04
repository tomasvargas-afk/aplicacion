import 'package:freezed_annotation/freezed_annotation.dart';

part 'meal_log.freezed.dart';
part 'meal_log.g.dart';

@freezed
abstract class MealLog with _$MealLog {
  const factory MealLog({
    String? id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'custom_name') required String customName,
    @JsonKey(name: 'meal_type') required String mealType,
    @Default(0) double calories,
    @JsonKey(name: 'protein_g') @Default(0) double proteinG,
    @JsonKey(name: 'carbs_g') @Default(0) double carbsG,
    @JsonKey(name: 'fat_g') @Default(0) double fatG,
    @JsonKey(name: 'logged_at') DateTime? loggedAt,
  }) = _MealLog;

  factory MealLog.fromJson(Map<String, dynamic> json) => _$MealLogFromJson(json);
}

const mealTypeLabels = {
  'breakfast': 'Desayuno',
  'lunch': 'Almuerzo',
  'dinner': 'Cena',
  'snack': 'Snack',
};

/// Maps the dashboard's free-text meal-slot heuristic to the DB's
/// `meal_type` enum values.
String mealSlotToType(String slot) => switch (slot) {
      'Desayuno' => 'breakfast',
      'Almuerzo' => 'lunch',
      'Cena' => 'dinner',
      _ => 'snack',
    };
