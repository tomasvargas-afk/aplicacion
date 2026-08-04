import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/supabase_tables.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/diet_plan.dart';
import '../../domain/entities/diet_plan_meal.dart';

class DietPlanRemoteDatasource {
  DietPlanRemoteDatasource(this._client);

  final SupabaseClient _client;

  Future<List<DietPlan>> getHistory(String userId) async {
    try {
      final rows = await _client
          .from(SupabaseTables.dietPlans)
          .select('*, diet_plan_meals(*)')
          .eq('user_id', userId)
          .order('generated_at', ascending: false);
      return rows.map((row) => DietPlan.fromJson(row)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<DietPlan> savePlan(DietPlan plan) async {
    try {
      final planPayload = plan.toJson()..removeWhere((key, value) => value == null);
      final savedPlanRow = await _client
          .from(SupabaseTables.dietPlans)
          .insert(planPayload)
          .select()
          .single();
      final savedPlan = DietPlan.fromJson(savedPlanRow);

      if (plan.meals.isNotEmpty) {
        final mealsPayload = plan.meals
            .map((m) => m.toJson()
              ..removeWhere((key, value) => value == null)
              ..['diet_plan_id'] = savedPlan.id)
            .toList();
        final savedMealRows = await _client
            .from(SupabaseTables.dietPlanMeals)
            .insert(mealsPayload)
            .select();
        return savedPlan.copyWith(
          meals: savedMealRows.map((row) => DietPlanMeal.fromJson(row)).toList(),
        );
      }
      return savedPlan;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> deletePlan(String id) async {
    try {
      await _client.from(SupabaseTables.dietPlans).delete().eq('id', id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
