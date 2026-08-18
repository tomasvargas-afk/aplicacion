import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/workout_log_set.dart';

class ProgressionSuggestion {
  const ProgressionSuggestion({
    required this.text,
    required this.suggestedWeightKg,
    required this.suggestedReps,
  });

  final String text;
  final double suggestedWeightKg;
  final int suggestedReps;
}

/// Calls the `suggest-progression` Supabase Edge Function, which asks
/// Claude to read the trend across recent sets (progress, plateau, missed
/// reps) and suggest a next-session target — not something a fixed
/// percentage-bump formula captures well.
class AiProgressionDatasource {
  AiProgressionDatasource(this._client);

  final SupabaseClient _client;

  Future<ProgressionSuggestion> suggest({
    required String exerciseName,
    required List<WorkoutLogSet> recentSets,
  }) async {
    try {
      final response = await _client.functions.invoke(
        'suggest-progression',
        body: {
          'exercise_name': exerciseName,
          'recent_sets': recentSets
              .map((s) => {'reps_done': s.repsDone, 'weight_kg': s.weightKg})
              .toList(),
        },
      );

      final data = response.data;
      if (data is! Map || data['suggestion_text'] == null) {
        throw const ServerException(
            'Respuesta inválida del servicio de sugerencias');
      }

      return ProgressionSuggestion(
        text: data['suggestion_text'] as String,
        suggestedWeightKg: _num(data['suggested_weight_kg']),
        suggestedReps: _num(data['suggested_reps']).round(),
      );
    } on FunctionException catch (e) {
      if (e.status == 429) {
        throw const ServerException(
            'Alcanzaste el límite de sugerencias por hora');
      }
      if (e.status == 400) {
        throw const ServerException(
            'No hay suficiente historial para este ejercicio');
      }
      throw ServerException('Error del servicio de sugerencias (${e.status})');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  double _num(dynamic value) {
    if (value is num) return value.toDouble();
    return 0;
  }
}
