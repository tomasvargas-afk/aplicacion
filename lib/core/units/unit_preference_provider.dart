import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum WeightUnit { kg, lb }

const _unitPrefsKey = 'weight_unit';

/// Local, instant-on preference for kg/lb display. The canonical value
/// also lives in `profiles.weight_unit` and is synced when the profile
/// loads/updates (see `ProfileNotifier`).
class UnitPreferenceNotifier extends Notifier<WeightUnit> {
  @override
  WeightUnit build() {
    _restore();
    return WeightUnit.kg;
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_unitPrefsKey);
    if (stored == WeightUnit.lb.name) {
      state = WeightUnit.lb;
    }
  }

  Future<void> setUnit(WeightUnit unit) async {
    state = unit;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_unitPrefsKey, unit.name);
  }
}

final unitPreferenceProvider =
    NotifierProvider<UnitPreferenceNotifier, WeightUnit>(
  UnitPreferenceNotifier.new,
);
