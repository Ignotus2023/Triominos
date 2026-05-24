import 'package:flutter_test/flutter_test.dart';
import 'package:triomino_score/core/game/move.dart';
import 'package:triomino_score/core/game/score_calculator.dart';
import 'package:triomino_score/core/game/scoring_rules.dart';

void main() {
  group('calculateMoveScore – zwykłe zagranie', () {
    test('punkty bazowe to suma narożników', () {
      final move = Move.play(corner1: 5, corner2: 3, corner3: 2);
      expect(move.baseScore, 10);
      expect(move.bonusScore, 0);
      expect(calculateMoveScore(move), 10);
    });

    test('triplet 4-4-4 = 12 bazy + 10 premii', () {
      final move = Move.play(corner1: 4, corner2: 4, corner3: 4);
      expect(move.isTriplet, isTrue);
      expect(calculateMoveScore(move), 12 + ScoringRules.tripletBonus);
    });

    test('triplet 0-0-0 = 0 bazy + 30 premii specjalnej', () {
      final move = Move.play(corner1: 0, corner2: 0, corner3: 0);
      expect(move.isZeroTriplet, isTrue);
      expect(calculateMoveScore(move), ScoringRules.zeroTripletBonus);
    });
  });

  group('calculateMoveScore – bonusy łączą się', () {
    test('start 5-5-5 = 15 + triplet 10 + start 10 = 35', () {
      final move = Move.play(
        corner1: 5,
        corner2: 5,
        corner3: 5,
        isStarter: true,
      );
      expect(calculateMoveScore(move), 35);
    });

    test('start 0-0-0 = 0 + 30 + 10 = 40', () {
      final move = Move.play(
        corner1: 0,
        corner2: 0,
        corner3: 0,
        isStarter: true,
      );
      expect(calculateMoveScore(move), 40);
    });

    test('most dodaje +40', () {
      final move = Move.play(corner1: 5, corner2: 3, corner3: 2, isBridge: true);
      expect(calculateMoveScore(move), 10 + ScoringRules.bridgeBonus);
    });

    test('hexagon dodaje +50', () {
      final move =
          Move.play(corner1: 5, corner2: 5, corner3: 1, isHexagon: true);
      expect(calculateMoveScore(move), 11 + ScoringRules.hexagonBonus);
    });

    test('podwójny hexagon dodaje 50 + 60 = 110', () {
      final move =
          Move.play(corner1: 2, corner2: 3, corner3: 4, isDoubleHexagon: true);
      expect(
        calculateMoveScore(move),
        9 + ScoringRules.hexagonBonus + ScoringRules.doubleHexagonBonus,
      );
    });

    test('podwójny hex jest wyłączny względem zwykłego hexa (radio)', () {
      final move = Move.play(
        corner1: 2,
        corner2: 3,
        corner3: 4,
        isHexagon: true,
        isDoubleHexagon: true,
      );
      expect(calculateMoveScore(move), 9 + 110);
    });

    test('kombo most + hexagon sumuje się', () {
      final move = Move.play(
        corner1: 1,
        corner2: 2,
        corner3: 3,
        isBridge: true,
        isHexagon: true,
      );
      expect(
        calculateMoveScore(move),
        6 + ScoringRules.bridgeBonus + ScoringRules.hexagonBonus,
      );
    });
  });

  group('calculateMoveScore – kary i koniec rundy', () {
    test('dobranie z puli = -5', () {
      expect(calculateMoveScore(Move.drawPenalty()), ScoringRules.drawPenalty);
    });

    test('pas = -10', () {
      expect(calculateMoveScore(Move.passPenalty()), ScoringRules.passPenalty);
    });

    test('koniec ręki = 25 + suma rąk przeciwników', () {
      final move = Move.endOfHand(opponentsHandSum: 23);
      expect(calculateMoveScore(move), ScoringRules.endOfHandBonus + 23);
      expect(move.baseScore, ScoringRules.endOfHandBonus);
      expect(move.bonusScore, 23);
    });

    test('totalScore zawsze równa się baseScore + bonusScore', () {
      final moves = [
        Move.play(corner1: 5, corner2: 5, corner3: 5, isStarter: true),
        Move.play(corner1: 1, corner2: 2, corner3: 3, isBridge: true),
        Move.drawPenalty(),
        Move.endOfHand(opponentsHandSum: 12),
      ];
      for (final m in moves) {
        expect(m.totalScore, m.baseScore + m.bonusScore);
      }
    });
  });

  group('MoveValidation', () {
    test('wykrywa triplet', () {
      expect(MoveValidation.isTriplet(3, 3, 3), isTrue);
      expect(MoveValidation.isTriplet(3, 3, 2), isFalse);
    });

    test('wykrywa specjalny 0-0-0', () {
      expect(MoveValidation.isSpecialZeroTriplet(0, 0, 0), isTrue);
      expect(MoveValidation.isSpecialZeroTriplet(1, 1, 1), isFalse);
    });

    test('waliduje zakres narożników 0-5', () {
      expect(MoveValidation.isValidTile(0, 5, 3), isTrue);
      expect(MoveValidation.isValidTile(0, 6, 3), isFalse);
      expect(MoveValidation.isValidTile(-1, 2, 3), isFalse);
    });
  });
}
