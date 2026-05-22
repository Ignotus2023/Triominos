import '../../../core/game/end_game_evaluator.dart';
import '../../../core/game/game_status.dart';
import '../../../core/game/scoring_rules.dart';
import '../../../core/utils/id.dart';

export '../../../core/game/game_status.dart';

class GamePlayerSnapshot {
  const GamePlayerSnapshot({
    required this.playerId,
    required this.seatIndex,
    required this.displayName,
    required this.avatarColor,
    required this.initials,
    required this.totalScore,
  });

  final String playerId;
  final int seatIndex;
  final String displayName;
  final String avatarColor;
  final String initials;
  final int totalScore;

  GamePlayerSnapshot copyWith({int? totalScore}) {
    return GamePlayerSnapshot(
      playerId: playerId,
      seatIndex: seatIndex,
      displayName: displayName,
      avatarColor: avatarColor,
      initials: initials,
      totalScore: totalScore ?? this.totalScore,
    );
  }
}

class Game {
  const Game({
    required this.id,
    required this.endMode,
    required this.scoringVariant,
    required this.scoreLimit,
    required this.totalRounds,
    required this.currentRound,
    required this.currentSeatIndex,
    required this.status,
    required this.winnerId,
    required this.playedTilesCount,
    required this.startedAt,
    required this.finishedAt,
    required this.players,
  });

  factory Game.newDraft({
    required EndMode endMode,
    required ScoringVariant scoringVariant,
    required int? scoreLimit,
    required int? totalRounds,
    required List<GamePlayerSnapshot> players,
  }) {
    return Game(
      id: newId(),
      endMode: endMode,
      scoringVariant: scoringVariant,
      scoreLimit: scoreLimit,
      totalRounds: totalRounds,
      currentRound: 1,
      currentSeatIndex: 0,
      status: GameStatus.inProgress,
      winnerId: null,
      playedTilesCount: 0,
      startedAt: DateTime.now(),
      finishedAt: null,
      players: players,
    );
  }

  final String id;
  final EndMode endMode;
  final ScoringVariant scoringVariant;
  final int? scoreLimit;
  final int? totalRounds;
  final int currentRound;
  final int currentSeatIndex;
  final GameStatus status;
  final String? winnerId;
  final int playedTilesCount;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final List<GamePlayerSnapshot> players;

  GamePlayerSnapshot? get activePlayer => players
      .where((p) => p.seatIndex == currentSeatIndex)
      .cast<GamePlayerSnapshot?>()
      .firstOrNull;

  bool get isFinished => status == GameStatus.finished;
  bool get isInProgress => status == GameStatus.inProgress;

  Game copyWith({
    int? currentRound,
    int? currentSeatIndex,
    GameStatus? status,
    String? winnerId,
    int? playedTilesCount,
    DateTime? finishedAt,
    List<GamePlayerSnapshot>? players,
  }) {
    return Game(
      id: id,
      endMode: endMode,
      scoringVariant: scoringVariant,
      scoreLimit: scoreLimit,
      totalRounds: totalRounds,
      currentRound: currentRound ?? this.currentRound,
      currentSeatIndex: currentSeatIndex ?? this.currentSeatIndex,
      status: status ?? this.status,
      winnerId: winnerId ?? this.winnerId,
      playedTilesCount: playedTilesCount ?? this.playedTilesCount,
      startedAt: startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      players: players ?? this.players,
    );
  }
}
