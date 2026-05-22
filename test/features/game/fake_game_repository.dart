import 'package:triomino_score/core/game/move_input.dart';
import 'package:triomino_score/features/game/domain/game.dart';
import 'package:triomino_score/features/game/domain/game_repository.dart';
import 'package:triomino_score/features/game/domain/move.dart';
import 'package:triomino_score/features/game/domain/round.dart';

class FakeGameRepository implements GameRepository {
  final Map<String, Game> games = {};
  final Map<String, Round> rounds = {};
  final Map<String, List<Move>> movesByRound = {};

  @override
  Future<void> createGame(Game game) async {
    games[game.id] = game;
  }

  @override
  Future<Game?> getGame(String id) async => games[id];

  void _adjustScore(String gameId, String playerId, int delta) {
    final game = games[gameId]!;
    games[gameId] = game.copyWith(
      players: game.players
          .map((p) => p.playerId == playerId
              ? p.copyWith(totalScore: p.totalScore + delta)
              : p)
          .toList(),
    );
  }

  @override
  Future<void> recordMove({
    required String gameId,
    required Move move,
    required bool isTilePlay,
  }) async {
    movesByRound.putIfAbsent(move.roundId, () => []).add(move);
    _adjustScore(gameId, move.playerId, move.totalScore);
    if (isTilePlay) {
      final game = games[gameId]!;
      games[gameId] = game.copyWith(playedTilesCount: game.playedTilesCount + 1);
    }
  }

  @override
  Future<void> setTurnSeat(String gameId, int seatIndex) async {
    games[gameId] = games[gameId]!.copyWith(currentSeatIndex: seatIndex);
  }

  @override
  Future<void> advanceRound(String gameId, int nextRoundNumber) async {
    games[gameId] = games[gameId]!.copyWith(currentRound: nextRoundNumber);
  }

  @override
  Future<void> finishGame(String gameId, String? winnerId) async {
    games[gameId] = games[gameId]!.copyWith(
      status: GameStatus.finished,
      winnerId: winnerId,
      finishedAt: DateTime.now(),
    );
  }

  @override
  Future<void> startRound(Round round) async {
    rounds[round.id] = round;
  }

  @override
  Future<void> finishRound({
    required String roundId,
    required String? finisherPlayerId,
    required Map<String, int> playerTotalsDelta,
  }) async {
    final round = rounds[roundId]!;
    rounds[roundId] = round.copyWith(
      finisherPlayerId: finisherPlayerId,
      finishedAt: DateTime.now(),
    );
    final gameId = round.gameId;
    playerTotalsDelta.forEach((playerId, delta) => _adjustScore(gameId, playerId, delta));
  }

  @override
  Future<Round?> getCurrentRound(String gameId) async {
    final open = rounds.values.where((r) => r.gameId == gameId && !r.isFinished).toList()
      ..sort((a, b) => b.roundNumber.compareTo(a.roundNumber));
    return open.isEmpty ? null : open.first;
  }

  @override
  Future<Round?> getRound(String roundId) async => rounds[roundId];

  @override
  Future<List<Move>> listMovesForRound(String roundId) async {
    return List.of(movesByRound[roundId] ?? const []);
  }

  @override
  Future<void> undoMove({required String gameId, required Move move}) async {
    _adjustScore(gameId, move.playerId, -move.totalScore);
    if (move.type == MoveType.play) {
      final game = games[gameId]!;
      games[gameId] = game.copyWith(playedTilesCount: game.playedTilesCount - 1);
    }
    movesByRound[move.roundId]?.removeWhere((m) => m.id == move.id);
  }

  @override
  Future<void> replaceMove({
    required String gameId,
    required Move oldMove,
    required Move newMove,
  }) async {
    _adjustScore(gameId, oldMove.playerId, -oldMove.totalScore);
    final list = movesByRound[oldMove.roundId]!;
    final idx = list.indexWhere((m) => m.id == oldMove.id);
    list[idx] = newMove;
    _adjustScore(gameId, newMove.playerId, newMove.totalScore);
  }

  @override
  Future<void> deleteMove(String moveId) async {
    for (final list in movesByRound.values) {
      list.removeWhere((m) => m.id == moveId);
    }
  }

  @override
  Future<void> updateGame(Game game) async => games[game.id] = game;

  @override
  Future<void> abandon(String gameId) async {}

  @override
  Future<List<Move>> listMovesForGame(String gameId) async => const [];

  @override
  Future<List<Game>> listGames({GameStatus? status}) async => games.values.toList();

  @override
  Future<GameDetails?> loadDetails(String gameId) async => null;

  @override
  Stream<Game?> watchGame(String id) => Stream.value(games[id]);

  @override
  Stream<List<Game>> watchActiveGames() => Stream.value(const []);

  @override
  Stream<List<Game>> watchFinishedGames() => Stream.value(const []);

  @override
  Stream<List<Round>> watchRounds(String gameId) {
    return Stream.value(rounds.values.where((r) => r.gameId == gameId).toList());
  }

  @override
  Stream<List<Move>> watchMovesForRound(String roundId) {
    return Stream.value(List.of(movesByRound[roundId] ?? const []));
  }
}
