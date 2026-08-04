// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecipeImpl _$$RecipeImplFromJson(Map<String, dynamic> json) => _$RecipeImpl(
  id: json['id'] as String?,
  userId: json['user_id'] as String,
  name: json['name'] as String,
  ingredients:
      (json['ingredients'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  instructions: json['instructions'] as String?,
  calories: (json['calories'] as num?)?.toDouble() ?? 0,
  proteinG: (json['protein_g'] as num?)?.toDouble() ?? 0,
  carbsG: (json['carbs_g'] as num?)?.toDouble() ?? 0,
  fatG: (json['fat_g'] as num?)?.toDouble() ?? 0,
  imageUrl: json['image_url'] as String?,
  isFavorite: json['is_favorite'] as bool? ?? false,
);

Map<String, dynamic> _$$RecipeImplToJson(_$RecipeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'ingredients': instance.ingredients,
      'instructions': instance.instructions,
      'calories': instance.calories,
      'protein_g': instance.proteinG,
      'carbs_g': instance.carbsG,
      'fat_g': instance.fatG,
      'image_url': instance.imageUrl,
      'is_favorite': instance.isFavorite,
    };
