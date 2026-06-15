import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:triomino_score/core/game/game_enums.dart';
import 'package:triomino_score/core/game/move.dart';
import 'package:triomino_score/core/database/app_database.dart';
import 'package:triomino_score/features/players/players_providers.dart';

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

  test(
    'soft-delete: gracz z historią jest archiwizowany, nie usuwany',
    () async {
      await seedGame();
      final service = PlayersService(db.playersDao, db.gamesDao);

      await service.delete('p1');

      // Zniknął z list, ale wiersz i powiązanie w game_players pozostają.
      expect((await db.playersDao.getAll()).any((p) => p.id == 'p1'), isFalse);
      expect((await db.playersDao.getById('p1'))?.deletedAt, isNotNull);
      final seats = await db.gamesDao.getGamePlayers('g1');
      expect(seats.any((s) => s.playerId == 'p1'), isTrue);
    },
  );

  test('hard-delete: gracz bez historii jest usuwany całkowicie', () async {
    await db.playersDao.upsert(player('p9', 'Solo'));
    final service = PlayersService(db.playersDao, db.gamesDao);

    await service.delete('p9');

    expect(await db.playersDao.getById('p9'), isNull);
  });

  test('nextMoveIndex rośnie i maleje po undo', () async {
    await seedGame();
    expect(await db.gamesDao.nextMoveIndex('r1'), 0);

    final move = Move.play(corner1: 1, corner2: 2, corner3: 3);
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
        baseScore: move.baseScore,
        createdAt: DateTime.now(),
      ),
    );
    expect(await db.gamesDao.nextMoveIndex('r1'), 1);

    await db.gamesDao.undoLastMove(roundId: 'r1', gameId: 'g1');
    expect(await db.gamesDao.nextMoveIndex('r1'), 0);
  });

  test('watchBestScore liczy tylko gry zakończone', () async {
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
        baseScore: move.baseScore,
        bonusScore: Value(move.bonusScore),
        isTriplet: const Value(true),
        isStarter: const Value(true),
        createdAt: DateTime.now(),
      ),
    );

    expect(await db.statsDao.watchBestScore().first, 0);
    await db.gamesDao.finishGame(gameId: 'g1', winnerId: 'p1');
    expect(await db.statsDao.watchBestScore().first, 35);
  });

  test('watchTotalHexagons wlicza podwójny hexagon', () async {
    await seedGame();
    final move = Move.play(
      corner1: 1,
      corner2: 2,
      corner3: 3,
      isDoubleHexagon: true,
    );
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
        baseScore: move.baseScore,
        bonusScore: Value(move.bonusScore),
        isDoubleHexagon: const Value(true),
        createdAt: DateTime.now(),
      ),
    );

    expect(await db.statsDao.watchTotalHexagons().first, 1);
  });

  test(
    'migracja v1->v2 dodaje kolumnę deletedAt do istniejącej bazy',
    () async {
      // Symuluje bazę w schemacie v1 (bez kolumny deletedAt, user_version = 1).
      final migrated = AppDatabase.forTesting(
        NativeDatabase.memory(
          setup: (raw) {
            raw.execute('''
            CREATE TABLE players (
              id TEXT NOT NULL PRIMARY KEY,
              name TEXT NOT NULL,
              avatar_color TEXT NOT NULL,
              initials TEXT NOT NULL,
              created_at INTEGER NOT NULL,
              updated_at INTEGER NOT NULL
            );
          ''');
            raw.execute('PRAGMA user_version = 1;');
          },
        ),
      );
      addTearDown(migrated.close);

      // Pierwsze zapytanie wyzwala onUpgrade (1 -> 2 = addColumn deletedAt).
      await migrated.playersDao.upsert(player('pm', 'Mig'));
      final p = await migrated.playersDao.getById('pm');
      expect(p, isNotNull);
      expect(p!.deletedAt, isNull);
    },
  );
}
