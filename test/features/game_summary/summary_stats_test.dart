import 'package:flutter_test/flutter_test.dart';
import 'package:triomino_score/core/game/end_game_evaluator.dart';
import 'package:triomino_score/core/game/move_input.dart';
import 'package:triomino_score/core/game/score_calculator.dart';
import 'package:triomino_score/core/game/scoring_rules.dart';
import 'package:triomino_score/features/game/domain/game.dart';
import 'package:triomino_score/features/game/domain/game_repository.dart';
import 'package:triomino_score/features/game/domain/move.dart';
import 'package:triomino_score/features/game/domain/round.dart';
import 'package:triomino_score/features/game_summary/domain/summary_stats.dart';

final _calc = ScoreCalculator(ScoringRules.forVariant(ScoringVariant.goliath));

Move _play(String roundId, String playerId, int index, MoveInput input) {
  return Move.fromInput(
    roundId: roundId,
    playerId: playerId,
    moveIndex: index,
    input: input,
    breakdown: _calc.calculate(input),
  );
}

void main() {
  test('computeSummary ranks players, finds best move and counts hexagons', () {
    final start = DateTime(2026, 5, 22, 18);
    final game = Game(
      id: 'g1',
      endMode: EndMode.scoreLimit,
      scoringVariant: ScoringVariant.goliath,
      scoreLimit: 400,
      totalRounds: null,
      currentRound: 1,
      currentSeatIndex: 0,
      status: GameStatus.finished,
      winnerId: 'b',
      playedTilesCount: 3,
      startedAt: start,
      finishedAt: start.add(const Duration(minutes: 25)),
      players: const [
        GamePlayerSnapshot(
          playerId: 'a',
          seatIndex: 0,
          displayName: 'Anna',
          avatarColor: '#6366F1',
          initials: 'AN',
          totalScore: 120,
        ),
        GamePlayerSnapshot(
          playerId: 'b',
          seatIndex: 1,
          displayName: 'Bartosz',
          avatarColor: '#A78BFA',
          initials: 'BA',
          totalScore: 410,
        ),
      ],
    );

    final round = Round(
      id: 'r1',
      gameId: 'g1',
      roundNumber: 1,
      starterPlayerId: 'a',
      starterByTriplet: true,
      finisherPlayerId: 'b',
      startedAt: start,
      finishedAt: start.add(const Duration(minutes: 25)),
    );

    final moves = [
      _play('r1', 'a', 0, MoveInput.play(corner1: 1, corner2: 2, corner3: 3)),
      _play('r1', 'b', 1, MoveInput.play(corner1: 5, corner2: 5, corner3: 5, isHexagon: true)),
      _play('r1', 'a', 2, MoveInput.play(corner1: 4, corner2: 0, corner3: 1)),
    ];

    final details = GameDetails(
      game: game,
      rounds: [round],
      movesByRound: {'r1': moves},
    );

    final stats = computeSummary(details);

    expect(stats.ranking.first.playerId, 'b');
    expect(stats.ranking.last.playerId, 'a');
    expect(stats.duration, const Duration(minutes: 25));
    expect(stats.roundsPlayed, 1);
    expect(stats.hexagonCount, 1);
    expect(stats.bestMove, isNotNull);
    expect(stats.bestMove!.playerId, 'b');
    expect(stats.bestMove!.score, 15 + 10 + 50);
    expect(stats.bestMove!.tileLabel, '5-5-5');
  });

  test('computeSummary handles a game with no moves', () {
    final start = DateTime(2026, 5, 22, 18);
    final game = Game(
      id: 'g2',
      endMode: EndMode.freeform,
      scoringVariant: ScoringVariant.pressman,
      scoreLimit: null,
      totalRounds: null,
      currentRound: 1,
      currentSeatIndex: 0,
      status: GameStatus.finished,
      winnerId: 'a',
      playedTilesCount: 0,
      startedAt: start,
      finishedAt: start.add(const Duration(minutes: 3)),
      players: const [
        GamePlayerSnapshot(
          playerId: 'a',
          seatIndex: 0,
          displayName: 'Anna',
          avatarColor: '#6366F1',
          initials: 'AN',
          totalScore: 0,
        ),
      ],
    );

    final stats = computeSummary(
      GameDetails(game: game, rounds: const [], movesByRound: const {}),
    );

    expect(stats.bestMove, isNull);
    expect(stats.hexagonCount, 0);
    expect(stats.roundsPlayed, 1);
  });
}
