enum ScoringVariant {
  goliath,
  pressman;

  bool get hasStarterBonus => this == ScoringVariant.goliath;
}

class ScoringRules {
  const ScoringRules({
    required this.variant,
    required this.tripletBonus,
    required this.zeroTripletBonus,
    required this.bridgeBonus,
    required this.hexagonBonus,
    required this.doubleHexagonBonus,
    required this.starterBonus,
    required this.endOfHandBonus,
    required this.drawPenalty,
    required this.passPenalty,
    required this.maxDraws,
  });

  factory ScoringRules.forVariant(ScoringVariant variant) {
    switch (variant) {
      case ScoringVariant.goliath:
        return const ScoringRules(
          variant: ScoringVariant.goliath,
          tripletBonus: 10,
          zeroTripletBonus: 30,
          bridgeBonus: 40,
          hexagonBonus: 50,
          doubleHexagonBonus: 60,
          starterBonus: 10,
          endOfHandBonus: 25,
          drawPenalty: -5,
          passPenalty: -10,
          maxDraws: 3,
        );
      case ScoringVariant.pressman:
        return const ScoringRules(
          variant: ScoringVariant.pressman,
          tripletBonus: 10,
          zeroTripletBonus: 30,
          bridgeBonus: 40,
          hexagonBonus: 50,
          doubleHexagonBonus: 60,
          starterBonus: 0,
          endOfHandBonus: 25,
          drawPenalty: -5,
          passPenalty: -10,
          maxDraws: 3,
        );
    }
  }

  final ScoringVariant variant;
  final int tripletBonus;
  final int zeroTripletBonus;
  final int bridgeBonus;
  final int hexagonBonus;
  final int doubleHexagonBonus;
  final int starterBonus;
  final int endOfHandBonus;
  final int drawPenalty;
  final int passPenalty;
  final int maxDraws;
}
