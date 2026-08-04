/// Placeholder for the phase-2 offline-mode feature. Not wired up yet —
/// kept here so the offline-mode work has an obvious place to land
/// without restructuring `core/` later.
abstract class ConnectivityService {
  Stream<bool> get onConnectivityChanged;

  Future<bool> get isOnline;
}
