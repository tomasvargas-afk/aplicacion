import 'package:freezed_annotation/freezed_annotation.dart';

part 'water_log.freezed.dart';
part 'water_log.g.dart';

@freezed
abstract class WaterLog with _$WaterLog {
  const factory WaterLog({
    String? id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'logged_date') required DateTime loggedDate,
    @JsonKey(name: 'amount_ml') required int amountMl,
    @JsonKey(name: 'goal_ml') @Default(2000) int goalMl,
  }) = _WaterLog;

  factory WaterLog.fromJson(Map<String, dynamic> json) => _$WaterLogFromJson(json);
}
