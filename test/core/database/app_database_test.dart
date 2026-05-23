import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:triomino_score/core/game/game_enums.dart';
import 'package:triomino_score/core/game/move.dart';
import 'package:triomino_score/core/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  PlayersCompanion player(String id, String name) => PlayersCompanion.insert(
        id: id,
        name: name,
        avatarColor: '#6366F1',
        initials: name.substring(0, 1),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  Future<void> seedGame() async {
    await db.playersDao.upsert(player('p1', 'Anna'));
    await db.playersDao.upsert(player('p2', 'Bob'));
    await db.gamesDao.createGame(
      game: GamesCompanion.insert(
        id: 'g1',
        endMode: EndMode.scoreLimit,
        scoreLimit: const Value(400),
        status: GameStatus.inProgress,
        startedAt: DateTime.now(),
      ),
      seats: [
        GamePlayersCompanion.insert(
          gameId: 'g1',
          playerId: 'p1',
          seatIndex: 0,
          displayNameSnapshot: 'Anna',
        ),
        GamePlayersCompanion.insert(
          gameId: 'g1',
          playerId: 'p2',
          seatIndex: 1,
          displayNameSnapshot: 'Bob',
        ),
      ],
      firstRound: RoundsCompanion.insert(
        id: 'r1',
        gameId: 'g1',
        roundNumber: 1,
        starterPlayerId: 'p1',
        startedAt: DateTime.now(),
      ),
    );
  }

  test('zapisuje i pobiera graczy', () async {
    await db.playersDao.upsert(player('p1', 'Anna'));
    final all = await db.playersDao.getAll();
    expect(all.single.name, 'Anna');
  });

  test('tworzy grę z graczami i pierwszą rundą', () async {
    await seedGame();
    final seats = await db.gamesDao.getGamePlayers('g1');
    expect(seats.length, 2);
    expect(seats.every((s) => s.totalScore == 0), isTrue);
    final round = await db.gamesDao.getCurrentRound('g1');
    expect(round!.roundNumber, 1);
  });

  test('dodanie ruchu aktualizuje sumę punktów gracza', () async {
    await seedGame();
    final move = Move.play(corner1: 5, corner2: 5, corner3: 5, isStarter: true);
    await db.gamesDao.addMove(
      gameId: 'g1',
      playerId: 'p1',
      delta: move.totalScore,
      move: MovesCompanion.insert(
        id: 'm1',
        roundId: 'r1',
        playerId: 'p1',
        moveIndex: 0,
        moveType: MoveType.play,
        corner1: const Value(5),
        corner2: const Value(5),
        corner3: const Value(5),
        baseScore: move.baseScore,
        bonusScore: Value(move.bonusScore),
        isTriplet: const Value(true),
        isStarter: const Value(true),
        createdAt: DateTime.now(),
      ),
    );

    final seats = await db.gamesDao.getGamePlayers('g1');
    final anna = seats.firstWhere((s) => s.playerId == 'p1');
    expect(anna.totalScore, 35);
    final moves = await db.gamesDao.getMoves('r1');
    expect(moves.length, 1);
  });

  test('undo cofa ostatni ruch i koryguje punkty', () async {
    await seedGame();
    final move = Move.play(corner1: 4, corner2: 4, corner3: 4);
    await db.gamesDao.addMove(
      gameId: 'g1',
      playerId: 'p1',
      delta: move.totalScore,
      move: MovesCompanion.insert(
        id: 'm1',
        roundId: 'r1',
        playerId: 'p1',
        moveIndex: 0,
        moveType: MoveType.play,
        corner1: const Value(4),
        corner2: const Value(4),
        corner3: const Value(4),
        baseScore: move.baseScore,
        bonusScore: Value(move.bonusScore),
        isTriplet: const Value(true),
        createdAt: DateTime.now(),
      ),
    );
    await db.gamesDao.undoLastMove(roundId: 'r1', gameId: 'g1');

    final seats = await db.gamesDao.getGamePlayers('g1');
    expect(seats.firstWhere((s) => s.playerId == 'p1').totalScore, 0);
    expect(await db.gamesDao.getMoves('r1'), isEmpty);
  });

  test('finishGame ustawia status i zwycięzcę', () async {
    await seedGame();
    await db.gamesDao.finishGame(gameId: 'g1', winnerId: 'p1');
    final game = await db.gamesDao.getGame('g1');
    expect(game!.status, GameStatus.finished);
    expect(game.winnerId, 'p1');
  });
}
