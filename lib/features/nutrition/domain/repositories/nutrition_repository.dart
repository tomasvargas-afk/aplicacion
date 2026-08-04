import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/meal_log.dart';
import '../entities/recipe.dart';

abstract class NutritionRepository {
  Future<Either<Failure, List<Recipe>>> getRecipes(String userId);

  Future<Either<Failure, Recipe>> saveRecipe(Recipe recipe);

  Future<Either<Failure, Unit>> deleteRecipe(String id);

  Future<Either<Failure, List<MealLog>>> getMealLogs(String userId, {int days = 1});

  Future<Either<Failure, MealLog>> logMeal(MealLog log);

  Future<Either<Failure, Unit>> deleteMealLog(String id);
}
