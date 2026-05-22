import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/daos/games_dao.dart';
import '../../../core/database/tables/game_players_table.dart';
import '../../../core/database/tables/games_table.dart' as games_table;
import '../../../core/database/tables/moves_table.dart';
import '../../../core/database/tables/rounds_table.dart';
import '../../../core/game/game_status.dart';
import '../../../core/game/move_input.dart';
import '../domain/game.dart';
import '../domain/game_repository.dart';
import '../domain/move.dart';
import '../domain/round.dart';

class GameRepositoryImpl implements GameRepository {
  GameRepositoryImpl(this._db, this._dao);

  final AppDatabase _db;
  final GamesDao _dao;

  @override
  Future<void> createGame(Game game) async {
    await _db.transaction(() async {
      await _dao.insertGame(_gameToCompanion(game));
      await _dao.insertPlayers(
        game.players.map((p) => _playerToCompanion(game.id, p)).toList(),
      );
    });
  }

  @override
  Future<Game?> getGame(String id) async {
    final row = await _dao.findGame(id);
    if (row == null) return null;
    final players = await _dao.playersFor(id);
    return _gameFromRows(row, players);
  }

  @override
  Stream<Game?> watchGame(String id) {
    return _dao.watchGame(id).asyncMap((row) async {
      if (row == null) return null;
      final players = await _dao.playersFor(id);
      return _gameFromRows(row, players);
    });
  }

  @override
  Stream<List<Game>> watchActiveGames() {
    return _dao
        .watchByStatus(GameStatus.inProgress)
        .asyncMap(_attachPlayers);
  }

  @override
  Stream<List<Game>> watchFinishedGames() {
    return _dao
        .watchByStatus(GameStatus.finished)
        .asyncMap(_attachPlayers);
  }

  @override
  Future<List<Game>> listGames({GameStatus? status}) async {
    final stream = status == null
        ? _dao.watchByStatus(GameStatus.inProgress)
        : _dao.watchByStatus(status);
    final rows = await stream.first;
    return _attachPlayers(rows);
  }

  @override
  Future<void> updateGame(Game game) async {
    await _dao.updateGame(_gameToCompanion(game));
  }

  @override
  Future<void> abandon(String gameId) async {
    final row = await _dao.findGame(gameId);
    if (row == null) return;
    await _dao.updateGame(
      row.toCompanion(true).copyWith(
            status: const Value(GameStatus.abandoned),
            finishedAt: Value(DateTime.now()),
          ),
    );
  }

  @override
  Future<void> startRound(Round round) async {
    await _dao.insertRound(_roundToCompanion(round));
  }

  @override
  Future<void> finishRound({
    required String roundId,
    required String? finisherPlayerId,
    required Map<String, int> playerTotalsDelta,
  }) async {
    await _db.transaction(() async {
      final row = await _dao.findRound(roundId);
      if (row == null) return;
      await _dao.updateRound(
        row.toCompanion(true).copyWith(
              finisherPlayerId: Value(finisherPlayerId),
              finishedAt: Value(DateTime.now()),
            ),
      );
      for (final entry in playerTotalsDelta.entries) {
        await _dao.updatePlayerScore(
          gameId: row.gameId,
          playerId: entry.key,
          delta: entry.value,
        );
      }
    });
  }

  @override
  Stream<List<Round>> watchRounds(String gameId) {
    return _dao.watchRoundsFor(gameId).map(
          (rows) => rows.map(_roundFromRow).toList(growable: false),
        );
  }

  @override
  Future<Round?> getRound(String roundId) async {
    final row = await _dao.findRound(roundId);
    return row == null ? null : _roundFromRow(row);
  }

  @override
  Future<Round?> getCurrentRound(String gameId) async {
    final row = await _dao.findCurrentRound(gameId);
    return row == null ? null : _roundFromRow(row);
  }

  @override
  Stream<List<Move>> watchMovesForRound(String roundId) {
    return _dao
        .watchMovesForRound(roundId)
        .map((rows) => rows.map(_moveFromRow).toList(growable: false));
  }

  @override
  Future<List<Move>> listMovesForRound(String roundId) async {
    final rows = await _dao.listMovesForRound(roundId);
    return rows.map(_moveFromRow).toList(growable: false);
  }

  @override
  Future<List<Move>> listMovesForGame(String gameId) async {
    final rows = await _dao.listMovesForGame(gameId);
    return rows.map(_moveFromRow).toList(growable: false);
  }

  @override
  Future<void> recordMove({
    required String gameId,
    required Move move,
    required bool isTilePlay,
  }) async {
    await _db.transaction(() async {
      await _dao.insertMove(_moveToCompanion(move));
      await _dao.updatePlayerScore(
        gameId: gameId,
        playerId: move.playerId,
        delta: move.totalScore,
      );
      if (isTilePlay) {
        await _dao.incrementPlayedTiles(gameId, 1);
      }
    });
  }

  @override
  Future<void> deleteMove(String moveId) async {
    await _dao.deleteMove(moveId);
  }

  @override
  Future<void> setTurnSeat(String gameId, int seatIndex) async {
    await _dao.setSeat(gameId, seatIndex);
  }

  @override
  Future<void> advanceRound(String gameId, int nextRoundNumber) async {
    await _dao.setCurrentRound(gameId, nextRoundNumber);
  }

  @override
  Future<void> finishGame(String gameId, String? winnerId) async {
    await _dao.finishGame(gameId, winnerId);
  }

  @override
  Future<void> undoMove({required String gameId, required Move move}) async {
    await _db.transaction(() async {
      await _dao.updatePlayerScore(
        gameId: gameId,
        playerId: move.playerId,
        delta: -move.totalScore,
      );
      if (move.type == MoveType.play) {
        await _dao.incrementPlayedTiles(gameId, -1);
      }
      await _dao.deleteMove(move.id);
    });
  }

  @override
  Future<void> replaceMove({
    required String gameId,
    required Move oldMove,
    required Move newMove,
  }) async {
    await _db.transaction(() async {
      await _dao.updatePlayerScore(
        gameId: gameId,
        playerId: oldMove.playerId,
        delta: -oldMove.totalScore,
      );
      final wasPlay = oldMove.type == MoveType.play;
      final isPlay = newMove.type == MoveType.play;
      if (wasPlay && !isPlay) await _dao.incrementPlayedTiles(gameId, -1);
      if (!wasPlay && isPlay) await _dao.incrementPlayedTiles(gameId, 1);
      await _dao.replaceMove(_moveToCompanion(newMove));
      await _dao.updatePlayerScore(
        gameId: gameId,
        playerId: newMove.playerId,
        delta: newMove.totalScore,
      );
    });
  }

  @override
  Future<GameDetails?> loadDetails(String gameId) async {
    final game = await getGame(gameId);
    if (game == null) return null;
    final rounds = await _dao.listRoundsFor(gameId);
    final byRound = <String, List<Move>>{};
    for (final r in rounds) {
      byRound[r.id] = await listMovesForRound(r.id);
    }
    return GameDetails(
      game: game,
      rounds: rounds.map(_roundFromRow).toList(growable: false),
      movesByRound: byRound,
    );
  }

  Future<List<Game>> _attachPlayers(List<games_table.GameRow> rows) async {
    final out = <Game>[];
    for (final row in rows) {
      final players = await _dao.playersFor(row.id);
      out.add(_gameFromRows(row, players));
    }
    return out;
  }

  Game _gameFromRows(
    games_table.GameRow row,
    List<GamePlayerRow> players,
  ) {
    return Game(
      id: row.id,
      endMode: row.endMode,
      scoringVariant: row.scoringVariant,
      scoreLimit: row.scoreLimit,
      totalRounds: row.totalRounds,
      currentRound: row.currentRound,
      currentSeatIndex: row.currentSeatIndex,
      status: row.status,
      winnerId: row.winnerId,
      playedTilesCount: row.playedTilesCount,
      startedAt: row.startedAt,
      finishedAt: row.finishedAt,
      players: players
          .map(
            (p) => GamePlayerSnapshot(
              playerId: p.playerId,
              seatIndex: p.seatIndex,
              displayName: p.displayNameSnapshot,
              avatarColor: p.avatarColorSnapshot,
              initials: p.initialsSnapshot,
              totalScore: p.totalScore,
            ),
          )
          .toList(growable: false),
    );
  }

  games_table.GamesCompanion _gameToCompanion(Game g) {
    return games_table.GamesCompanion(
      id: Value(g.id),
      endMode: Value(g.endMode),
      scoringVariant: Value(g.scoringVariant),
      scoreLimit: Value(g.scoreLimit),
      totalRounds: Value(g.totalRounds),
      currentRound: Value(g.currentRound),
      currentSeatIndex: Value(g.currentSeatIndex),
      status: Value(g.status),
      winnerId: Value(g.winnerId),
      playedTilesCount: Value(g.playedTilesCount),
      startedAt: Value(g.startedAt),
      finishedAt: Value(g.finishedAt),
    );
  }

  GamePlayersCompanion _playerToCompanion(String gameId, GamePlayerSnapshot p) {
    return GamePlayersCompanion(
      gameId: Value(gameId),
      playerId: Value(p.playerId),
      seatIndex: Value(p.seatIndex),
      totalScore: Value(p.totalScore),
      displayNameSnapshot: Value(p.displayName),
      avatarColorSnapshot: Value(p.avatarColor),
      initialsSnapshot: Value(p.initials),
    );
  }

  RoundsCompanion _roundToCompanion(Round r) {
    return RoundsCompanion(
      id: Value(r.id),
      gameId: Value(r.gameId),
      roundNumber: Value(r.roundNumber),
      starterPlayerId: Value(r.starterPlayerId),
      starterByTriplet: Value(r.starterByTriplet),
      finisherPlayerId: Value(r.finisherPlayerId),
      startedAt: Value(r.startedAt),
      finishedAt: Value(r.finishedAt),
    );
  }

  Round _roundFromRow(RoundRow row) {
    return Round(
      id: row.id,
      gameId: row.gameId,
      roundNumber: row.roundNumber,
      starterPlayerId: row.starterPlayerId,
      starterByTriplet: row.starterByTriplet,
      finisherPlayerId: row.finisherPlayerId,
      startedAt: row.startedAt,
      finishedAt: row.finishedAt,
    );
  }

  MovesCompanion _moveToCompanion(Move m) {
    return MovesCompanion(
      id: Value(m.id),
      roundId: Value(m.roundId),
      playerId: Value(m.playerId),
      moveIndex: Value(m.moveIndex),
      moveType: Value(m.type),
      corner1: Value(m.corner1),
      corner2: Value(m.corner2),
      corner3: Value(m.corner3),
      tileKey: Value(m.tileKey),
      baseScore: Value(m.baseScore),
      bonusScore: Value(m.bonusScore),
      opponentsHandSum: Value(m.opponentsHandSum),
      isTriplet: Value(m.isTriplet),
      isBridge: Value(m.isBridge),
      isHexagon: Value(m.isHexagon),
      isDoubleHexagon: Value(m.isDoubleHexagon),
      isStarter: Value(m.isStarter),
      createdAt: Value(m.createdAt),
    );
  }

  Move _moveFromRow(MoveRow row) {
    return Move(
      id: row.id,
      roundId: row.roundId,
      playerId: row.playerId,
      moveIndex: row.moveIndex,
      type: row.moveType,
      corner1: row.corner1,
      corner2: row.corner2,
      corner3: row.corner3,
      tileKey: row.tileKey,
      baseScore: row.baseScore,
      bonusScore: row.bonusScore,
      opponentsHandSum: row.opponentsHandSum,
      isTriplet: row.isTriplet,
      isBridge: row.isBridge,
      isHexagon: row.isHexagon,
      isDoubleHexagon: row.isDoubleHexagon,
      isStarter: row.isStarter,
      createdAt: row.createdAt,
    );
  }
}
