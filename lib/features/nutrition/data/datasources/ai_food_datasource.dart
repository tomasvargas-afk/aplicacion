import 'dart:convert';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/ai_food_estimate.dart';

/// Calls the `analyze-food` Supabase Edge Function, which proxies the photo
/// to Claude's vision API server-side (keeps the Anthropic key off the
/// client).
class AiFoodDatasource {
  AiFoodDatasource(this._client);

  final SupabaseClient _client;

  Future<AiFoodEstimate> analyze(Uint8List imageBytes, {required String mediaType}) async {
    try {
      final response = await _client.functions.invoke(
        'analyze-food',
        body: {'image_base64': base64Encode(imageBytes), 'media_type': mediaType},
      );

      final data = response.data;
      if (data is! Map || data['food_name'] == null) {
        throw const ServerException('Respuesta inválida del servicio de análisis');
      }

      return AiFoodEstimate(
        name: data['food_name'] as String,
        calories: _num(data['calories']),
        proteinG: _num(data['protein_g']),
        carbsG: _num(data['carbs_g']),
        fatG: _num(data['fat_g']),
      );
    } on FunctionException catch (e) {
      if (e.status == 422) {
        throw const ServerException('No se pudo identificar la comida en la foto');
      }
      throw ServerException('Error del servicio de análisis (${e.status})');
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
