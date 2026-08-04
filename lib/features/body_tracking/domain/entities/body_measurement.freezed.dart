// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'body_measurement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BodyMeasurement _$BodyMeasurementFromJson(Map<String, dynamic> json) {
  return _BodyMeasurement.fromJson(json);
}

/// @nodoc
mixin _$BodyMeasurement {
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'measured_at')
  DateTime get measuredAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'weight_kg')
  double? get weightKg => throw _privateConstructorUsedError;
  @JsonKey(name: 'body_fat_percent')
  double? get bodyFatPercent => throw _privateConstructorUsedError;
  @JsonKey(name: 'muscle_mass_percent')
  double? get muscleMassPercent => throw _privateConstructorUsedError;
  @JsonKey(name: 'chest_cm')
  double? get chestCm => throw _privateConstructorUsedError;
  @JsonKey(name: 'waist_cm')
  double? get waistCm => throw _privateConstructorUsedError;
  @JsonKey(name: 'hip_cm')
  double? get hipCm => throw _privateConstructorUsedError;
  @JsonKey(name: 'arm_cm')
  double? get armCm => throw _privateConstructorUsedError;
  @JsonKey(name: 'thigh_cm')
  double? get thighCm => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this BodyMeasurement to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BodyMeasurement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BodyMeasurementCopyWith<BodyMeasurement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BodyMeasurementCopyWith<$Res> {
  factory $BodyMeasurementCopyWith(
    BodyMeasurement value,
    $Res Function(BodyMeasurement) then,
  ) = _$BodyMeasurementCopyWithImpl<$Res, BodyMeasurement>;
  @useResult
  $Res call({
    String? id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'measured_at') DateTime measuredAt,
    @JsonKey(name: 'weight_kg') double? weightKg,
    @JsonKey(name: 'body_fat_percent') double? bodyFatPercent,
    @JsonKey(name: 'muscle_mass_percent') double? muscleMassPercent,
    @JsonKey(name: 'chest_cm') double? chestCm,
    @JsonKey(name: 'waist_cm') double? waistCm,
    @JsonKey(name: 'hip_cm') double? hipCm,
    @JsonKey(name: 'arm_cm') double? armCm,
    @JsonKey(name: 'thigh_cm') double? thighCm,
    String? notes,
  });
}

/// @nodoc
class _$BodyMeasurementCopyWithImpl<$Res, $Val extends BodyMeasurement>
    implements $BodyMeasurementCopyWith<$Res> {
  _$BodyMeasurementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BodyMeasurement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = null,
    Object? measuredAt = null,
    Object? weightKg = freezed,
    Object? bodyFatPercent = freezed,
    Object? muscleMassPercent = freezed,
    Object? chestCm = freezed,
    Object? waistCm = freezed,
    Object? hipCm = freezed,
    Object? armCm = freezed,
    Object? thighCm = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            measuredAt: null == measuredAt
                ? _value.measuredAt
                : measuredAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            weightKg: freezed == weightKg
                ? _value.weightKg
                : weightKg // ignore: cast_nullable_to_non_nullable
                      as double?,
            bodyFatPercent: freezed == bodyFatPercent
                ? _value.bodyFatPercent
                : bodyFatPercent // ignore: cast_nullable_to_non_nullable
                      as double?,
            muscleMassPercent: freezed == muscleMassPercent
                ? _value.muscleMassPercent
                : muscleMassPercent // ignore: cast_nullable_to_non_nullable
                      as double?,
            chestCm: freezed == chestCm
                ? _value.chestCm
                : chestCm // ignore: cast_nullable_to_non_nullable
                      as double?,
            waistCm: freezed == waistCm
                ? _value.waistCm
                : waistCm // ignore: cast_nullable_to_non_nullable
                      as double?,
            hipCm: freezed == hipCm
                ? _value.hipCm
                : hipCm // ignore: cast_nullable_to_non_nullable
                      as double?,
            armCm: freezed == armCm
                ? _value.armCm
                : armCm // ignore: cast_nullable_to_non_nullable
                      as double?,
            thighCm: freezed == thighCm
                ? _value.thighCm
                : thighCm // ignore: cast_nullable_to_non_nullable
                      as double?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BodyMeasurementImplCopyWith<$Res>
    implements $BodyMeasurementCopyWith<$Res> {
  factory _$$BodyMeasurementImplCopyWith(
    _$BodyMeasurementImpl value,
    $Res Function(_$BodyMeasurementImpl) then,
  ) = __$$BodyMeasurementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'measured_at') DateTime measuredAt,
    @JsonKey(name: 'weight_kg') double? weightKg,
    @JsonKey(name: 'body_fat_percent') double? bodyFatPercent,
    @JsonKey(name: 'muscle_mass_percent') double? muscleMassPercent,
    @JsonKey(name: 'chest_cm') double? chestCm,
    @JsonKey(name: 'waist_cm') double? waistCm,
    @JsonKey(name: 'hip_cm') double? hipCm,
    @JsonKey(name: 'arm_cm') double? armCm,
    @JsonKey(name: 'thigh_cm') double? thighCm,
    String? notes,
  });
}

/// @nodoc
class __$$BodyMeasurementImplCopyWithImpl<$Res>
    extends _$BodyMeasurementCopyWithImpl<$Res, _$BodyMeasurementImpl>
    implements _$$BodyMeasurementImplCopyWith<$Res> {
  __$$BodyMeasurementImplCopyWithImpl(
    _$BodyMeasurementImpl _value,
    $Res Function(_$BodyMeasurementImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BodyMeasurement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = null,
    Object? measuredAt = null,
    Object? weightKg = freezed,
    Object? bodyFatPercent = freezed,
    Object? muscleMassPercent = freezed,
    Object? chestCm = freezed,
    Object? waistCm = freezed,
    Object? hipCm = freezed,
    Object? armCm = freezed,
    Object? thighCm = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$BodyMeasurementImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        measuredAt: null == measuredAt
            ? _value.measuredAt
            : measuredAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        weightKg: freezed == weightKg
            ? _value.weightKg
            : weightKg // ignore: cast_nullable_to_non_nullable
                  as double?,
        bodyFatPercent: freezed == bodyFatPercent
            ? _value.bodyFatPercent
            : bodyFatPercent // ignore: cast_nullable_to_non_nullable
                  as double?,
        muscleMassPercent: freezed == muscleMassPercent
            ? _value.muscleMassPercent
            : muscleMassPercent // ignore: cast_nullable_to_non_nullable
                  as double?,
        chestCm: freezed == chestCm
            ? _value.chestCm
            : chestCm // ignore: cast_nullable_to_non_nullable
                  as double?,
        waistCm: freezed == waistCm
            ? _value.waistCm
            : waistCm // ignore: cast_nullable_to_non_nullable
                  as double?,
        hipCm: freezed == hipCm
            ? _value.hipCm
            : hipCm // ignore: cast_nullable_to_non_nullable
                  as double?,
        armCm: freezed == armCm
            ? _value.armCm
            : armCm // ignore: cast_nullable_to_non_nullable
                  as double?,
        thighCm: freezed == thighCm
            ? _value.thighCm
            : thighCm // ignore: cast_nullable_to_non_nullable
                  as double?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BodyMeasurementImpl implements _BodyMeasurement {
  const _$BodyMeasurementImpl({
    this.id,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'measured_at') required this.measuredAt,
    @JsonKey(name: 'weight_kg') this.weightKg,
    @JsonKey(name: 'body_fat_percent') this.bodyFatPercent,
    @JsonKey(name: 'muscle_mass_percent') this.muscleMassPercent,
    @JsonKey(name: 'chest_cm') this.chestCm,
    @JsonKey(name: 'waist_cm') this.waistCm,
    @JsonKey(name: 'hip_cm') this.hipCm,
    @JsonKey(name: 'arm_cm') this.armCm,
    @JsonKey(name: 'thigh_cm') this.thighCm,
    this.notes,
  });

  factory _$BodyMeasurementImpl.fromJson(Map<String, dynamic> json) =>
      _$$BodyMeasurementImplFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'measured_at')
  final DateTime measuredAt;
  @override
  @JsonKey(name: 'weight_kg')
  final double? weightKg;
  @override
  @JsonKey(name: 'body_fat_percent')
  final double? bodyFatPercent;
  @override
  @JsonKey(name: 'muscle_mass_percent')
  final double? muscleMassPercent;
  @override
  @JsonKey(name: 'chest_cm')
  final double? chestCm;
  @override
  @JsonKey(name: 'waist_cm')
  final double? waistCm;
  @override
  @JsonKey(name: 'hip_cm')
  final double? hipCm;
  @override
  @JsonKey(name: 'arm_cm')
  final double? armCm;
  @override
  @JsonKey(name: 'thigh_cm')
  final double? thighCm;
  @override
  final String? notes;

  @override
  String toString() {
    return 'BodyMeasurement(id: $id, userId: $userId, measuredAt: $measuredAt, weightKg: $weightKg, bodyFatPercent: $bodyFatPercent, muscleMassPercent: $muscleMassPercent, chestCm: $chestCm, waistCm: $waistCm, hipCm: $hipCm, armCm: $armCm, thighCm: $thighCm, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BodyMeasurementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.measuredAt, measuredAt) ||
                other.measuredAt == measuredAt) &&
            (identical(other.weightKg, weightKg) ||
                other.weightKg == weightKg) &&
            (identical(other.bodyFatPercent, bodyFatPercent) ||
                other.bodyFatPercent == bodyFatPercent) &&
            (identical(other.muscleMassPercent, muscleMassPercent) ||
                other.muscleMassPercent == muscleMassPercent) &&
            (identical(other.chestCm, chestCm) || other.chestCm == chestCm) &&
            (identical(other.waistCm, waistCm) || other.waistCm == waistCm) &&
            (identical(other.hipCm, hipCm) || other.hipCm == hipCm) &&
            (identical(other.armCm, armCm) || other.armCm == armCm) &&
            (identical(other.thighCm, thighCm) || other.thighCm == thighCm) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    measuredAt,
    weightKg,
    bodyFatPercent,
    muscleMassPercent,
    chestCm,
    waistCm,
    hipCm,
    armCm,
    thighCm,
    notes,
  );

  /// Create a copy of BodyMeasurement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BodyMeasurementImplCopyWith<_$BodyMeasurementImpl> get copyWith =>
      __$$BodyMeasurementImplCopyWithImpl<_$BodyMeasurementImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BodyMeasurementImplToJson(this);
  }
}

abstract class _BodyMeasurement implements BodyMeasurement {
  const factory _BodyMeasurement({
    final String? id,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'measured_at') required final DateTime measuredAt,
    @JsonKey(name: 'weight_kg') final double? weightKg,
    @JsonKey(name: 'body_fat_percent') final double? bodyFatPercent,
    @JsonKey(name: 'muscle_mass_percent') final double? muscleMassPercent,
    @JsonKey(name: 'chest_cm') final double? chestCm,
    @JsonKey(name: 'waist_cm') final double? waistCm,
    @JsonKey(name: 'hip_cm') final double? hipCm,
    @JsonKey(name: 'arm_cm') final double? armCm,
    @JsonKey(name: 'thigh_cm') final double? thighCm,
    final String? notes,
  }) = _$BodyMeasurementImpl;

  factory _BodyMeasurement.fromJson(Map<String, dynamic> json) =
      _$BodyMeasurementImpl.fromJson;

  @override
  String? get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'measured_at')
  DateTime get measuredAt;
  @override
  @JsonKey(name: 'weight_kg')
  double? get weightKg;
  @override
  @JsonKey(name: 'body_fat_percent')
  double? get bodyFatPercent;
  @override
  @JsonKey(name: 'muscle_mass_percent')
  double? get muscleMassPercent;
  @override
  @JsonKey(name: 'chest_cm')
  double? get chestCm;
  @override
  @JsonKey(name: 'waist_cm')
  double? get waistCm;
  @override
  @JsonKey(name: 'hip_cm')
  double? get hipCm;
  @override
  @JsonKey(name: 'arm_cm')
  double? get armCm;
  @override
  @JsonKey(name: 'thigh_cm')
  double? get thighCm;
  @override
  String? get notes;

  /// Create a copy of BodyMeasurement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BodyMeasurementImplCopyWith<_$BodyMeasurementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
