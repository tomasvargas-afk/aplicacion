import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/water_log.dart';
import '../../domain/repositories/water_repository.dart';
import '../datasources/water_remote_datasource.dart';

class WaterRepositoryImpl implements WaterRepository {
  WaterRepositoryImpl(this._remote);

  final WaterRemoteDatasource _remote;

  @override
  Future<Either<Failure, List<WaterLog>>> getRecentLogs(String userId, {int days = 7}) async {
    try {
      return Right(await _remote.getRecentLogs(userId, days: days));
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WaterLog>> addLog(WaterLog log) async {
    try {
      return Right(await _remote.addLog(log));
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteLog(String id) async {
    try {
      await _remote.deleteLog(id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }
}
