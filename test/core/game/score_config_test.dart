import 'package:flutter_test/flutter_test.dart';
import 'package:triomino_score/core/game/move.dart';
import 'package:triomino_score/core/game/score_calculator.dart';
import 'package:triomino_score/core/game/scoring_config.dart';

void main() {
  test('scoreMove ze standardem daje to samo co gettery Move', () {
    final m = Move.play(corner1: 4, corner2: 4, corner3: 4);
    final s = scoreMove(m, ScoringConfig.standard);
    expect(s.base, m.baseScore);
    expect(s.bonus, m.bonusScore);
    expect(s.total, m.totalScore);
  });

  test('konfiguracja zmienia bonusy', () {
    final triplet = Move.play(corner1: 4, corner2: 4, corner3: 4);
    final noTriplet = ScoringConfig.standard.copyWith(tripletBonus: 0);
    expect(scoreMove(triplet, noTriplet).total, 12);

    final bridge = Move.play(corner1: 5, corner2: 3, corner3: 2, isBridge: true);
    final bigBridge = ScoringConfig.standard.copyWith(bridgeBonus: 100);
    expect(scoreMove(bridge, bigBridge).total, 110);
  });

  test('konfiguracja kar i bonusu za wyjście', () {
    final cfg = ScoringConfig.standard
        .copyWith(drawPenalty: -3, passPenalty: -7, endOfHandBonus: 30);
    expect(scoreMove(Move.drawPenalty(), cfg).total, -3);
    expect(scoreMove(Move.passPenalty(), cfg).total, -7);
    expect(scoreMove(Move.endOfHand(opponentsHandSum: 5), cfg).total, 35);
  });

  test('ScoringConfig serializuje się w obie strony', () {
    final cfg =
        ScoringConfig.standard.copyWith(tripletBonus: 7, hexagonBonus: 99);
    final back = ScoringConfig.fromJson(cfg.toJson());
    expect(back.tripletBonus, 7);
    expect(back.hexagonBonus, 99);
    expect(back.bridgeBonus, ScoringConfig.standard.bridgeBonus);
  });
}
