/// All weights are stored in the database as kilograms; conversion to
/// pounds only happens at the presentation layer based on user preference.
abstract class UnitConverter {
  UnitConverter._();

  static const double _kgToLb = 2.2046226218;

  static double kgToLb(double kg) => kg * _kgToLb;

  static double lbToKg(double lb) => lb / _kgToLb;

  static String formatWeight(double kg, {required bool useLb}) {
    final value = useLb ? kgToLb(kg) : kg;
    return '${value.toStringAsFixed(1)} ${useLb ? 'lb' : 'kg'}';
  }
}
