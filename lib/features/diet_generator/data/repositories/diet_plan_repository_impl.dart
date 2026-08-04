import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/diet_plan.dart';
import '../../domain/repositories/diet_plan_repository.dart';
import '../datasources/diet_plan_remote_datasource.dart';

class DietPlanRepositoryImpl implements DietPlanRepository {
  DietPlanRepositoryImpl(this._remote);

  final DietPlanRemoteDatasource _remote;

  @override
  Future<Either<Failure, List<DietPlan>>> getHistory(String userId) async {
    try {
      return Right(await _remote.getHistory(userId));
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DietPlan>> savePlan(DietPlan plan) async {
    try {
      return Right(await _remote.savePlan(plan));
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePlan(String id) async {
    try {
      await _remote.deletePlan(id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }
}
