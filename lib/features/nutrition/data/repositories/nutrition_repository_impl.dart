import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/meal_log.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/repositories/nutrition_repository.dart';
import '../datasources/nutrition_remote_datasource.dart';

class NutritionRepositoryImpl implements NutritionRepository {
  NutritionRepositoryImpl(this._remote);

  final NutritionRemoteDatasource _remote;

  @override
  Future<Either<Failure, List<Recipe>>> getRecipes(String userId) async {
    try {
      return Right(await _remote.getRecipes(userId));
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Recipe>> saveRecipe(Recipe recipe) async {
    try {
      return Right(await _remote.saveRecipe(recipe));
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteRecipe(String id) async {
    try {
      await _remote.deleteRecipe(id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MealLog>>> getMealLogs(String userId, {int days = 1}) async {
    try {
      return Right(await _remote.getMealLogs(userId, days: days));
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MealLog>> logMeal(MealLog log) async {
    try {
      return Right(await _remote.logMeal(log));
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteMealLog(String id) async {
    try {
      await _remote.deleteMealLog(id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }
}
