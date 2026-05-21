import 'package:flutter_test/flutter_test.dart';
import 'package:triomino_score/core/game/end_game_evaluator.dart';

void main() {
  const evaluator = EndGameEvaluator();

  group('EndGameEvaluator — scoreLimit', () {
    test('kończy gdy lider osiągnął próg po zakończonej rundzie', () {
      final decision = evaluator.evaluate(
        mode: EndMode.scoreLimit,
        currentRoundNumber: 3,
        scoreLimit: 400,
        totalRounds: null,
        standings: const [
          PlayerStanding(playerId: 'a', totalScore: 410),
          PlayerStanding(playerId: 'b', totalScore: 305),
        ],
        roundJustFinished: true,
      );
      expect(decision.shouldEnd, isTrue);
      expect(decision.winnerPlayerId, 'a');
    });

    test('nie kończy w trakcie rundy nawet jeśli próg jest osiągnięty', () {
      final decision = evaluator.evaluate(
        mode: EndMode.scoreLimit,
        currentRoundNumber: 3,
        scoreLimit: 400,
        totalRounds: null,
        standings: const [PlayerStanding(playerId: 'a', totalScore: 500)],
        roundJustFinished: false,
      );
      expect(decision.shouldEnd, isFalse);
    });

    test('nie kończy gdy nikt nie osiągnął progu', () {
      final decision = evaluator.evaluate(
        mode: EndMode.scoreLimit,
        currentRoundNumber: 3,
        scoreLimit: 400,
        totalRounds: null,
        standings: const [
          PlayerStanding(playerId: 'a', totalScore: 380),
          PlayerStanding(playerId: 'b', totalScore: 305),
        ],
        roundJustFinished: true,
      );
      expect(decision.shouldEnd, isFalse);
    });
  });

  group('EndGameEvaluator — rounds', () {
    test('kończy gdy ostatnia runda zakończona', () {
      final decision = evaluator.evaluate(
        mode: EndMode.rounds,
        currentRoundNumber: 3,
        scoreLimit: null,
        totalRounds: 3,
        standings: const [
          PlayerStanding(playerId: 'a', totalScore: 120),
          PlayerStanding(playerId: 'b', totalScore: 145),
        ],
        roundJustFinished: true,
      );
      expect(decision.shouldEnd, isTrue);
      expect(decision.winnerPlayerId, 'b');
    });

    test('nie kończy gdy jeszcze są rundy do rozegrania', () {
      final decision = evaluator.evaluate(
        mode: EndMode.rounds,
        currentRoundNumber: 2,
        scoreLimit: null,
        totalRounds: 3,
        standings: const [PlayerStanding(playerId: 'a', totalScore: 100)],
        roundJustFinished: true,
      );
      expect(decision.shouldEnd, isFalse);
    });
  });

  group('EndGameEvaluator — freeform', () {
    test('nigdy nie kończy automatycznie', () {
      final decision = evaluator.evaluate(
        mode: EndMode.freeform,
        currentRoundNumber: 10,
        scoreLimit: 100,
        totalRounds: 5,
        standings: const [PlayerStanding(playerId: 'a', totalScore: 999)],
        roundJustFinished: true,
      );
      expect(decision.shouldEnd, isFalse);
    });
  });
}
