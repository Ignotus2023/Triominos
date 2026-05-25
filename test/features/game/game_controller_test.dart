import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:triomino_score/core/database/app_database.dart';
import 'package:triomino_score/core/game/game_enums.dart';
import 'package:triomino_score/core/game/move.dart';
import 'package:triomino_score/core/game/scoring_config.dart';
import 'package:triomino_score/features/game/game_controller.dart';

void main() {
  late AppDatabase db;
  late GameController controller;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    controller = GameController(db.gamesDao, ScoringConfig.standard);
  });
  tearDown(() => db.close());

  Future<void> seed({
    required EndMode endMode,
    int? scoreLimit,
    int? totalRounds,
  }) async {
    final now = DateTime.now();
    for (final id in ['p1', 'p2']) {
      await db.playersDao.upsert(
        PlayersCompanion.insert(
          id: id,
          name: id,
          avatarColor: '#6366F1',
          initials: id.toUpperCase(),
          createdAt: now,
          updatedAt: now,
        ),
      );
    }
    await db.gamesDao.createGame(
      game: GamesCompanion.insert(
        id: 'g1',
        endMode: endMode,
        status: GameStatus.inProgress,
        startedAt: now,
        scoreLimit: Value(scoreLimit),
        totalRounds: Value(totalRounds),
      ),
      seats: [
        GamePlayersCompanion.insert(
          gameId: 'g1',
          playerId: 'p1',
          seatIndex: 0,
          displayNameSnapshot: 'p1',
        ),
        GamePlayersCompanion.insert(
          gameId: 'g1',
          playerId: 'p2',
          seatIndex: 1,
          displayNameSnapshot: 'p2',
        ),
      ],
      firstRound: RoundsCompanion.insert(
        id: 'r1',
        gameId: 'g1',
        roundNumber: 1,
        starterPlayerId: 'p1',
        startedAt: now,
      ),
    );
  }

  Future<(Game, Round)> current() async {
    final game = (await db.gamesDao.getGame('g1'))!;
    final round = (await db.gamesDao.getCurrentRound('g1'))!;
    return (game, round);
  }

  test('addPlay sumuje punkty, addPenalty je odejmuje', () async {
    await seed(endMode: EndMode.freeform);
    final (game, round) = await current();

    await controller.addPlay(
      game: game,
      round: round,
      playerId: 'p1',
      move: Move.play(corner1: 4, corner2: 4, corner3: 4),
    );
    await controller.addPenalty(
      game: game,
      round: round,
      playerId: 'p1',
      type: MoveType.passPenalty,
    );

    final seats = await db.gamesDao.getGamePlayers('g1');
    expect(seats.firstWhere((s) => s.playerId == 'p1').totalScore, 22 - 10);
  });

  test('editMove zmienia zagranie i koryguje punkty o różnicę', () async {
    await seed(endMode: EndMode.freeform);
    final (game, round) = await current();
    await controller.addPlay(
      game: game,
      round: round,
      playerId: 'p1',
      move: Move.play(corner1: 4, corner2: 4, corner3: 4),
    );
    final original = (await db.gamesDao.getMoves('r1')).single;

    await controller.editMove(
      game: game,
      original: original,
      updated: Move.play(corner1: 5, corner2: 5, corner3: 5),
    );

    // 4-4-4 (12+10=22) -> 5-5-5 (15+10=25): różnica +3.
    final seats = await db.gamesDao.getGamePlayers('g1');
    expect(seats.firstWhere((s) => s.playerId == 'p1').totalScore, 25);
    final updated = (await db.gamesDao.getMoves('r1')).single;
    expect(updated.corner1, 5);
    expect(updated.baseScore + updated.bonusScore, 25);
  });

  test('tryb scoreLimit NIE kończy się automatycznie po przekroczeniu progu',
      () async {
    await seed(endMode: EndMode.scoreLimit, scoreLimit: 30);
    final (game, round) = await current();

    await controller.addPlay(
      game: game,
      round: round,
      playerId: 'p1',
      move: Move.play(corner1: 5, corner2: 5, corner3: 1, isHexagon: true),
    );

    final updated = (await db.gamesDao.getGame('g1'))!;
    expect(updated.status, GameStatus.inProgress);
  });

  test('finishNow kończy grę i wybiera lidera jako zwycięzcę', () async {
    await seed(endMode: EndMode.scoreLimit, scoreLimit: 30);
    final (game, round) = await current();

    await controller.addPlay(
      game: game,
      round: round,
      playerId: 'p1',
      move: Move.play(corner1: 5, corner2: 5, corner3: 1, isHexagon: true),
    );
    await controller.finishNow(game);

    final updated = (await db.gamesDao.getGame('g1'))!;
    expect(updated.status, GameStatus.finished);
    expect(updated.winnerId, 'p1');
  });

  test('tryb rounds rozpoczyna kolejną rundę, dopóki nie osiągnie limitu',
      () async {
    await seed(endMode: EndMode.rounds, totalRounds: 2);
    var (game, round) = await current();

    await controller.endHand(
      game: game,
      round: round,
      finisherId: 'p1',
      opponentsHandSum: 5,
    );

    var updated = (await db.gamesDao.getGame('g1'))!;
    expect(updated.status, GameStatus.inProgress);
    expect(updated.currentRound, 2);

    (game, round) = await current();
    expect(round.roundNumber, 2);

    await controller.endHand(
      game: game,
      round: round,
      finisherId: 'p2',
      opponentsHandSum: 5,
    );
    updated = (await db.gamesDao.getGame('g1'))!;
    expect(updated.status, GameStatus.finished);
  });
}
