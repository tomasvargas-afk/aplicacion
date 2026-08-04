import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/goal.dart';

abstract class GoalsRepository {
  Future<Either<Failure, List<Goal>>> getGoals(String userId);

  Future<Either<Failure, Goal>> saveGoal(Goal goal);

  Future<Either<Failure, Unit>> deleteGoal(String id);
}
