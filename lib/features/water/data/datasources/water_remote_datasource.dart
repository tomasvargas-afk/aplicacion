import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/supabase_tables.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/date_utils.dart';
import '../../domain/entities/water_log.dart';

class WaterRemoteDatasource {
  WaterRemoteDatasource(this._client);

  final SupabaseClient _client;

  Future<List<WaterLog>> getRecentLogs(String userId, {int days = 7}) async {
    try {
      final since = AppDateUtils.formatIso(
        DateTime.now().subtract(Duration(days: days - 1)),
      );
      final rows = await _client
          .from(SupabaseTables.waterLogs)
          .select()
          .eq('user_id', userId)
          .gte('logged_date', since)
          .order('logged_date');
      return rows.map((row) => WaterLog.fromJson(row)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<WaterLog> addLog(WaterLog log) async {
    try {
      final payload = log.toJson()..removeWhere((key, value) => value == null);
      payload['logged_date'] = AppDateUtils.formatIso(log.loggedDate);
      final row = await _client
          .from(SupabaseTables.waterLogs)
          .insert(payload)
          .select()
          .single();
      return WaterLog.fromJson(row);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> deleteLog(String id) async {
    try {
      await _client.from(SupabaseTables.waterLogs).delete().eq('id', id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
