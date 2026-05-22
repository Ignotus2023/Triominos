import 'game.dart';
import 'move.dart';
import 'round.dart';

class GameDetails {
  const GameDetails({
    required this.game,
    required this.rounds,
    required this.movesByRound,
  });

  final Game game;
  final List<Round> rounds;
  final Map<String, List<Move>> movesByRound;
}

abstract class GameRepository {
  Future<void> createGame(Game game);
  Future<Game?> getGame(String id);
  Stream<Game?> watchGame(String id);
  Stream<List<Game>> watchActiveGames();
  Stream<List<Game>> watchFinishedGames();
  Future<List<Game>> listGames({GameStatus? status});

  Future<void> updateGame(Game game);
  Future<void> abandon(String gameId);

  Future<void> startRound(Round round);
  Future<void> finishRound({
    required String roundId,
    required String? finisherPlayerId,
    required Map<String, int> playerTotalsDelta,
  });

  Stream<List<Round>> watchRounds(String gameId);
  Future<Round?> getRound(String roundId);
  Future<Round?> getCurrentRound(String gameId);

  Stream<List<Move>> watchMovesForRound(String roundId);
  Future<List<Move>> listMovesForRound(String roundId);
  Future<List<Move>> listMovesForGame(String gameId);

  Future<void> recordMove({
    required String gameId,
    required Move move,
    required bool isTilePlay,
  });

  Future<void> deleteMove(String moveId);

  Future<GameDetails?> loadDetails(String gameId);
}
