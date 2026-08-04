// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MealLog _$MealLogFromJson(Map<String, dynamic> json) {
  return _MealLog.fromJson(json);
}

/// @nodoc
mixin _$MealLog {
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'custom_name')
  String get customName => throw _privateConstructorUsedError;
  @JsonKey(name: 'meal_type')
  String get mealType => throw _privateConstructorUsedError;
  double get calories => throw _privateConstructorUsedError;
  @JsonKey(name: 'protein_g')
  double get proteinG => throw _privateConstructorUsedError;
  @JsonKey(name: 'carbs_g')
  double get carbsG => throw _privateConstructorUsedError;
  @JsonKey(name: 'fat_g')
  double get fatG => throw _privateConstructorUsedError;
  @JsonKey(name: 'logged_at')
  DateTime? get loggedAt => throw _privateConstructorUsedError;

  /// Serializes this MealLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MealLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MealLogCopyWith<MealLog> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealLogCopyWith<$Res> {
  factory $MealLogCopyWith(MealLog value, $Res Function(MealLog) then) =
      _$MealLogCopyWithImpl<$Res, MealLog>;
  @useResult
  $Res call({
    String? id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'custom_name') String customName,
    @JsonKey(name: 'meal_type') String mealType,
    double calories,
    @JsonKey(name: 'protein_g') double proteinG,
    @JsonKey(name: 'carbs_g') double carbsG,
    @JsonKey(name: 'fat_g') double fatG,
    @JsonKey(name: 'logged_at') DateTime? loggedAt,
  });
}

/// @nodoc
class _$MealLogCopyWithImpl<$Res, $Val extends MealLog>
    implements $MealLogCopyWith<$Res> {
  _$MealLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MealLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = null,
    Object? customName = null,
    Object? mealType = null,
    Object? calories = null,
    Object? proteinG = null,
    Object? carbsG = null,
    Object? fatG = null,
    Object? loggedAt = freezed,
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
            customName: null == customName
                ? _value.customName
                : customName // ignore: cast_nullable_to_non_nullable
                      as String,
            mealType: null == mealType
                ? _value.mealType
                : mealType // ignore: cast_nullable_to_non_nullable
                      as String,
            calories: null == calories
                ? _value.calories
                : calories // ignore: cast_nullable_to_non_nullable
                      as double,
            proteinG: null == proteinG
                ? _value.proteinG
                : proteinG // ignore: cast_nullable_to_non_nullable
                      as double,
            carbsG: null == carbsG
                ? _value.carbsG
                : carbsG // ignore: cast_nullable_to_non_nullable
                      as double,
            fatG: null == fatG
                ? _value.fatG
                : fatG // ignore: cast_nullable_to_non_nullable
                      as double,
            loggedAt: freezed == loggedAt
                ? _value.loggedAt
                : loggedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MealLogImplCopyWith<$Res> implements $MealLogCopyWith<$Res> {
  factory _$$MealLogImplCopyWith(
    _$MealLogImpl value,
    $Res Function(_$MealLogImpl) then,
  ) = __$$MealLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'custom_name') String customName,
    @JsonKey(name: 'meal_type') String mealType,
    double calories,
    @JsonKey(name: 'protein_g') double proteinG,
    @JsonKey(name: 'carbs_g') double carbsG,
    @JsonKey(name: 'fat_g') double fatG,
    @JsonKey(name: 'logged_at') DateTime? loggedAt,
  });
}

/// @nodoc
class __$$MealLogImplCopyWithImpl<$Res>
    extends _$MealLogCopyWithImpl<$Res, _$MealLogImpl>
    implements _$$MealLogImplCopyWith<$Res> {
  __$$MealLogImplCopyWithImpl(
    _$MealLogImpl _value,
    $Res Function(_$MealLogImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MealLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = null,
    Object? customName = null,
    Object? mealType = null,
    Object? calories = null,
    Object? proteinG = null,
    Object? carbsG = null,
    Object? fatG = null,
    Object? loggedAt = freezed,
  }) {
    return _then(
      _$MealLogImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        customName: null == customName
            ? _value.customName
            : customName // ignore: cast_nullable_to_non_nullable
                  as String,
        mealType: null == mealType
            ? _value.mealType
            : mealType // ignore: cast_nullable_to_non_nullable
                  as String,
        calories: null == calories
            ? _value.calories
            : calories // ignore: cast_nullable_to_non_nullable
                  as double,
        proteinG: null == proteinG
            ? _value.proteinG
            : proteinG // ignore: cast_nullable_to_non_nullable
                  as double,
        carbsG: null == carbsG
            ? _value.carbsG
            : carbsG // ignore: cast_nullable_to_non_nullable
                  as double,
        fatG: null == fatG
            ? _value.fatG
            : fatG // ignore: cast_nullable_to_non_nullable
                  as double,
        loggedAt: freezed == loggedAt
            ? _value.loggedAt
            : loggedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MealLogImpl implements _MealLog {
  const _$MealLogImpl({
    this.id,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'custom_name') required this.customName,
    @JsonKey(name: 'meal_type') required this.mealType,
    this.calories = 0,
    @JsonKey(name: 'protein_g') this.proteinG = 0,
    @JsonKey(name: 'carbs_g') this.carbsG = 0,
    @JsonKey(name: 'fat_g') this.fatG = 0,
    @JsonKey(name: 'logged_at') this.loggedAt,
  });

  factory _$MealLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$MealLogImplFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'custom_name')
  final String customName;
  @override
  @JsonKey(name: 'meal_type')
  final String mealType;
  @override
  @JsonKey()
  final double calories;
  @override
  @JsonKey(name: 'protein_g')
  final double proteinG;
  @override
  @JsonKey(name: 'carbs_g')
  final double carbsG;
  @override
  @JsonKey(name: 'fat_g')
  final double fatG;
  @override
  @JsonKey(name: 'logged_at')
  final DateTime? loggedAt;

  @override
  String toString() {
    return 'MealLog(id: $id, userId: $userId, customName: $customName, mealType: $mealType, calories: $calories, proteinG: $proteinG, carbsG: $carbsG, fatG: $fatG, loggedAt: $loggedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.customName, customName) ||
                other.customName == customName) &&
            (identical(other.mealType, mealType) ||
                other.mealType == mealType) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.proteinG, proteinG) ||
                other.proteinG == proteinG) &&
            (identical(other.carbsG, carbsG) || other.carbsG == carbsG) &&
            (identical(other.fatG, fatG) || other.fatG == fatG) &&
            (identical(other.loggedAt, loggedAt) ||
                other.loggedAt == loggedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    customName,
    mealType,
    calories,
    proteinG,
    carbsG,
    fatG,
    loggedAt,
  );

  /// Create a copy of MealLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MealLogImplCopyWith<_$MealLogImpl> get copyWith =>
      __$$MealLogImplCopyWithImpl<_$MealLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MealLogImplToJson(this);
  }
}

abstract class _MealLog implements MealLog {
  const factory _MealLog({
    final String? id,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'custom_name') required final String customName,
    @JsonKey(name: 'meal_type') required final String mealType,
    final double calories,
    @JsonKey(name: 'protein_g') final double proteinG,
    @JsonKey(name: 'carbs_g') final double carbsG,
    @JsonKey(name: 'fat_g') final double fatG,
    @JsonKey(name: 'logged_at') final DateTime? loggedAt,
  }) = _$MealLogImpl;

  factory _MealLog.fromJson(Map<String, dynamic> json) = _$MealLogImpl.fromJson;

  @override
  String? get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'custom_name')
  String get customName;
  @override
  @JsonKey(name: 'meal_type')
  String get mealType;
  @override
  double get calories;
  @override
  @JsonKey(name: 'protein_g')
  double get proteinG;
  @override
  @JsonKey(name: 'carbs_g')
  double get carbsG;
  @override
  @JsonKey(name: 'fat_g')
  double get fatG;
  @override
  @JsonKey(name: 'logged_at')
  DateTime? get loggedAt;

  /// Create a copy of MealLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MealLogImplCopyWith<_$MealLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
