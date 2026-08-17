import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/supabase_tables.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/workout.dart';
import '../../domain/entities/workout_exercise.dart';
import '../../domain/entities/workout_log.dart';
import '../../domain/entities/workout_schedule.dart';

class WorkoutRemoteDatasource {
  WorkoutRemoteDatasource(this._client);

  final SupabaseClient _client;

  Future<List<Exercise>> getExerciseLibrary() async {
    try {
      final rows = await _client
          .from(SupabaseTables.exercisesLibrary)
          .select()
          .order('name');
      return rows.map((row) => Exercise.fromJson(row)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<Exercise> createCustomExercise(Exercise exercise,
      {required String userId}) async {
    try {
      final payload = exercise.toJson()
        ..removeWhere((key, value) => value == null)
        ..['is_custom'] = true
        ..['created_by'] = userId;
      final row = await _client
          .from(SupabaseTables.exercisesLibrary)
          .insert(payload)
          .select()
          .single();
      return Exercise.fromJson(row);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<List<Workout>> getWorkouts(String userId) async {
    try {
      final rows = await _client
          .from(SupabaseTables.workouts)
          .select('*, workout_exercises(*, exercises_library(*))')
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return rows.map((row) => Workout.fromJson(row)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<Workout> saveWorkout(Workout workout) async {
    try {
      final workoutPayload = workout.toJson()
        ..removeWhere((key, value) => value == null);
      final savedWorkoutRow = await _client
          .from(SupabaseTables.workouts)
          .insert(workoutPayload)
          .select()
          .single();
      final savedWorkout = Workout.fromJson(savedWorkoutRow);

      if (workout.exercises.isNotEmpty) {
        final exercisesPayload = workout.exercises.asMap().entries.map((entry) {
          final exercise = entry.value;
          final json = exercise.toJson()
            ..removeWhere((key, value) => value == null);
          json['workout_id'] = savedWorkout.id;
          json['order_index'] = entry.key;
          return json;
        }).toList();

        final savedExerciseRows = await _client
            .from(SupabaseTables.workoutExercises)
            .insert(exercisesPayload)
            .select('*, exercises_library(*)');
        return savedWorkout.copyWith(
          exercises: savedExerciseRows
              .map((row) => WorkoutExercise.fromJson(row))
              .toList(),
        );
      }
      return savedWorkout;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> deleteWorkout(String id) async {
    try {
      await _client.from(SupabaseTables.workouts).delete().eq('id', id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<WorkoutLog> logCompletion(WorkoutLog log) async {
    try {
      final payload = log.toJson()..removeWhere((key, value) => value == null);
      final row = await _client
          .from(SupabaseTables.workoutLogs)
          .insert(payload)
          .select()
          .single();
      return WorkoutLog.fromJson(row);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<List<WorkoutLog>> getLogs(String userId, {int days = 90}) async {
    try {
      final since = DateTime.now().subtract(Duration(days: days));
      final rows = await _client
          .from(SupabaseTables.workoutLogs)
          .select()
          .eq('user_id', userId)
          .gte('completed_at', since.toIso8601String())
          .order('completed_at');
      return rows.map((row) => WorkoutLog.fromJson(row)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  String _dateOnly(DateTime date) => date.toIso8601String().split('T').first;

  /// Mirrors the join used by [getWorkouts] so a schedule entry's `workout`
  /// carries its exercises too (needed to open it from [WorkoutDetailScreen]).
  static const _scheduleSelect =
      '*, workouts(*, workout_exercises(*, exercises_library(*)))';

  Future<List<WorkoutSchedule>> getSchedule(
    String userId, {
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final rows = await _client
          .from(SupabaseTables.workoutSchedule)
          .select(_scheduleSelect)
          .eq('user_id', userId)
          .gte('scheduled_date', _dateOnly(from))
          .lte('scheduled_date', _dateOnly(to))
          .order('scheduled_date');
      return rows.map((row) => WorkoutSchedule.fromJson(row)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<List<WorkoutSchedule>> scheduleWorkout(
      List<WorkoutSchedule> entries) async {
    try {
      final payload = entries.map((entry) {
        final json = entry.toJson()..removeWhere((key, value) => value == null);
        json['scheduled_date'] = _dateOnly(entry.scheduledDate);
        return json;
      }).toList();
      final rows = await _client
          .from(SupabaseTables.workoutSchedule)
          .insert(payload)
          .select(_scheduleSelect);
      return rows.map((row) => WorkoutSchedule.fromJson(row)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> deleteScheduleEntry(String id) async {
    try {
      await _client.from(SupabaseTables.workoutSchedule).delete().eq('id', id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<WorkoutSchedule> updateScheduleStatus(String id, String status) async {
    try {
      final row = await _client
          .from(SupabaseTables.workoutSchedule)
          .update({'status': status})
          .eq('id', id)
          .select(_scheduleSelect)
          .single();
      return WorkoutSchedule.fromJson(row);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
