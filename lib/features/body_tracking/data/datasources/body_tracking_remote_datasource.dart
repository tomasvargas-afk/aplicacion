import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/supabase_tables.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/body_measurement.dart';

class BodyTrackingRemoteDatasource {
  BodyTrackingRemoteDatasource(this._client);

  final SupabaseClient _client;

  Future<List<BodyMeasurement>> getHistory(String userId) async {
    try {
      final rows = await _client
          .from(SupabaseTables.bodyMeasurements)
          .select()
          .eq('user_id', userId)
          .order('measured_at');
      return rows.map((row) => BodyMeasurement.fromJson(row)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<BodyMeasurement> addMeasurement(BodyMeasurement measurement) async {
    try {
      final payload = measurement.toJson()..removeWhere((key, value) => value == null);
      final row = await _client
          .from(SupabaseTables.bodyMeasurements)
          .insert(payload)
          .select()
          .single();
      return BodyMeasurement.fromJson(row);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> deleteMeasurement(String id) async {
    try {
      await _client.from(SupabaseTables.bodyMeasurements).delete().eq('id', id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
