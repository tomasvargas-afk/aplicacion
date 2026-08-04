// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diet_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DietPlan _$DietPlanFromJson(Map<String, dynamic> json) {
  return _DietPlan.fromJson(json);
}

/// @nodoc
mixin _$DietPlan {
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'formula_used')
  String get formulaUsed => throw _privateConstructorUsedError;
  double get bmr => throw _privateConstructorUsedError;
  double get tdee => throw _privateConstructorUsedError;
  @JsonKey(name: 'daily_calories')
  double get dailyCalories => throw _privateConstructorUsedError;
  @JsonKey(name: 'protein_g')
  double get proteinG => throw _privateConstructorUsedError;
  @JsonKey(name: 'carbs_g')
  double get carbsG => throw _privateConstructorUsedError;
  @JsonKey(name: 'fat_g')
  double get fatG => throw _privateConstructorUsedError;
  @JsonKey(name: 'activity_level')
  String get activityLevel => throw _privateConstructorUsedError;
  String get goal => throw _privateConstructorUsedError;
  @JsonKey(name: 'generated_at')
  DateTime? get generatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'diet_plan_meals', includeToJson: false)
  List<DietPlanMeal> get meals => throw _privateConstructorUsedError;

  /// Serializes this DietPlan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DietPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DietPlanCopyWith<DietPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DietPlanCopyWith<$Res> {
  factory $DietPlanCopyWith(DietPlan value, $Res Function(DietPlan) then) =
      _$DietPlanCopyWithImpl<$Res, DietPlan>;
  @useResult
  $Res call({
    String? id,
    @JsonKey(name: 'user_id') String userId,
    String? name,
    @JsonKey(name: 'formula_used') String formulaUsed,
    double bmr,
    double tdee,
    @JsonKey(name: 'daily_calories') double dailyCalories,
    @JsonKey(name: 'protein_g') double proteinG,
    @JsonKey(name: 'carbs_g') double carbsG,
    @JsonKey(name: 'fat_g') double fatG,
    @JsonKey(name: 'activity_level') String activityLevel,
    String goal,
    @JsonKey(name: 'generated_at') DateTime? generatedAt,
    @JsonKey(name: 'diet_plan_meals', includeToJson: false)
    List<DietPlanMeal> meals,
  });
}

/// @nodoc
class _$DietPlanCopyWithImpl<$Res, $Val extends DietPlan>
    implements $DietPlanCopyWith<$Res> {
  _$DietPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DietPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = null,
    Object? name = freezed,
    Object? formulaUsed = null,
    Object? bmr = null,
    Object? tdee = null,
    Object? dailyCalories = null,
    Object? proteinG = null,
    Object? carbsG = null,
    Object? fatG = null,
    Object? activityLevel = null,
    Object? goal = null,
    Object? generatedAt = freezed,
    Object? meals = null,
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
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            formulaUsed: null == formulaUsed
                ? _value.formulaUsed
                : formulaUsed // ignore: cast_nullable_to_non_nullable
                      as String,
            bmr: null == bmr
                ? _value.bmr
                : bmr // ignore: cast_nullable_to_non_nullable
                      as double,
            tdee: null == tdee
                ? _value.tdee
                : tdee // ignore: cast_nullable_to_non_nullable
                      as double,
            dailyCalories: null == dailyCalories
                ? _value.dailyCalories
                : dailyCalories // ignore: cast_nullable_to_non_nullable
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
            activityLevel: null == activityLevel
                ? _value.activityLevel
                : activityLevel // ignore: cast_nullable_to_non_nullable
                      as String,
            goal: null == goal
                ? _value.goal
                : goal // ignore: cast_nullable_to_non_nullable
                      as String,
            generatedAt: freezed == generatedAt
                ? _value.generatedAt
                : generatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            meals: null == meals
                ? _value.meals
                : meals // ignore: cast_nullable_to_non_nullable
                      as List<DietPlanMeal>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DietPlanImplCopyWith<$Res>
    implements $DietPlanCopyWith<$Res> {
  factory _$$DietPlanImplCopyWith(
    _$DietPlanImpl value,
    $Res Function(_$DietPlanImpl) then,
  ) = __$$DietPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    @JsonKey(name: 'user_id') String userId,
    String? name,
    @JsonKey(name: 'formula_used') String formulaUsed,
    double bmr,
    double tdee,
    @JsonKey(name: 'daily_calories') double dailyCalories,
    @JsonKey(name: 'protein_g') double proteinG,
    @JsonKey(name: 'carbs_g') double carbsG,
    @JsonKey(name: 'fat_g') double fatG,
    @JsonKey(name: 'activity_level') String activityLevel,
    String goal,
    @JsonKey(name: 'generated_at') DateTime? generatedAt,
    @JsonKey(name: 'diet_plan_meals', includeToJson: false)
    List<DietPlanMeal> meals,
  });
}

/// @nodoc
class __$$DietPlanImplCopyWithImpl<$Res>
    extends _$DietPlanCopyWithImpl<$Res, _$DietPlanImpl>
    implements _$$DietPlanImplCopyWith<$Res> {
  __$$DietPlanImplCopyWithImpl(
    _$DietPlanImpl _value,
    $Res Function(_$DietPlanImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DietPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = null,
    Object? name = freezed,
    Object? formulaUsed = null,
    Object? bmr = null,
    Object? tdee = null,
    Object? dailyCalories = null,
    Object? proteinG = null,
    Object? carbsG = null,
    Object? fatG = null,
    Object? activityLevel = null,
    Object? goal = null,
    Object? generatedAt = freezed,
    Object? meals = null,
  }) {
    return _then(
      _$DietPlanImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        formulaUsed: null == formulaUsed
            ? _value.formulaUsed
            : formulaUsed // ignore: cast_nullable_to_non_nullable
                  as String,
        bmr: null == bmr
            ? _value.bmr
            : bmr // ignore: cast_nullable_to_non_nullable
                  as double,
        tdee: null == tdee
            ? _value.tdee
            : tdee // ignore: cast_nullable_to_non_nullable
                  as double,
        dailyCalories: null == dailyCalories
            ? _value.dailyCalories
            : dailyCalories // ignore: cast_nullable_to_non_nullable
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
        activityLevel: null == activityLevel
            ? _value.activityLevel
            : activityLevel // ignore: cast_nullable_to_non_nullable
                  as String,
        goal: null == goal
            ? _value.goal
            : goal // ignore: cast_nullable_to_non_nullable
                  as String,
        generatedAt: freezed == generatedAt
            ? _value.generatedAt
            : generatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        meals: null == meals
            ? _value._meals
            : meals // ignore: cast_nullable_to_non_nullable
                  as List<DietPlanMeal>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DietPlanImpl implements _DietPlan {
  const _$DietPlanImpl({
    this.id,
    @JsonKey(name: 'user_id') required this.userId,
    this.name,
    @JsonKey(name: 'formula_used') this.formulaUsed = 'mifflin_st_jeor',
    required this.bmr,
    required this.tdee,
    @JsonKey(name: 'daily_calories') required this.dailyCalories,
    @JsonKey(name: 'protein_g') required this.proteinG,
    @JsonKey(name: 'carbs_g') required this.carbsG,
    @JsonKey(name: 'fat_g') required this.fatG,
    @JsonKey(name: 'activity_level') required this.activityLevel,
    required this.goal,
    @JsonKey(name: 'generated_at') this.generatedAt,
    @JsonKey(name: 'diet_plan_meals', includeToJson: false)
    final List<DietPlanMeal> meals = const <DietPlanMeal>[],
  }) : _meals = meals;

  factory _$DietPlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$DietPlanImplFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String? name;
  @override
  @JsonKey(name: 'formula_used')
  final String formulaUsed;
  @override
  final double bmr;
  @override
  final double tdee;
  @override
  @JsonKey(name: 'daily_calories')
  final double dailyCalories;
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
  @JsonKey(name: 'activity_level')
  final String activityLevel;
  @override
  final String goal;
  @override
  @JsonKey(name: 'generated_at')
  final DateTime? generatedAt;
  final List<DietPlanMeal> _meals;
  @override
  @JsonKey(name: 'diet_plan_meals', includeToJson: false)
  List<DietPlanMeal> get meals {
    if (_meals is EqualUnmodifiableListView) return _meals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_meals);
  }

  @override
  String toString() {
    return 'DietPlan(id: $id, userId: $userId, name: $name, formulaUsed: $formulaUsed, bmr: $bmr, tdee: $tdee, dailyCalories: $dailyCalories, proteinG: $proteinG, carbsG: $carbsG, fatG: $fatG, activityLevel: $activityLevel, goal: $goal, generatedAt: $generatedAt, meals: $meals)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DietPlanImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.formulaUsed, formulaUsed) ||
                other.formulaUsed == formulaUsed) &&
            (identical(other.bmr, bmr) || other.bmr == bmr) &&
            (identical(other.tdee, tdee) || other.tdee == tdee) &&
            (identical(other.dailyCalories, dailyCalories) ||
                other.dailyCalories == dailyCalories) &&
            (identical(other.proteinG, proteinG) ||
                other.proteinG == proteinG) &&
            (identical(other.carbsG, carbsG) || other.carbsG == carbsG) &&
            (identical(other.fatG, fatG) || other.fatG == fatG) &&
            (identical(other.activityLevel, activityLevel) ||
                other.activityLevel == activityLevel) &&
            (identical(other.goal, goal) || other.goal == goal) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            const DeepCollectionEquality().equals(other._meals, _meals));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    name,
    formulaUsed,
    bmr,
    tdee,
    dailyCalories,
    proteinG,
    carbsG,
    fatG,
    activityLevel,
    goal,
    generatedAt,
    const DeepCollectionEquality().hash(_meals),
  );

  /// Create a copy of DietPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DietPlanImplCopyWith<_$DietPlanImpl> get copyWith =>
      __$$DietPlanImplCopyWithImpl<_$DietPlanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DietPlanImplToJson(this);
  }
}

abstract class _DietPlan implements DietPlan {
  const factory _DietPlan({
    final String? id,
    @JsonKey(name: 'user_id') required final String userId,
    final String? name,
    @JsonKey(name: 'formula_used') final String formulaUsed,
    required final double bmr,
    required final double tdee,
    @JsonKey(name: 'daily_calories') required final double dailyCalories,
    @JsonKey(name: 'protein_g') required final double proteinG,
    @JsonKey(name: 'carbs_g') required final double carbsG,
    @JsonKey(name: 'fat_g') required final double fatG,
    @JsonKey(name: 'activity_level') required final String activityLevel,
    required final String goal,
    @JsonKey(name: 'generated_at') final DateTime? generatedAt,
    @JsonKey(name: 'diet_plan_meals', includeToJson: false)
    final List<DietPlanMeal> meals,
  }) = _$DietPlanImpl;

  factory _DietPlan.fromJson(Map<String, dynamic> json) =
      _$DietPlanImpl.fromJson;

  @override
  String? get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String? get name;
  @override
  @JsonKey(name: 'formula_used')
  String get formulaUsed;
  @override
  double get bmr;
  @override
  double get tdee;
  @override
  @JsonKey(name: 'daily_calories')
  double get dailyCalories;
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
  @JsonKey(name: 'activity_level')
  String get activityLevel;
  @override
  String get goal;
  @override
  @JsonKey(name: 'generated_at')
  DateTime? get generatedAt;
  @override
  @JsonKey(name: 'diet_plan_meals', includeToJson: false)
  List<DietPlanMeal> get meals;

  /// Create a copy of DietPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DietPlanImplCopyWith<_$DietPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
