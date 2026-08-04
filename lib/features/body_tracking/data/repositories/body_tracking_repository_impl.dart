import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/body_measurement.dart';
import '../../domain/repositories/body_tracking_repository.dart';
import '../datasources/body_tracking_remote_datasource.dart';

class BodyTrackingRepositoryImpl implements BodyTrackingRepository {
  BodyTrackingRepositoryImpl(this._remote);

  final BodyTrackingRemoteDatasource _remote;

  @override
  Future<Either<Failure, List<BodyMeasurement>>> getHistory(String userId) async {
    try {
      return Right(await _remote.getHistory(userId));
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BodyMeasurement>> addMeasurement(
    BodyMeasurement measurement,
  ) async {
    try {
      return Right(await _remote.addMeasurement(measurement));
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteMeasurement(String id) async {
    try {
      await _remote.deleteMeasurement(id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }
}
