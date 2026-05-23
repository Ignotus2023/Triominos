import 'package:drift/drift.dart';

import '../../game/game_enums.dart';
import '../app_database.dart';
import '../tables/game_players_table.dart';
import '../tables/games_table.dart';
import '../tables/moves_table.dart';
import '../tables/rounds_table.dart';

part 'games_dao.g.dart';

@DriftAccessor(tables: [Games, GamePlayers, Rounds, Moves])
class GamesDao extends DatabaseAccessor<AppDatabase> with _$GamesDaoMixin {
  GamesDao(super.db);

  // ---- Games ----
  Stream<Game?> watchGame(String id) =>
      (select(games)..where((g) => g.id.equals(id))).watchSingleOrNull();

  Future<Game?> getGame(String id) =>
      (select(games)..where((g) => g.id.equals(id))).getSingleOrNull();

  Stream<Game?> watchActiveGame() => (select(games)
        ..where((g) => g.status.equalsValue(GameStatus.inProgress))
        ..orderBy(
          [(g) => OrderingTerm(expression: g.startedAt, mode: OrderingMode.desc)],
        )
        ..limit(1))
      .watchSingleOrNull();

  Stream<List<Game>> watchFinishedGames() => (select(games)
        ..where((g) => g.status.equalsValue(GameStatus.finished))
        ..orderBy(
          [(g) => OrderingTerm(expression: g.finishedAt, mode: OrderingMode.desc)],
        ))
      .watch();

  // ---- Game players ----
  Stream<List<GamePlayer>> watchGamePlayers(String gameId) => (select(gamePlayers)
        ..where((gp) => gp.gameId.equals(gameId))
        ..orderBy([(gp) => OrderingTerm(expression: gp.seatIndex)]))
      .watch();

  Future<List<GamePlayer>> getGamePlayers(String gameId) => (select(gamePlayers)
        ..where((gp) => gp.gameId.equals(gameId))
        ..orderBy([(gp) => OrderingTerm(expression: gp.seatIndex)]))
      .get();

  // ---- Rounds ----
  Stream<Round?> watchCurrentRound(String gameId) => (select(rounds)
        ..where((r) => r.gameId.equals(gameId))
        ..orderBy(
          [(r) => OrderingTerm(expression: r.roundNumber, mode: OrderingMode.desc)],
        )
        ..limit(1))
      .watchSingleOrNull();

  Future<Round?> getCurrentRound(String gameId) => (select(rounds)
        ..where((r) => r.gameId.equals(gameId))
        ..orderBy(
          [(r) => OrderingTerm(expression: r.roundNumber, mode: OrderingMode.desc)],
        )
        ..limit(1))
      .getSingleOrNull();

  // ---- Moves ----
  Stream<List<MoveRow>> watchMoves(String roundId) => (select(moves)
        ..where((m) => m.roundId.equals(roundId))
        ..orderBy([(m) => OrderingTerm(expression: m.moveIndex)]))
      .watch();

  Future<List<MoveRow>> getMoves(String roundId) => (select(moves)
        ..where((m) => m.roundId.equals(roundId))
        ..orderBy([(m) => OrderingTerm(expression: m.moveIndex)]))
      .get();

  // ---- Composite operations ----

  /// Tworzy nową grę wraz z graczami i pierwszą rundą w jednej transakcji.
  Future<void> createGame({
    required GamesCompanion game,
    required List<GamePlayersCompanion> seats,
    required RoundsCompanion firstRound,
  }) {
    return transaction(() async {
      await into(games).insert(game);
      for (final seat in seats) {
        await into(gamePlayers).insert(seat);
      }
      await into(rounds).insert(firstRound);
    });
  }

  /// Dodaje ruch i aktualizuje sumę punktów gracza atomowo.
  Future<void> addMove({
    required MovesCompanion move,
    required String gameId,
    required String playerId,
    required int delta,
  }) {
    return transaction(() async {
      await into(moves).insert(move);
      await _adjustScore(gameId, playerId, delta);
    });
  }

  /// Cofnięcie ostatniego ruchu w rundzie wraz z korektą punktów.
  Future<void> undoLastMove({
    required String roundId,
    required String gameId,
  }) {
    return transaction(() async {
      final last = await (select(moves)
            ..where((m) => m.roundId.equals(roundId))
            ..orderBy(
              [(m) => OrderingTerm(expression: m.moveIndex, mode: OrderingMode.desc)],
            )
            ..limit(1))
          .getSingleOrNull();
      if (last == null) return;
      await (delete(moves)..where((m) => m.id.equals(last.id))).go();
      await _adjustScore(gameId, last.playerId, -(last.baseScore + last.bonusScore));
    });
  }

  Future<void> startNextRound({
    required String gameId,
    required RoundsCompanion round,
    required int newRoundNumber,
  }) {
    return transaction(() async {
      await into(rounds).insert(round);
      await (update(games)..where((g) => g.id.equals(gameId)))
          .write(GamesCompanion(currentRound: Value(newRoundNumber)));
    });
  }

  Future<void> finishGame({
    required String gameId,
    required String winnerId,
  }) {
    return (update(games)..where((g) => g.id.equals(gameId))).write(
      GamesCompanion(
        status: const Value(GameStatus.finished),
        winnerId: Value(winnerId),
        finishedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> abandonGame(String gameId) {
    return (update(games)..where((g) => g.id.equals(gameId)))
        .write(const GamesCompanion(status: Value(GameStatus.abandoned)));
  }

  Future<void> _adjustScore(String gameId, String playerId, int delta) async {
    final row = await (select(gamePlayers)
          ..where((gp) => gp.gameId.equals(gameId) & gp.playerId.equals(playerId)))
        .getSingle();
    await (update(gamePlayers)
          ..where((gp) => gp.gameId.equals(gameId) & gp.playerId.equals(playerId)))
        .write(GamePlayersCompanion(totalScore: Value(row.totalScore + delta)));
  }
}
