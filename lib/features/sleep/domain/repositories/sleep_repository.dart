import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/sleep_log.dart';

abstract class SleepRepository {
  Future<Either<Failure, List<SleepLog>>> getHistory(String userId, {int days = 14});

  Future<Either<Failure, SleepLog>> addLog(SleepLog log);

  Future<Either<Failure, Unit>> deleteLog(String id);
}
