import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/supabase_tables.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/meal_log.dart';
import '../../domain/entities/recipe.dart';

class NutritionRemoteDatasource {
  NutritionRemoteDatasource(this._client);

  final SupabaseClient _client;

  Future<List<Recipe>> getRecipes(String userId) async {
    try {
      final rows = await _client
          .from(SupabaseTables.recipes)
          .select()
          .eq('user_id', userId)
          .order('is_favorite', ascending: false)
          .order('name');
      return rows.map((row) => Recipe.fromJson(row)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<Recipe> saveRecipe(Recipe recipe) async {
    try {
      final payload = recipe.toJson()..removeWhere((key, value) => value == null);
      final row = recipe.id == null
          ? await _client.from(SupabaseTables.recipes).insert(payload).select().single()
          : await _client
              .from(SupabaseTables.recipes)
              .update(payload)
              .eq('id', recipe.id!)
              .select()
              .single();
      return Recipe.fromJson(row);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> deleteRecipe(String id) async {
    try {
      await _client.from(SupabaseTables.recipes).delete().eq('id', id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<List<MealLog>> getMealLogs(String userId, {int days = 1}) async {
    try {
      final since = DateTime.now().subtract(Duration(days: days));
      final rows = await _client
          .from(SupabaseTables.mealLogs)
          .select()
          .eq('user_id', userId)
          .gte('logged_at', since.toIso8601String())
          .order('logged_at');
      return rows.map((row) => MealLog.fromJson(row)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<MealLog> logMeal(MealLog log) async {
    try {
      final payload = log.toJson()..removeWhere((key, value) => value == null);
      final row =
          await _client.from(SupabaseTables.mealLogs).insert(payload).select().single();
      return MealLog.fromJson(row);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> deleteMealLog(String id) async {
    try {
      await _client.from(SupabaseTables.mealLogs).delete().eq('id', id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
