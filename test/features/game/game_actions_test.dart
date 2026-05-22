import 'package:flutter_test/flutter_test.dart';
import 'package:triomino_score/core/game/end_game_evaluator.dart';
import 'package:triomino_score/core/game/move_input.dart';
import 'package:triomino_score/core/game/scoring_rules.dart';
import 'package:triomino_score/features/game/domain/game.dart';
import 'package:triomino_score/features/game/presentation/game_actions.dart';

import 'fake_game_repository.dart';

Game _twoPlayerGame({
  EndMode endMode = EndMode.scoreLimit,
  int? scoreLimit = 400,
  int? totalRounds,
}) {
  return Game.newDraft(
    endMode: endMode,
    scoringVariant: ScoringVariant.goliath,
    scoreLimit: scoreLimit,
    totalRounds: totalRounds,
    players: const [
      GamePlayerSnapshot(
        playerId: 'a',
        seatIndex: 0,
        displayName: 'Anna',
        avatarColor: '#6366F1',
        initials: 'AN',
        totalScore: 0,
      ),
      GamePlayerSnapshot(
        playerId: 'b',
        seatIndex: 1,
        displayName: 'Bartosz',
        avatarColor: '#A78BFA',
        initials: 'BA',
        totalScore: 0,
      ),
    ],
  );
}

void main() {
  late FakeGameRepository repo;
  late GameActions actions;

  setUp(() {
    repo = FakeGameRepository();
    actions = GameActions(repo);
  });

  test('startRound sets seat to starter and creates round', () async {
    final game = _twoPlayerGame();
    await repo.createGame(game);

    await actions.startRound(gameId: game.id, starterPlayerId: 'b', byTriplet: true);

    final updated = await repo.getGame(game.id);
    expect(updated!.currentSeatIndex, 1);
    final round = await repo.getCurrentRound(game.id);
    expect(round, isNotNull);
    expect(round!.starterPlayerId, 'b');
    expect(round.starterByTriplet, isTrue);
  });

  test('submitMove scores the active player and advances the turn', () async {
    final game = _twoPlayerGame();
    await repo.createGame(game);
    await actions.startRound(gameId: game.id, starterPlayerId: 'a', byTriplet: false);
    final round = (await repo.getCurrentRound(game.id))!;

    await actions.submitMove(
      gameId: game.id,
      round: round,
      input: MoveInput.play(corner1: 5, corner2: 3, corner3: 2),
    );

    final updated = (await repo.getGame(game.id))!;
    expect(updated.players.firstWhere((p) => p.playerId == 'a').totalScore, 10);
    expect(updated.currentSeatIndex, 1);
    expect(updated.playedTilesCount, 1);
  });

  test('starter triplet move stacks base + triplet + starter bonus', () async {
    final game = _twoPlayerGame();
    await repo.createGame(game);
    await actions.startRound(gameId: game.id, starterPlayerId: 'a', byTriplet: true);
    final round = (await repo.getCurrentRound(game.id))!;

    await actions.submitMove(
      gameId: game.id,
      round: round,
      input: MoveInput.play(
        corner1: 5,
        corner2: 5,
        corner3: 5,
        isStarter: true,
      ),
    );

    final score = (await repo.getGame(game.id))!
        .players
        .firstWhere((p) => p.playerId == 'a')
        .totalScore;
    expect(score, 15 + 10 + 10);
  });

  test('turn wraps around back to first seat', () async {
    final game = _twoPlayerGame();
    await repo.createGame(game);
    await actions.startRound(gameId: game.id, starterPlayerId: 'a', byTriplet: false);
    final round = (await repo.getCurrentRound(game.id))!;

    await actions.submitMove(
      gameId: game.id,
      round: round,
      input: MoveInput.play(corner1: 1, corner2: 1, corner3: 1),
    );
    await actions.submitMove(
      gameId: game.id,
      round: round,
      input: MoveInput.play(corner1: 2, corner2: 2, corner3: 2),
    );

    expect((await repo.getGame(game.id))!.currentSeatIndex, 0);
  });

  test('pass penalty subtracts 10 and still advances the turn', () async {
    final game = _twoPlayerGame();
    await repo.createGame(game);
    await actions.startRound(gameId: game.id, starterPlayerId: 'a', byTriplet: false);
    final round = (await repo.getCurrentRound(game.id))!;

    await actions.submitMove(gameId: game.id, round: round, input: MoveInput.pass());

    final updated = (await repo.getGame(game.id))!;
    expect(updated.players.firstWhere((p) => p.playerId == 'a').totalScore, -10);
    expect(updated.currentSeatIndex, 1);
    expect(updated.playedTilesCount, 0);
  });

  test('endRound gives finisher +25 plus opponents hand sums', () async {
    final game = _twoPlayerGame(scoreLimit: 1000);
    await repo.createGame(game);
    await actions.startRound(gameId: game.id, starterPlayerId: 'a', byTriplet: false);
    final round = (await repo.getCurrentRound(game.id))!;

    final decision = await actions.endRound(
      gameId: game.id,
      round: round,
      finisherPlayerId: 'a',
      opponentHandSums: {'b': 14},
    );

    expect(decision.shouldEnd, isFalse);
    final updated = (await repo.getGame(game.id))!;
    expect(updated.players.firstWhere((p) => p.playerId == 'a').totalScore, 25 + 14);
    expect(updated.currentRound, 2);
  });

  test('endRound finishes the game when score limit reached', () async {
    final game = _twoPlayerGame(scoreLimit: 30);
    await repo.createGame(game);
    await actions.startRound(gameId: game.id, starterPlayerId: 'a', byTriplet: false);
    final round = (await repo.getCurrentRound(game.id))!;

    final decision = await actions.endRound(
      gameId: game.id,
      round: round,
      finisherPlayerId: 'a',
      opponentHandSums: {'b': 20},
    );

    expect(decision.shouldEnd, isTrue);
    expect(decision.winnerPlayerId, 'a');
    final updated = (await repo.getGame(game.id))!;
    expect(updated.status, GameStatus.finished);
    expect(updated.winnerId, 'a');
  });

  test('undoLastMove reverses score and returns the turn to that player', () async {
    final game = _twoPlayerGame();
    await repo.createGame(game);
    await actions.startRound(gameId: game.id, starterPlayerId: 'a', byTriplet: false);
    final round = (await repo.getCurrentRound(game.id))!;

    await actions.submitMove(
      gameId: game.id,
      round: round,
      input: MoveInput.play(corner1: 4, corner2: 4, corner3: 4),
    );
    expect((await repo.getGame(game.id))!.currentSeatIndex, 1);

    await actions.undoLastMove(gameId: game.id, round: round);

    final updated = (await repo.getGame(game.id))!;
    expect(updated.players.firstWhere((p) => p.playerId == 'a').totalScore, 0);
    expect(updated.currentSeatIndex, 0);
    expect(updated.playedTilesCount, 0);
    expect(await repo.listMovesForRound(round.id), isEmpty);
  });

  test('editMove recomputes score delta in place', () async {
    final game = _twoPlayerGame();
    await repo.createGame(game);
    await actions.startRound(gameId: game.id, starterPlayerId: 'a', byTriplet: false);
    final round = (await repo.getCurrentRound(game.id))!;
    await actions.submitMove(
      gameId: game.id,
      round: round,
      input: MoveInput.play(corner1: 1, corner2: 2, corner3: 3),
    );
    final original = (await repo.listMovesForRound(round.id)).single;
    expect((await repo.getGame(game.id))!.players.firstWhere((p) => p.playerId == 'a').totalScore, 6);

    await actions.editMove(
      gameId: game.id,
      oldMove: original,
      input: MoveInput.play(corner1: 5, corner2: 5, corner3: 5),
    );

    final updated = (await repo.getGame(game.id))!;
    expect(updated.players.firstWhere((p) => p.playerId == 'a').totalScore, 15 + 10);
    final moves = await repo.listMovesForRound(round.id);
    expect(moves.length, 1);
    expect(moves.single.id, original.id);
  });
}
