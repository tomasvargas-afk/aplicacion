import '../entities/diet_plan_meal.dart';
import 'diet_calculator.dart';

/// Splits the daily macro targets across 4 meals and attaches an
/// illustrative example dish per meal. This is a rule-based suggestion,
/// not a real food database (barcode scanning / a full food DB is a
/// phase-2 extra) — good enough to show the user a concrete example menu.
abstract class GenerateSampleMenu {
  GenerateSampleMenu._();

  static const _distribution = {
    'breakfast': 0.25,
    'lunch': 0.35,
    'dinner': 0.30,
    'snack': 0.10,
  };

  static final _dishesByGoal = <DietGoal, Map<String, String>>{
    DietGoal.loseFat: {
      'breakfast': 'Claras de huevo revueltas con espinaca y avena',
      'lunch': 'Pechuga de pollo a la plancha, arroz integral y ensalada',
      'dinner': 'Pescado al horno con vegetales al vapor',
      'snack': 'Yogur griego natural con frutos rojos',
    },
    DietGoal.maintain: {
      'breakfast': 'Avena con fruta, huevo entero y almendras',
      'lunch': 'Arroz, pollo o carne magra y ensalada con aceite de oliva',
      'dinner': 'Pasta integral con atún y vegetales salteados',
      'snack': 'Fruta con un puñado de frutos secos',
    },
    DietGoal.gainMuscle: {
      'breakfast': 'Avena con leche, plátano, huevo entero y mantequilla de maní',
      'lunch': 'Doble porción de arroz, carne o pollo y palta',
      'dinner': 'Papa/batata, salmón o carne roja y vegetales',
      'snack': 'Batido de proteína con avena y fruta',
    },
    DietGoal.recomposition: {
      'breakfast': 'Huevos enteros con pan integral y fruta',
      'lunch': 'Quinoa, pollo a la plancha y vegetales variados',
      'dinner': 'Pescado o carne magra con ensalada abundante',
      'snack': 'Skyr o yogur proteico con frutos rojos',
    },
  };

  static List<DietPlanMeal> generate({
    required MacroResult macros,
    required DietGoal goal,
  }) {
    final dishes = _dishesByGoal[goal]!;
    return _distribution.entries.map((entry) {
      final mealType = entry.key;
      final share = entry.value;
      return DietPlanMeal(
        mealType: mealType,
        suggestedFood: dishes[mealType]!,
        calories: macros.dailyCalories * share,
        proteinG: macros.proteinG * share,
        carbsG: macros.carbsG * share,
        fatG: macros.fatG * share,
      );
    }).toList();
  }
}
