import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/body_measurement.dart';

abstract class BodyTrackingRepository {
  Future<Either<Failure, List<BodyMeasurement>>> getHistory(String userId);

  Future<Either<Failure, BodyMeasurement>> addMeasurement(
    BodyMeasurement measurement,
  );

  Future<Either<Failure, Unit>> deleteMeasurement(String id);
}
