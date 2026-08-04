import 'dart:async';

import 'package:flutter/foundation.dart';

/// Bridges any [Stream] (here, Supabase's `onAuthStateChange`) into a
/// [Listenable] so `go_router`'s `refreshListenable` re-evaluates
/// `redirect` whenever auth state changes.
class RouterRefreshStream extends ChangeNotifier {
  RouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
