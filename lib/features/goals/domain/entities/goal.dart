import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal.freezed.dart';
part 'goal.g.dart';

@freezed
abstract class Goal with _$Goal {
  const factory Goal({
    String? id,
    @JsonKey(name: 'user_id') required String userId,
    required String type,
    required String title,
    @JsonKey(name: 'target_value') required double targetValue,
    @JsonKey(name: 'current_value') @Default(0) double currentValue,
    String? unit,
    DateTime? deadline,
    @Default('active') String status,
  }) = _Goal;

  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);
}

enum GoalType {
  weight('weight', 'Peso', Icons.monitor_weight_outlined),
  water('water', 'Agua', Icons.water_drop_outlined),
  workoutFrequency('workout_frequency', 'Entrenamiento', Icons.fitness_center),
  sleep('sleep', 'Sueño', Icons.bedtime_outlined),
  custom('custom', 'Personalizado', Icons.flag_outlined);

  const GoalType(this.dbValue, this.label, this.icon);

  final String dbValue;
  final String label;
  final IconData icon;

  static GoalType fromDbValue(String value) =>
      GoalType.values.firstWhere((t) => t.dbValue == value, orElse: () => GoalType.custom);
}
