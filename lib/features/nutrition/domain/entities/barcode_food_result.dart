/// Nutrition facts looked up for a scanned barcode, per 100g as reported by
/// Open Food Facts. Not persisted directly — screens use it to prefill a
/// meal log or recipe form, which the user can then adjust and save.
class BarcodeFoodResult {
  const BarcodeFoodResult({
    required this.barcode,
    required this.name,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  final String barcode;
  final String name;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
}
