import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../../../core/services/notification_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/body_tracking_remote_datasource.dart';
import '../../data/repositories/body_tracking_repository_impl.dart';
import '../../domain/entities/body_measurement.dart';
import '../../domain/repositories/body_tracking_repository.dart';

/// Fixed id so each new measurement replaces the previously scheduled
/// reminder instead of stacking duplicates.
const _progressReminderNotificationId = 9101;

final bodyTrackingRemoteDatasourceProvider =
    Provider<BodyTrackingRemoteDatasource>((ref) {
  return BodyTrackingRemoteDatasource(ref.watch(supabaseClientProvider));
});

final bodyTrackingRepositoryProvider = Provider<BodyTrackingRepository>((ref) {
  return BodyTrackingRepositoryImpl(ref.watch(bodyTrackingRemoteDatasourceProvider));
});

final bodyMeasurementHistoryProvider =
    FutureProvider.autoDispose<List<BodyMeasurement>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const [];
  final result = await ref.watch(bodyTrackingRepositoryProvider).getHistory(user.id);
  return result.match((failure) => throw failure, (list) => list);
});

class BodyTrackingController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> addMeasurement(BodyMeasurement measurement) async {
    state = const AsyncLoading();
    final result =
        await ref.read(bodyTrackingRepositoryProvider).addMeasurement(measurement);
    state = const AsyncData(null);
    return result.match(
      (failure) => failure.displayMessage,
      (_) {
        ref.invalidate(bodyMeasurementHistoryProvider);
        _scheduleNextProgressReminder();
        return null;
      },
    );
  }

  /// Every time a measurement is logged, push the "log your progress"
  /// reminder out 2 weeks — a simple, self-renewing biweekly cadence
  /// (flutter_local_notifications has no built-in "every N weeks" rule).
  Future<void> _scheduleNextProgressReminder() async {
    final granted = await NotificationService.instance.requestPermission();
    if (!granted) return;
    await NotificationService.instance.scheduleOneOff(
      id: _progressReminderNotificationId,
      title: 'Hora de tu control de progreso 📏',
      body: 'Han pasado 2 semanas — registra tu peso y medidas',
      dateTime: DateTime.now().add(const Duration(days: 14)),
    );
  }

  Future<String?> deleteMeasurement(String id) async {
    final result = await ref.read(bodyTrackingRepositoryProvider).deleteMeasurement(id);
    return result.match(
      (failure) => failure.displayMessage,
      (_) {
        ref.invalidate(bodyMeasurementHistoryProvider);
        return null;
      },
    );
  }
}

final bodyTrackingControllerProvider =
    AsyncNotifierProvider<BodyTrackingController, void>(
  BodyTrackingController.new,
);
