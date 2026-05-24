import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/database/daos/games_dao.dart';
import '../../core/database/database_provider.dart';
import '../../core/game/game_enums.dart';
import '../../core/game/move.dart';
import '../../core/utils/id.dart';

class GameController {
  GameController(this._dao);

  final GamesDao _dao;

  Future<void> addPlay({
    required Game game,
    required Round round,
    required String playerId,
    required Move move,
  }) async {
    final index = (await _dao.getMoves(round.id)).length;
    await _dao.addMove(
      gameId: game.id,
      playerId: playerId,
      delta: move.totalScore,
      move: MovesCompanion.insert(
        id: newId(),
        roundId: round.id,
        playerId: playerId,
        moveIndex: index,
        moveType: MoveType.play,
        corner1: Value(move.corner1),
        corner2: Value(move.corner2),
        corner3: Value(move.corner3),
        baseScore: move.baseScore,
        bonusScore: Value(move.bonusScore),
        isTriplet: Value(move.isTriplet),
        isBridge: Value(move.isBridge),
        isHexagon: Value(move.isHexagon),
        isDoubleHexagon: Value(move.isDoubleHexagon),
        isStarter: Value(move.isStarter),
        createdAt: DateTime.now(),
      ),
    );
    await _maybeFinishOnScoreLimit(game);
  }

  /// W trybie "limit punktów" gra kończy się, gdy ktokolwiek osiągnie próg —
  /// sprawdzane po każdym zagraniu, nie tylko na koniec rundy.
  Future<void> _maybeFinishOnScoreLimit(Game game) async {
    if (game.endMode != EndMode.scoreLimit) return;
    final seats = await _dao.getGamePlayers(game.id);
    if (seats.isEmpty) return;
    final leader = _highest(seats);
    if (leader.totalScore >= (game.scoreLimit ?? 1 << 30)) {
      await _dao.finishGame(gameId: game.id, winnerId: leader.playerId);
    }
  }

  Future<void> addPenalty({
    required Game game,
    required Round round,
    required String playerId,
    required MoveType type,
  }) async {
    assert(type == MoveType.drawPenalty || type == MoveType.passPenalty);
    final move =
        type == MoveType.drawPenalty ? Move.drawPenalty() : Move.passPenalty();
    final index = (await _dao.getMoves(round.id)).length;
    await _dao.addMove(
      gameId: game.id,
      playerId: playerId,
      delta: move.totalScore,
      move: MovesCompanion.insert(
        id: newId(),
        roundId: round.id,
        playerId: playerId,
        moveIndex: index,
        moveType: type,
        baseScore: move.baseScore,
        createdAt: DateTime.now(),
      ),
    );
  }

  /// Kończy rundę: zapisuje bonus za wyjście i ocenia warunek końca gry.
  Future<void> endHand({
    required Game game,
    required Round round,
    required String finisherId,
    required int opponentsHandSum,
  }) async {
    final move = Move.endOfHand(opponentsHandSum: opponentsHandSum);
    final index = (await _dao.getMoves(round.id)).length;
    await _dao.addMove(
      gameId: game.id,
      playerId: finisherId,
      delta: move.totalScore,
      move: MovesCompanion.insert(
        id: newId(),
        roundId: round.id,
        playerId: finisherId,
        moveIndex: index,
        moveType: MoveType.endOfHandBonus,
        baseScore: move.baseScore,
        bonusScore: Value(move.bonusScore),
        createdAt: DateTime.now(),
      ),
    );
    await _dao.setRoundFinisher(roundId: round.id, finisherId: finisherId);
    await _evaluateEnd(game, round);
  }

  Future<void> undo({required Game game, required Round round}) =>
      _dao.undoLastMove(roundId: round.id, gameId: game.id);

  /// Ręczne zakończenie gry (tryb dowolny lub przerwanie przez użytkownika).
  Future<void> finishNow(Game game) async {
    final seats = await _dao.getGamePlayers(game.id);
    if (seats.isEmpty) return;
    await _dao.finishGame(gameId: game.id, winnerId: _highest(seats).playerId);
  }

  Future<void> _evaluateEnd(Game game, Round round) async {
    final seats = await _dao.getGamePlayers(game.id);
    final shouldFinish = switch (game.endMode) {
      EndMode.scoreLimit =>
        seats.any((s) => s.totalScore >= (game.scoreLimit ?? 1 << 30)),
      EndMode.rounds => round.roundNumber >= (game.totalRounds ?? 1),
      EndMode.freeform => false,
    };

    if (shouldFinish) {
      await _dao.finishGame(gameId: game.id, winnerId: _highest(seats).playerId);
    } else {
      final next = round.roundNumber + 1;
      await _dao.startNextRound(
        gameId: game.id,
        newRoundNumber: next,
        round: RoundsCompanion.insert(
          id: newId(),
          gameId: game.id,
          roundNumber: next,
          starterPlayerId: seats.first.playerId,
          startedAt: DateTime.now(),
        ),
      );
    }
  }

  GamePlayer _highest(List<GamePlayer> seats) =>
      seats.reduce((a, b) => b.totalScore > a.totalScore ? b : a);
}

final gameControllerProvider =
    Provider<GameController>((ref) => GameController(ref.watch(gamesDaoProvider)));
