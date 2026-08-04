import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/diet_plan.dart';

abstract class DietPlanRepository {
  Future<Either<Failure, List<DietPlan>>> getHistory(String userId);

  Future<Either<Failure, DietPlan>> savePlan(DietPlan plan);

  Future<Either<Failure, Unit>> deletePlan(String id);
}
