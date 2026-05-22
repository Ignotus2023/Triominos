import 'package:drift/drift.dart';

import '../../game/game_status.dart';
import '../app_database.dart';
import '../tables/game_players_table.dart';
import '../tables/games_table.dart';
import '../tables/moves_table.dart';
import '../tables/rounds_table.dart';

part 'games_dao.g.dart';

@DriftAccessor(tables: [Games, GamePlayers, Rounds, Moves])
class GamesDao extends DatabaseAccessor<AppDatabase> with _$GamesDaoMixin {
  GamesDao(super.db);

  Stream<List<GameRow>> watchByStatus(GameStatus status) {
    final query = select(games)
      ..where((t) => t.status.equalsValue(status))
      ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]);
    return query.watch();
  }

  Stream<GameRow?> watchGame(String id) {
    return (select(games)..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  Future<GameRow?> findGame(String id) {
    return (select(games)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertGame(GamesCompanion entry) async {
    await into(games).insert(entry);
  }

  Future<void> updateGame(GamesCompanion entry) async {
    await update(games).replace(entry);
  }

  Future<void> insertPlayers(List<GamePlayersCompanion> entries) async {
    await batch((b) => b.insertAll(gamePlayers, entries));
  }

  Future<List<GamePlayerRow>> playersFor(String gameId) {
    final query = select(gamePlayers)
      ..where((t) => t.gameId.equals(gameId))
      ..orderBy([(t) => OrderingTerm.asc(t.seatIndex)]);
    return query.get();
  }

  Stream<List<GamePlayerRow>> watchPlayersFor(String gameId) {
    final query = select(gamePlayers)
      ..where((t) => t.gameId.equals(gameId))
      ..orderBy([(t) => OrderingTerm.asc(t.seatIndex)]);
    return query.watch();
  }

  Future<void> updatePlayerScore({
    required String gameId,
    required String playerId,
    required int delta,
  }) {
    return customStatement(
      'UPDATE game_players SET total_score = total_score + ? '
      'WHERE game_id = ? AND player_id = ?',
      [delta, gameId, playerId],
    );
  }

  Future<void> insertRound(RoundsCompanion entry) async {
    await into(rounds).insert(entry);
  }

  Future<void> updateRound(RoundsCompanion entry) async {
    await update(rounds).replace(entry);
  }

  Future<RoundRow?> findRound(String roundId) {
    return (select(rounds)..where((t) => t.id.equals(roundId))).getSingleOrNull();
  }

  Stream<List<RoundRow>> watchRoundsFor(String gameId) {
    final query = select(rounds)
      ..where((t) => t.gameId.equals(gameId))
      ..orderBy([(t) => OrderingTerm.asc(t.roundNumber)]);
    return query.watch();
  }

  Future<RoundRow?> findCurrentRound(String gameId) {
    final query = select(rounds)
      ..where((t) => t.gameId.equals(gameId) & t.finishedAt.isNull())
      ..orderBy([(t) => OrderingTerm.desc(t.roundNumber)])
      ..limit(1);
    return query.getSingleOrNull();
  }

  Future<List<RoundRow>> listRoundsFor(String gameId) {
    return (select(rounds)..where((t) => t.gameId.equals(gameId))).get();
  }

  Future<void> insertMove(MovesCompanion entry) async {
    await into(moves).insert(entry);
  }

  Future<void> deleteMove(String moveId) {
    return (delete(moves)..where((t) => t.id.equals(moveId))).go();
  }

  Stream<List<MoveRow>> watchMovesForRound(String roundId) {
    final query = select(moves)
      ..where((t) => t.roundId.equals(roundId))
      ..orderBy([(t) => OrderingTerm.asc(t.moveIndex)]);
    return query.watch();
  }

  Future<List<MoveRow>> listMovesForRound(String roundId) {
    final query = select(moves)
      ..where((t) => t.roundId.equals(roundId))
      ..orderBy([(t) => OrderingTerm.asc(t.moveIndex)]);
    return query.get();
  }

  Future<List<MoveRow>> listMovesForGame(String gameId) async {
    final rounds = await listRoundsFor(gameId);
    if (rounds.isEmpty) return const [];
    final ids = rounds.map((r) => r.id).toList();
    final query = select(moves)
      ..where((t) => t.roundId.isIn(ids))
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]);
    return query.get();
  }

  Future<int> incrementPlayedTiles(String gameId, int delta) {
    return customStatement(
      'UPDATE games SET played_tiles_count = played_tiles_count + ? WHERE id = ?',
      [delta, gameId],
    );
  }
}
