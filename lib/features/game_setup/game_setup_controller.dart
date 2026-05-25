import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/database/daos/games_dao.dart';
import '../../core/database/database_provider.dart';
import '../../core/game/game_enums.dart';
import '../../core/utils/id.dart';

class GameSetupController {
  GameSetupController(this._dao);

  final GamesDao _dao;

  /// Tworzy nową grę z wybranymi graczami i zwraca jej identyfikator.
  Future<String> createGame({
    required List<Player> players,
    required EndMode endMode,
    int? scoreLimit,
    int? totalRounds,
    String? starterPlayerId,
  }) async {
    final gameId = newId();
    final now = DateTime.now();
    final starter = starterPlayerId ?? players.first.id;

    await _dao.createGame(
      game: GamesCompanion.insert(
        id: gameId,
        endMode: endMode,
        status: GameStatus.inProgress,
        startedAt: now,
        scoreLimit: Value(endMode == EndMode.scoreLimit ? scoreLimit : null),
        totalRounds: Value(endMode == EndMode.rounds ? totalRounds : null),
      ),
      seats: [
        for (var i = 0; i < players.length; i++)
          GamePlayersCompanion.insert(
            gameId: gameId,
            playerId: players[i].id,
            seatIndex: i,
            displayNameSnapshot: players[i].name,
          ),
      ],
      firstRound: RoundsCompanion.insert(
        id: newId(),
        gameId: gameId,
        roundNumber: 1,
        starterPlayerId: starter,
        startedAt: now,
      ),
    );
    return gameId;
  }

  /// Tworzy nową grę z tym samym składem i trybem co podana gra.
  /// Zwraca id nowej gry, albo null gdy zostało mniej niż 2 graczy
  /// (np. profile usunięto).
  Future<String?> rematchFrom(String gameId, List<Player> allPlayers) async {
    final game = await _dao.getGame(gameId);
    if (game == null) return null;
    final seats = await _dao.getGamePlayers(gameId);
    final players = <Player>[];
    for (final seat in seats) {
      final match = allPlayers.where((p) => p.id == seat.playerId);
      if (match.isNotEmpty) players.add(match.first);
    }
    if (players.length < 2) return null;
    return createGame(
      players: players,
      endMode: game.endMode,
      scoreLimit: game.scoreLimit,
      totalRounds: game.totalRounds,
    );
  }
}

final gameSetupControllerProvider = Provider<GameSetupController>(
  (ref) => GameSetupController(ref.watch(gamesDaoProvider)),
);
