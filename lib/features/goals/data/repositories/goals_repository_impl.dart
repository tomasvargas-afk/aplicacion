import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/goal.dart';
import '../../domain/repositories/goals_repository.dart';
import '../datasources/goals_remote_datasource.dart';

class GoalsRepositoryImpl implements GoalsRepository {
  GoalsRepositoryImpl(this._remote);

  final GoalsRemoteDatasource _remote;

  @override
  Future<Either<Failure, List<Goal>>> getGoals(String userId) async {
    try {
      return Right(await _remote.getGoals(userId));
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Goal>> saveGoal(Goal goal) async {
    try {
      return Right(await _remote.saveGoal(goal));
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteGoal(String id) async {
    try {
      await _remote.deleteGoal(id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }
}
