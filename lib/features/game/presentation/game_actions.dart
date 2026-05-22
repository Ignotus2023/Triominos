import '../../../core/game/end_game_evaluator.dart';
import '../../../core/game/move_input.dart';
import '../../../core/game/score_calculator.dart';
import '../../../core/game/scoring_rules.dart';
import '../domain/game.dart';
import '../domain/game_repository.dart';
import '../domain/move.dart';
import '../domain/round.dart';

class GameActions {
  GameActions(this._repo);

  final GameRepository _repo;

  Future<void> startRound({
    required String gameId,
    required String starterPlayerId,
    required bool byTriplet,
  }) async {
    final game = await _repo.getGame(gameId);
    if (game == null) return;
    final starterSeat = game.players
        .firstWhere((p) => p.playerId == starterPlayerId)
        .seatIndex;
    final round = Round.start(
      gameId: gameId,
      roundNumber: game.currentRound,
      starterPlayerId: starterPlayerId,
      starterByTriplet: byTriplet,
    );
    await _repo.startRound(round);
    await _repo.setTurnSeat(gameId, starterSeat);
  }

  Future<void> submitMove({
    required String gameId,
    required Round round,
    required MoveInput input,
  }) async {
    final game = await _repo.getGame(gameId);
    final active = game?.activePlayer;
    if (game == null || active == null) return;

    final breakdown = ScoreCalculator(
      ScoringRules.forVariant(game.scoringVariant),
    ).calculate(input);
    final existing = await _repo.listMovesForRound(round.id);
    final move = Move.fromInput(
      roundId: round.id,
      playerId: active.playerId,
      moveIndex: existing.length,
      input: input,
      breakdown: breakdown,
    );
    await _repo.recordMove(
      gameId: gameId,
      move: move,
      isTilePlay: input.type == MoveType.play,
    );
    await _advanceTurn(game);
  }

  Future<void> _advanceTurn(Game game) async {
    final next = (game.currentSeatIndex + 1) % game.players.length;
    await _repo.setTurnSeat(game.id, next);
  }

  Future<EndGameDecision> endRound({
    required String gameId,
    required Round round,
    required String finisherPlayerId,
    required Map<String, int> opponentHandSums,
  }) async {
    final game = await _repo.getGame(gameId);
    if (game == null) return const EndGameDecision(shouldEnd: false);

    final rules = ScoringRules.forVariant(game.scoringVariant);
    final totalOpponents =
        opponentHandSums.values.fold<int>(0, (sum, v) => sum + v);
    final input = MoveInput.endOfHand(opponentsHandSum: totalOpponents);
    final breakdown = ScoreCalculator(rules).calculate(input);
    final existing = await _repo.listMovesForRound(round.id);
    final move = Move.fromInput(
      roundId: round.id,
      playerId: finisherPlayerId,
      moveIndex: existing.length,
      input: input,
      breakdown: breakdown,
    );
    await _repo.recordMove(gameId: gameId, move: move, isTilePlay: false);
    await _repo.finishRound(
      roundId: round.id,
      finisherPlayerId: finisherPlayerId,
      playerTotalsDelta: const {},
    );

    final updated = await _repo.getGame(gameId);
    if (updated == null) return const EndGameDecision(shouldEnd: false);
    final standings = updated.players
        .map((p) => PlayerStanding(playerId: p.playerId, totalScore: p.totalScore))
        .toList();
    final decision = const EndGameEvaluator().evaluate(
      mode: updated.endMode,
      currentRoundNumber: updated.currentRound,
      scoreLimit: updated.scoreLimit,
      totalRounds: updated.totalRounds,
      standings: standings,
      roundJustFinished: true,
    );

    if (decision.shouldEnd) {
      await _repo.finishGame(gameId, decision.winnerPlayerId);
    } else {
      await _repo.advanceRound(gameId, updated.currentRound + 1);
    }
    return decision;
  }

  Future<void> undoLastMove({required String gameId, required Round round}) async {
    final moves = await _repo.listMovesForRound(round.id);
    if (moves.isEmpty) return;
    final last = moves.last;
    await _repo.undoMove(gameId: gameId, move: last);
    final game = await _repo.getGame(gameId);
    if (game == null) return;
    final seat = game.players
        .firstWhere((p) => p.playerId == last.playerId)
        .seatIndex;
    await _repo.setTurnSeat(gameId, seat);
  }

  Future<void> editMove({
    required String gameId,
    required Move oldMove,
    required MoveInput input,
  }) async {
    final game = await _repo.getGame(gameId);
    if (game == null) return;
    final breakdown = ScoreCalculator(
      ScoringRules.forVariant(game.scoringVariant),
    ).calculate(input);
    final newMove = Move.fromInput(
      roundId: oldMove.roundId,
      playerId: oldMove.playerId,
      moveIndex: oldMove.moveIndex,
      input: input,
      breakdown: breakdown,
    ).withId(oldMove.id);
    await _repo.replaceMove(gameId: gameId, oldMove: oldMove, newMove: newMove);
  }

  Future<void> endGameManually({required String gameId}) async {
    final game = await _repo.getGame(gameId);
    if (game == null) return;
    String? winnerId;
    var best = -1 << 31;
    for (final p in game.players) {
      if (p.totalScore > best) {
        best = p.totalScore;
        winnerId = p.playerId;
      }
    }
    await _repo.finishGame(gameId, winnerId);
  }

  Future<String> rematch({required String gameId}) async {
    final old = await _repo.getGame(gameId);
    if (old == null) throw StateError('Game $gameId not found');
    final players = old.players
        .map(
          (p) => GamePlayerSnapshot(
            playerId: p.playerId,
            seatIndex: p.seatIndex,
            displayName: p.displayName,
            avatarColor: p.avatarColor,
            initials: p.initials,
            totalScore: 0,
          ),
        )
        .toList();
    final next = Game.newDraft(
      endMode: old.endMode,
      scoringVariant: old.scoringVariant,
      scoreLimit: old.scoreLimit,
      totalRounds: old.totalRounds,
      players: players,
    );
    await _repo.createGame(next);
    return next.id;
  }
}
