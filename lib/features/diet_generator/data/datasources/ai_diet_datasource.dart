import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/diet_plan_meal.dart';
import '../../domain/usecases/diet_calculator.dart';

/// Calls the `generate-diet-menu` Supabase Edge Function, which asks
/// Claude to design a realistic menu (real foods + gram quantities) that
/// matches the calorie/macro targets already computed client-side via
/// [DietCalculator]. This never touches the BMR/TDEE math itself.
class AiDietDatasource {
  AiDietDatasource(this._client);

  final SupabaseClient _client;

  Future<List<DietPlanMeal>> generateMenu({
    required MacroResult macros,
    required DietGoal goal,
  }) async {
    try {
      final response = await _client.functions.invoke(
        'generate-diet-menu',
        body: {
          'daily_calories': macros.dailyCalories,
          'protein_g': macros.proteinG,
          'carbs_g': macros.carbsG,
          'fat_g': macros.fatG,
          'goal': goal.dbValue,
        },
      );

      final data = response.data;
      final meals = data is Map ? data['meals'] : null;
      if (meals is! List || meals.isEmpty) {
        throw const ServerException('Respuesta inválida del generador de menú');
      }

      return meals.map((m) {
        final meal = m as Map;
        return DietPlanMeal(
          mealType: meal['meal_type'] as String,
          suggestedFood: meal['suggested_food'] as String,
          calories: _num(meal['calories']),
          proteinG: _num(meal['protein_g']),
          carbsG: _num(meal['carbs_g']),
          fatG: _num(meal['fat_g']),
        );
      }).toList();
    } on FunctionException catch (e) {
      if (e.status == 429) {
        throw const ServerException(
            'Alcanzaste el límite de generaciones por hora');
      }
      throw ServerException('Error del servicio de generación (${e.status})');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  double _num(dynamic value) {
    if (value is num) return value.toDouble();
    return 0;
  }
}
