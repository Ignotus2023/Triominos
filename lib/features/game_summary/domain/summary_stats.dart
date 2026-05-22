import '../../../core/game/move_input.dart';
import '../../game/domain/game.dart';
import '../../game/domain/game_repository.dart';

class BestMove {
  const BestMove({
    required this.playerId,
    required this.tileLabel,
    required this.score,
  });

  final String playerId;
  final String tileLabel;
  final int score;
}

class SummaryStats {
  const SummaryStats({
    required this.ranking,
    required this.duration,
    required this.roundsPlayed,
    required this.hexagonCount,
    required this.bestMove,
  });

  final List<GamePlayerSnapshot> ranking;
  final Duration duration;
  final int roundsPlayed;
  final int hexagonCount;
  final BestMove? bestMove;
}

SummaryStats computeSummary(GameDetails details) {
  final game = details.game;

  final ranking = [...game.players]
    ..sort((a, b) => b.totalScore.compareTo(a.totalScore));

  final allMoves = details.movesByRound.values.expand((m) => m).toList();

  var hexagons = 0;
  BestMove? best;
  for (final move in allMoves) {
    if (move.type != MoveType.play) continue;
    if (move.isHexagon || move.isDoubleHexagon) hexagons++;
    if (best == null || move.totalScore > best.score) {
      best = BestMove(
        playerId: move.playerId,
        tileLabel: '${move.corner1}-${move.corner2}-${move.corner3}',
        score: move.totalScore,
      );
    }
  }

  final end = game.finishedAt ?? DateTime.now();
  final duration = end.difference(game.startedAt);
  final roundsPlayed = details.rounds.where((r) => r.isFinished).length;

  return SummaryStats(
    ranking: ranking,
    duration: duration,
    roundsPlayed: roundsPlayed == 0 ? game.currentRound : roundsPlayed,
    hexagonCount: hexagons,
    bestMove: best,
  );
}
