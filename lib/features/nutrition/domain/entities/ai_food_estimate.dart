/// Result of analyzing a food photo with the `analyze-food` Edge Function
/// (Claude vision). Same shape as [BarcodeFoodResult] but kept separate
/// since this one is never keyed by a barcode.
class AiFoodEstimate {
  const AiFoodEstimate({
    required this.name,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  final String name;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
}
