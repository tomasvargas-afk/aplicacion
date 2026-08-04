// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diet_plan_meal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DietPlanMeal _$DietPlanMealFromJson(Map<String, dynamic> json) {
  return _DietPlanMeal.fromJson(json);
}

/// @nodoc
mixin _$DietPlanMeal {
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'diet_plan_id')
  String? get dietPlanId => throw _privateConstructorUsedError;
  @JsonKey(name: 'meal_type')
  String get mealType => throw _privateConstructorUsedError;
  @JsonKey(name: 'suggested_food')
  String get suggestedFood => throw _privateConstructorUsedError;
  double get calories => throw _privateConstructorUsedError;
  @JsonKey(name: 'protein_g')
  double get proteinG => throw _privateConstructorUsedError;
  @JsonKey(name: 'carbs_g')
  double get carbsG => throw _privateConstructorUsedError;
  @JsonKey(name: 'fat_g')
  double get fatG => throw _privateConstructorUsedError;

  /// Serializes this DietPlanMeal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DietPlanMeal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DietPlanMealCopyWith<DietPlanMeal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DietPlanMealCopyWith<$Res> {
  factory $DietPlanMealCopyWith(
    DietPlanMeal value,
    $Res Function(DietPlanMeal) then,
  ) = _$DietPlanMealCopyWithImpl<$Res, DietPlanMeal>;
  @useResult
  $Res call({
    String? id,
    @JsonKey(name: 'diet_plan_id') String? dietPlanId,
    @JsonKey(name: 'meal_type') String mealType,
    @JsonKey(name: 'suggested_food') String suggestedFood,
    double calories,
    @JsonKey(name: 'protein_g') double proteinG,
    @JsonKey(name: 'carbs_g') double carbsG,
    @JsonKey(name: 'fat_g') double fatG,
  });
}

/// @nodoc
class _$DietPlanMealCopyWithImpl<$Res, $Val extends DietPlanMeal>
    implements $DietPlanMealCopyWith<$Res> {
  _$DietPlanMealCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DietPlanMeal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? dietPlanId = freezed,
    Object? mealType = null,
    Object? suggestedFood = null,
    Object? calories = null,
    Object? proteinG = null,
    Object? carbsG = null,
    Object? fatG = null,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            dietPlanId: freezed == dietPlanId
                ? _value.dietPlanId
                : dietPlanId // ignore: cast_nullable_to_non_nullable
                      as String?,
            mealType: null == mealType
                ? _value.mealType
                : mealType // ignore: cast_nullable_to_non_nullable
                      as String,
            suggestedFood: null == suggestedFood
                ? _value.suggestedFood
                : suggestedFood // ignore: cast_nullable_to_non_nullable
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DietPlanMealImplCopyWith<$Res>
    implements $DietPlanMealCopyWith<$Res> {
  factory _$$DietPlanMealImplCopyWith(
    _$DietPlanMealImpl value,
    $Res Function(_$DietPlanMealImpl) then,
  ) = __$$DietPlanMealImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    @JsonKey(name: 'diet_plan_id') String? dietPlanId,
    @JsonKey(name: 'meal_type') String mealType,
    @JsonKey(name: 'suggested_food') String suggestedFood,
    double calories,
    @JsonKey(name: 'protein_g') double proteinG,
    @JsonKey(name: 'carbs_g') double carbsG,
    @JsonKey(name: 'fat_g') double fatG,
  });
}

/// @nodoc
class __$$DietPlanMealImplCopyWithImpl<$Res>
    extends _$DietPlanMealCopyWithImpl<$Res, _$DietPlanMealImpl>
    implements _$$DietPlanMealImplCopyWith<$Res> {
  __$$DietPlanMealImplCopyWithImpl(
    _$DietPlanMealImpl _value,
    $Res Function(_$DietPlanMealImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DietPlanMeal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? dietPlanId = freezed,
    Object? mealType = null,
    Object? suggestedFood = null,
    Object? calories = null,
    Object? proteinG = null,
    Object? carbsG = null,
    Object? fatG = null,
  }) {
    return _then(
      _$DietPlanMealImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        dietPlanId: freezed == dietPlanId
            ? _value.dietPlanId
            : dietPlanId // ignore: cast_nullable_to_non_nullable
                  as String?,
        mealType: null == mealType
            ? _value.mealType
            : mealType // ignore: cast_nullable_to_non_nullable
                  as String,
        suggestedFood: null == suggestedFood
            ? _value.suggestedFood
            : suggestedFood // ignore: cast_nullable_to_non_nullable
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DietPlanMealImpl implements _DietPlanMeal {
  const _$DietPlanMealImpl({
    this.id,
    @JsonKey(name: 'diet_plan_id') this.dietPlanId,
    @JsonKey(name: 'meal_type') required this.mealType,
    @JsonKey(name: 'suggested_food') required this.suggestedFood,
    required this.calories,
    @JsonKey(name: 'protein_g') required this.proteinG,
    @JsonKey(name: 'carbs_g') required this.carbsG,
    @JsonKey(name: 'fat_g') required this.fatG,
  });

  factory _$DietPlanMealImpl.fromJson(Map<String, dynamic> json) =>
      _$$DietPlanMealImplFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey(name: 'diet_plan_id')
  final String? dietPlanId;
  @override
  @JsonKey(name: 'meal_type')
  final String mealType;
  @override
  @JsonKey(name: 'suggested_food')
  final String suggestedFood;
  @override
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
  String toString() {
    return 'DietPlanMeal(id: $id, dietPlanId: $dietPlanId, mealType: $mealType, suggestedFood: $suggestedFood, calories: $calories, proteinG: $proteinG, carbsG: $carbsG, fatG: $fatG)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DietPlanMealImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dietPlanId, dietPlanId) ||
                other.dietPlanId == dietPlanId) &&
            (identical(other.mealType, mealType) ||
                other.mealType == mealType) &&
            (identical(other.suggestedFood, suggestedFood) ||
                other.suggestedFood == suggestedFood) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.proteinG, proteinG) ||
                other.proteinG == proteinG) &&
            (identical(other.carbsG, carbsG) || other.carbsG == carbsG) &&
            (identical(other.fatG, fatG) || other.fatG == fatG));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    dietPlanId,
    mealType,
    suggestedFood,
    calories,
    proteinG,
    carbsG,
    fatG,
  );

  /// Create a copy of DietPlanMeal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DietPlanMealImplCopyWith<_$DietPlanMealImpl> get copyWith =>
      __$$DietPlanMealImplCopyWithImpl<_$DietPlanMealImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DietPlanMealImplToJson(this);
  }
}

abstract class _DietPlanMeal implements DietPlanMeal {
  const factory _DietPlanMeal({
    final String? id,
    @JsonKey(name: 'diet_plan_id') final String? dietPlanId,
    @JsonKey(name: 'meal_type') required final String mealType,
    @JsonKey(name: 'suggested_food') required final String suggestedFood,
    required final double calories,
    @JsonKey(name: 'protein_g') required final double proteinG,
    @JsonKey(name: 'carbs_g') required final double carbsG,
    @JsonKey(name: 'fat_g') required final double fatG,
  }) = _$DietPlanMealImpl;

  factory _DietPlanMeal.fromJson(Map<String, dynamic> json) =
      _$DietPlanMealImpl.fromJson;

  @override
  String? get id;
  @override
  @JsonKey(name: 'diet_plan_id')
  String? get dietPlanId;
  @override
  @JsonKey(name: 'meal_type')
  String get mealType;
  @override
  @JsonKey(name: 'suggested_food')
  String get suggestedFood;
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

  /// Create a copy of DietPlanMeal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DietPlanMealImplCopyWith<_$DietPlanMealImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
