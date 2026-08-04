import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe.freezed.dart';
part 'recipe.g.dart';

@freezed
abstract class Recipe with _$Recipe {
  const factory Recipe({
    String? id,
    @JsonKey(name: 'user_id') required String userId,
    required String name,
    @Default(<String>[]) List<String> ingredients,
    String? instructions,
    @Default(0) double calories,
    @JsonKey(name: 'protein_g') @Default(0) double proteinG,
    @JsonKey(name: 'carbs_g') @Default(0) double carbsG,
    @JsonKey(name: 'fat_g') @Default(0) double fatG,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'is_favorite') @Default(false) bool isFavorite,
  }) = _Recipe;

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
}
