import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/barcode_food_result.dart';

/// Looks up packaged-food nutrition facts by barcode via the free,
/// keyless Open Food Facts API (https://openfoodfacts.org).
class OpenFoodFactsDatasource {
  static const _baseUrl = 'https://world.openfoodfacts.org/api/v2/product';

  Future<BarcodeFoodResult> lookup(String barcode) async {
    final uri = Uri.parse(
      '$_baseUrl/$barcode.json?fields=product_name,product_name_en,nutriments',
    );
    final http.Response response;
    try {
      response = await http.get(uri).timeout(const Duration(seconds: 10));
    } catch (e) {
      throw NetworkException(e.toString());
    }

    if (response.statusCode != 200) {
      throw ServerException('Error del servidor (${response.statusCode})');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (body['status'] != 1 || body['product'] == null) {
      throw const NotFoundException('Producto no encontrado para este código de barras');
    }

    final product = body['product'] as Map<String, dynamic>;
    final nutriments = (product['nutriments'] as Map<String, dynamic>?) ?? const {};

    final name = (product['product_name'] as String?)?.trim().isNotEmpty == true
        ? product['product_name'] as String
        : (product['product_name_en'] as String?) ?? 'Producto sin nombre';

    return BarcodeFoodResult(
      barcode: barcode,
      name: name,
      calories: _kcal(nutriments),
      proteinG: _num(nutriments['proteins_100g']),
      carbsG: _num(nutriments['carbohydrates_100g']),
      fatG: _num(nutriments['fat_100g']),
    );
  }

  double _num(dynamic value) {
    if (value is num) return value.toDouble();
    return 0;
  }

  /// Prefers `energy-kcal_100g`; falls back to converting `energy_100g`
  /// (kJ) when only that is present.
  double _kcal(Map<String, dynamic> nutriments) {
    final kcal = nutriments['energy-kcal_100g'];
    if (kcal is num) return kcal.toDouble();
    final kj = nutriments['energy_100g'];
    if (kj is num) return kj / 4.184;
    return 0;
  }
}
