import 'package:flutter_test/flutter_test.dart';
import 'package:triomino_score/core/game/move_input.dart';
import 'package:triomino_score/core/game/score_calculator.dart';
import 'package:triomino_score/core/game/scoring_rules.dart';

void main() {
  group('ScoreCalculator (Goliath variant)', () {
    final calc = ScoreCalculator(ScoringRules.forVariant(ScoringVariant.goliath));

    test('liczy zwykły ruch jako sumę narożników', () {
      final move = MoveInput.play(corner1: 5, corner2: 3, corner3: 2);
      final breakdown = calc.calculate(move);
      expect(breakdown.base, 10);
      expect(breakdown.total, 10);
      expect(breakdown.hasAnyBonus, isFalse);
    });

    test('triplet niezerowy dodaje +10 bonusu', () {
      final move = MoveInput.play(corner1: 4, corner2: 4, corner3: 4);
      final breakdown = calc.calculate(move);
      expect(breakdown.base, 12);
      expect(breakdown.tripletBonus, 10);
      expect(breakdown.total, 22);
    });

    test('triplet 0-0-0 dodaje specjalne +30', () {
      final move = MoveInput.play(corner1: 0, corner2: 0, corner3: 0);
      final breakdown = calc.calculate(move);
      expect(breakdown.base, 0);
      expect(breakdown.tripletBonus, 30);
      expect(breakdown.total, 30);
    });

    test('bridge dodaje +40', () {
      final move = MoveInput.play(corner1: 1, corner2: 2, corner3: 3, isBridge: true);
      expect(calc.calculate(move).total, 6 + 40);
    });

    test('hexagon dodaje +50', () {
      final move = MoveInput.play(corner1: 1, corner2: 2, corner3: 3, isHexagon: true);
      expect(calc.calculate(move).total, 6 + 50);
    });

    test('podwójny hexagon dodaje +110 łącznie (50 + 60)', () {
      final move = MoveInput.play(
        corner1: 1,
        corner2: 2,
        corner3: 3,
        isDoubleHexagon: true,
      );
      final b = calc.calculate(move);
      expect(b.doubleHexagonBonus, 50 + 60);
      expect(b.total, 6 + 50 + 60);
    });

    test('bridge + hexagon łączą się', () {
      final move = MoveInput.play(
        corner1: 5,
        corner2: 5,
        corner3: 5,
        isBridge: true,
        isHexagon: true,
      );
      final b = calc.calculate(move);
      expect(b.base, 15);
      expect(b.tripletBonus, 10);
      expect(b.bridgeBonus, 40);
      expect(b.hexagonBonus, 50);
      expect(b.total, 15 + 10 + 40 + 50);
    });

    test('bonus startowy dodaje +10 w wariancie Goliath', () {
      final move = MoveInput.play(
        corner1: 5,
        corner2: 5,
        corner3: 5,
        isStarter: true,
      );
      final b = calc.calculate(move);
      expect(b.starterBonus, 10);
      expect(b.total, 15 + 10 + 10);
    });

    test('kara dobierania daje -5', () {
      expect(calc.calculate(MoveInput.draw()).total, -5);
      expect(calc.calculate(MoveInput.draw()).penalty, -5);
    });

    test('kara pasu daje -10', () {
      expect(calc.calculate(MoveInput.pass()).total, -10);
    });

    test('koniec rundy: bonus 25 plus suma rąk przeciwników', () {
      final b = calc.calculate(MoveInput.endOfHand(opponentsHandSum: 42));
      expect(b.endOfHandBonus, 25);
      expect(b.opponentsHandSum, 42);
      expect(b.total, 67);
    });
  });

  group('ScoreCalculator (Pressman variant)', () {
    final calc = ScoreCalculator(ScoringRules.forVariant(ScoringVariant.pressman));

    test('starter nie daje dodatkowych punktów (brak bonusu startowego)', () {
      final move = MoveInput.play(
        corner1: 5,
        corner2: 5,
        corner3: 5,
        isStarter: true,
      );
      final b = calc.calculate(move);
      expect(b.starterBonus, 0);
      expect(b.total, 15 + 10);
    });

    test('triplet i hexagon działają tak samo jak w Goliath', () {
      final move = MoveInput.play(
        corner1: 3,
        corner2: 3,
        corner3: 3,
        isHexagon: true,
      );
      expect(calc.calculate(move).total, 9 + 10 + 50);
    });
  });

  group('MoveInput validation', () {
    test('wykrywa triplet jeśli wszystkie trzy narożniki są równe', () {
      expect(MoveInput.play(corner1: 2, corner2: 2, corner3: 2).isTriplet, isTrue);
      expect(MoveInput.play(corner1: 2, corner2: 2, corner3: 3).isTriplet, isFalse);
    });

    test('zeroTriplet rozróżnia 0-0-0 od innych tripletów', () {
      expect(MoveInput.play(corner1: 0, corner2: 0, corner3: 0).isZeroTriplet, isTrue);
      expect(MoveInput.play(corner1: 1, corner2: 1, corner3: 1).isZeroTriplet, isFalse);
    });

    test('odrzuca naruszenia zakresu 0-5', () {
      expect(MoveInput.play(corner1: -1, corner2: 0, corner3: 0).isValidPlay, isFalse);
      expect(MoveInput.play(corner1: 6, corner2: 0, corner3: 0).isValidPlay, isFalse);
    });

    test('odrzuca konflikt hexagon + double hexagon', () {
      expect(
        MoveInput.play(
          corner1: 1,
          corner2: 2,
          corner3: 3,
          isHexagon: true,
          isDoubleHexagon: true,
        ).isValidPlay,
        isFalse,
      );
    });

    test('tileKey jest niezmienny względem kolejności narożników', () {
      final a = MoveInput.play(corner1: 5, corner2: 3, corner3: 2).tileKey();
      final b = MoveInput.play(corner1: 2, corner2: 5, corner3: 3).tileKey();
      final c = MoveInput.play(corner1: 3, corner2: 2, corner3: 5).tileKey();
      expect(a, '2-3-5');
      expect(b, '2-3-5');
      expect(c, '2-3-5');
    });

    test('cornerSum jest sumą trzech narożników', () {
      expect(MoveInput.play(corner1: 5, corner2: 3, corner3: 2).cornerSum, 10);
      expect(MoveInput.play(corner1: 0, corner2: 0, corner3: 0).cornerSum, 0);
    });
  });
}
