import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/exercise.dart';
import '../entities/workout.dart';
import '../entities/workout_log.dart';
import '../entities/workout_log_set.dart';
import '../entities/workout_schedule.dart';

abstract class WorkoutRepository {
  Future<Either<Failure, List<Exercise>>> getExerciseLibrary();

  Future<Either<Failure, Exercise>> createCustomExercise(
      Exercise exercise, String userId);

  Future<Either<Failure, List<Workout>>> getWorkouts(String userId);

  Future<Either<Failure, Workout>> saveWorkout(Workout workout);

  Future<Either<Failure, Unit>> deleteWorkout(String id);

  Future<Either<Failure, WorkoutLog>> logCompletion(
    WorkoutLog log, {
    List<WorkoutLogSet> sets = const [],
  });

  Future<Either<Failure, List<WorkoutLogSet>>> getRecentSetsForExercise(
    String userId,
    String exerciseId,
  );

  Future<Either<Failure, List<WorkoutLog>>> getLogs(String userId,
      {int days = 90});

  Future<Either<Failure, List<WorkoutSchedule>>> getSchedule(
    String userId, {
    required DateTime from,
    required DateTime to,
  });

  Future<Either<Failure, List<WorkoutSchedule>>> scheduleWorkout(
    List<WorkoutSchedule> entries,
  );

  Future<Either<Failure, Unit>> deleteScheduleEntry(String id);

  Future<Either<Failure, WorkoutSchedule>> updateScheduleStatus(
      String id, String status);
}
