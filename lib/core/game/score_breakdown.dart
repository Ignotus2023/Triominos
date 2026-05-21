class ScoreBreakdown {
  const ScoreBreakdown({
    required this.base,
    required this.tripletBonus,
    required this.bridgeBonus,
    required this.hexagonBonus,
    required this.doubleHexagonBonus,
    required this.starterBonus,
    required this.endOfHandBonus,
    required this.opponentsHandSum,
    required this.penalty,
  });

  factory ScoreBreakdown.zero() => const ScoreBreakdown(
        base: 0,
        tripletBonus: 0,
        bridgeBonus: 0,
        hexagonBonus: 0,
        doubleHexagonBonus: 0,
        starterBonus: 0,
        endOfHandBonus: 0,
        opponentsHandSum: 0,
        penalty: 0,
      );

  final int base;
  final int tripletBonus;
  final int bridgeBonus;
  final int hexagonBonus;
  final int doubleHexagonBonus;
  final int starterBonus;
  final int endOfHandBonus;
  final int opponentsHandSum;
  final int penalty;

  int get total =>
      base +
      tripletBonus +
      bridgeBonus +
      hexagonBonus +
      doubleHexagonBonus +
      starterBonus +
      endOfHandBonus +
      opponentsHandSum +
      penalty;

  bool get hasAnyBonus =>
      tripletBonus != 0 ||
      bridgeBonus != 0 ||
      hexagonBonus != 0 ||
      doubleHexagonBonus != 0 ||
      starterBonus != 0;
}
