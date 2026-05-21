import 'move_input.dart';
import 'score_breakdown.dart';
import 'scoring_rules.dart';

class ScoreCalculator {
  const ScoreCalculator(this.rules);

  final ScoringRules rules;

  ScoreBreakdown calculate(MoveInput move) {
    switch (move.type) {
      case MoveType.drawPenalty:
        return ScoreBreakdown.zero().copyWith(penalty: rules.drawPenalty);
      case MoveType.passPenalty:
        return ScoreBreakdown.zero().copyWith(penalty: rules.passPenalty);
      case MoveType.endOfHandBonus:
        return ScoreBreakdown.zero().copyWith(
          endOfHandBonus: rules.endOfHandBonus,
          opponentsHandSum: move.opponentsHandSum ?? 0,
        );
      case MoveType.play:
        return _calculatePlay(move);
    }
  }

  ScoreBreakdown _calculatePlay(MoveInput move) {
    final base = move.cornerSum ?? 0;
    final triplet = move.isTriplet
        ? (move.isZeroTriplet ? rules.zeroTripletBonus : rules.tripletBonus)
        : 0;
    final bridge = move.isBridge ? rules.bridgeBonus : 0;
    final hex = move.isHexagon ? rules.hexagonBonus : 0;
    final dblHex = move.isDoubleHexagon ? (rules.hexagonBonus + rules.doubleHexagonBonus) : 0;
    final starter = move.isStarter ? rules.starterBonus : 0;

    return ScoreBreakdown(
      base: base,
      tripletBonus: triplet,
      bridgeBonus: bridge,
      hexagonBonus: hex,
      doubleHexagonBonus: dblHex,
      starterBonus: starter,
      endOfHandBonus: 0,
      opponentsHandSum: 0,
      penalty: 0,
    );
  }
}

extension on ScoreBreakdown {
  ScoreBreakdown copyWith({
    int? base,
    int? tripletBonus,
    int? bridgeBonus,
    int? hexagonBonus,
    int? doubleHexagonBonus,
    int? starterBonus,
    int? endOfHandBonus,
    int? opponentsHandSum,
    int? penalty,
  }) {
    return ScoreBreakdown(
      base: base ?? this.base,
      tripletBonus: tripletBonus ?? this.tripletBonus,
      bridgeBonus: bridgeBonus ?? this.bridgeBonus,
      hexagonBonus: hexagonBonus ?? this.hexagonBonus,
      doubleHexagonBonus: doubleHexagonBonus ?? this.doubleHexagonBonus,
      starterBonus: starterBonus ?? this.starterBonus,
      endOfHandBonus: endOfHandBonus ?? this.endOfHandBonus,
      opponentsHandSum: opponentsHandSum ?? this.opponentsHandSum,
      penalty: penalty ?? this.penalty,
    );
  }
}
