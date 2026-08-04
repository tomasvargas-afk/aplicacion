import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/workout.dart';
import '../../domain/entities/workout_log.dart';
import '../../domain/entities/workout_schedule.dart';
import '../../domain/repositories/workout_repository.dart';
import '../datasources/workout_remote_datasource.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  WorkoutRepositoryImpl(this._remote);

  final WorkoutRemoteDatasource _remote;

  @override
  Future<Either<Failure, List<Exercise>>> getExerciseLibrary() async {
    try {
      return Right(await _remote.getExerciseLibrary());
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Workout>>> getWorkouts(String userId) async {
    try {
      return Right(await _remote.getWorkouts(userId));
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Workout>> saveWorkout(Workout workout) async {
    try {
      return Right(await _remote.saveWorkout(workout));
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteWorkout(String id) async {
    try {
      await _remote.deleteWorkout(id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WorkoutLog>> logCompletion(WorkoutLog log) async {
    try {
      return Right(await _remote.logCompletion(log));
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WorkoutLog>>> getLogs(String userId, {int days = 90}) async {
    try {
      return Right(await _remote.getLogs(userId, days: days));
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WorkoutSchedule>>> getSchedule(
    String userId, {
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      return Right(await _remote.getSchedule(userId, from: from, to: to));
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WorkoutSchedule>>> scheduleWorkout(
    List<WorkoutSchedule> entries,
  ) async {
    try {
      return Right(await _remote.scheduleWorkout(entries));
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteScheduleEntry(String id) async {
    try {
      await _remote.deleteScheduleEntry(id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WorkoutSchedule>> updateScheduleStatus(
    String id,
    String status,
  ) async {
    try {
      return Right(await _remote.updateScheduleStatus(id, status));
    } on ServerException catch (e) {
      return Left(Failure.server(e.message));
    } catch (e) {
      return Left(Failure.unknown(e.toString()));
    }
  }
}
