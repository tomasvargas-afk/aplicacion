import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/supabase_tables.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/date_utils.dart';
import '../../domain/entities/sleep_log.dart';

class SleepRemoteDatasource {
  SleepRemoteDatasource(this._client);

  final SupabaseClient _client;

  Future<List<SleepLog>> getHistory(String userId, {int days = 14}) async {
    try {
      final since = AppDateUtils.formatIso(
        DateTime.now().subtract(Duration(days: days - 1)),
      );
      final rows = await _client
          .from(SupabaseTables.sleepLogs)
          .select()
          .eq('user_id', userId)
          .gte('sleep_date', since)
          .order('sleep_date');
      return rows.map((row) => SleepLog.fromJson(row)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<SleepLog> addLog(SleepLog log) async {
    try {
      final payload = log.toJson()..removeWhere((key, value) => value == null);
      payload['sleep_date'] = AppDateUtils.formatIso(log.sleepDate);
      final row =
          await _client.from(SupabaseTables.sleepLogs).insert(payload).select().single();
      return SleepLog.fromJson(row);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> deleteLog(String id) async {
    try {
      await _client.from(SupabaseTables.sleepLogs).delete().eq('id', id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
