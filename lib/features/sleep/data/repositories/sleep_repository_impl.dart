import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/sleep_log.dart';
import '../../domain/repositories/sleep_repository.dart';
import '../datasources/sleep_remote_datasource.dart';

class SleepRepositoryImpl implements SleepRepository {
  SleepRepositoryImpl(this._remote);

  final SleepRemoteDatasource _remote;

  @override
  Future<Either<Failure, List<SleepLog>>> getHistory(String userId, {int days = 14}) async {
    try {
      return Right(await _remote.getHistory(userId, days: days));
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SleepLog>> addLog(SleepLog log) async {
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
