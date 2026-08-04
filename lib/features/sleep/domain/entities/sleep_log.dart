import 'package:freezed_annotation/freezed_annotation.dart';

part 'sleep_log.freezed.dart';
part 'sleep_log.g.dart';

@freezed
abstract class SleepLog with _$SleepLog {
  const factory SleepLog({
    String? id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'sleep_date') required DateTime sleepDate,
    required double hours,
    int? quality,
    /// Stored as "HH:mm" (Postgres `time`).
    @JsonKey(name: 'bed_time') String? bedTime,
    @JsonKey(name: 'wake_time') String? wakeTime,
  }) = _SleepLog;

  factory SleepLog.fromJson(Map<String, dynamic> json) => _$SleepLogFromJson(json);
}
