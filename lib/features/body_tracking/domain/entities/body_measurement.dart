import 'package:freezed_annotation/freezed_annotation.dart';

part 'body_measurement.freezed.dart';
part 'body_measurement.g.dart';

/// A single body-tracking entry. Doubles as the Supabase row model — see
/// the pragmatic note in the project README about skipping a separate
/// data-layer `*Model` class for simple CRUD features.
@freezed
abstract class BodyMeasurement with _$BodyMeasurement {
  const factory BodyMeasurement({
    String? id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'measured_at') required DateTime measuredAt,
    @JsonKey(name: 'weight_kg') double? weightKg,
    @JsonKey(name: 'body_fat_percent') double? bodyFatPercent,
    @JsonKey(name: 'muscle_mass_percent') double? muscleMassPercent,
    @JsonKey(name: 'chest_cm') double? chestCm,
    @JsonKey(name: 'waist_cm') double? waistCm,
    @JsonKey(name: 'hip_cm') double? hipCm,
    @JsonKey(name: 'arm_cm') double? armCm,
    @JsonKey(name: 'thigh_cm') double? thighCm,
    @JsonKey(name: 'photo_path') String? photoPath,
    String? notes,
  }) = _BodyMeasurement;

  factory BodyMeasurement.fromJson(Map<String, dynamic> json) =>
      _$BodyMeasurementFromJson(json);
}
