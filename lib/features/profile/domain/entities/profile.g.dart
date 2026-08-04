// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileImpl _$$ProfileImplFromJson(Map<String, dynamic> json) =>
    _$ProfileImpl(
      id: json['id'] as String,
      fullName: json['full_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      birthDate: json['birth_date'] == null
          ? null
          : DateTime.parse(json['birth_date'] as String),
      sex: json['sex'] as String?,
      heightCm: (json['height_cm'] as num?)?.toDouble(),
      activityLevel: json['activity_level'] as String?,
      goal: json['goal'] as String?,
      weightUnit: json['weight_unit'] as String? ?? 'kg',
      themePreference: json['theme_preference'] as String? ?? 'system',
      locale: json['locale'] as String? ?? 'es',
    );

Map<String, dynamic> _$$ProfileImplToJson(_$ProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'avatar_url': instance.avatarUrl,
      'birth_date': instance.birthDate?.toIso8601String(),
      'sex': instance.sex,
      'height_cm': instance.heightCm,
      'activity_level': instance.activityLevel,
      'goal': instance.goal,
      'weight_unit': instance.weightUnit,
      'theme_preference': instance.themePreference,
      'locale': instance.locale,
    };
