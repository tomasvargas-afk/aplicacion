import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/water_log.dart';

abstract class WaterRepository {
  /// Logs for the last [days] days (used for today's total and the trend chart).
  Future<Either<Failure, List<WaterLog>>> getRecentLogs(String userId, {int days = 7});

  Future<Either<Failure, WaterLog>> addLog(WaterLog log);

  Future<Either<Failure, Unit>> deleteLog(String id);
}
