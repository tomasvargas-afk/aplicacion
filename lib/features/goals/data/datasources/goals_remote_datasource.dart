import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/supabase_tables.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/goal.dart';

class GoalsRemoteDatasource {
  GoalsRemoteDatasource(this._client);

  final SupabaseClient _client;

  Future<List<Goal>> getGoals(String userId) async {
    try {
      final rows = await _client
          .from(SupabaseTables.goals)
          .select()
          .eq('user_id', userId)
          .order('created_at');
      return rows.map((row) => Goal.fromJson(row)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<Goal> saveGoal(Goal goal) async {
    try {
      final payload = goal.toJson()..removeWhere((key, value) => value == null);
      final row = goal.id == null
          ? await _client.from(SupabaseTables.goals).insert(payload).select().single()
          : await _client
              .from(SupabaseTables.goals)
              .update(payload)
              .eq('id', goal.id!)
              .select()
              .single();
      return Goal.fromJson(row);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> deleteGoal(String id) async {
    try {
      await _client.from(SupabaseTables.goals).delete().eq('id', id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
