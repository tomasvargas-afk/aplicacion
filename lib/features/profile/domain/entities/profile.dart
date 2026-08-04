import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    required String id,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'birth_date') DateTime? birthDate,
    String? sex,
    @JsonKey(name: 'height_cm') double? heightCm,
    @JsonKey(name: 'activity_level') String? activityLevel,
    String? goal,
    @JsonKey(name: 'weight_unit') @Default('kg') String weightUnit,
    @JsonKey(name: 'theme_preference') @Default('system') String themePreference,
    @Default('es') String locale,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
}

extension ProfileAge on Profile {
  int? get age {
    final birth = birthDate;
    if (birth == null) return null;
    final now = DateTime.now();
    var years = now.year - birth.year;
    if (now.month < birth.month || (now.month == birth.month && now.day < birth.day)) {
      years--;
    }
    return years;
  }
}
