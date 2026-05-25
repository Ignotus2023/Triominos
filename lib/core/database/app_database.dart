import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../game/game_enums.dart';
import '../game/move.dart';
import 'daos/games_dao.dart';
import 'daos/players_dao.dart';
import 'daos/stats_dao.dart';
import 'tables/game_players_table.dart';
import 'tables/games_table.dart';
import 'tables/moves_table.dart';
import 'tables/players_table.dart';
import 'tables/rounds_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Players, Games, GamePlayers, Rounds, Moves],
  daos: [PlayersDao, GamesDao, StatsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(
          driftDatabase(
            name: const String.fromEnvironment(
              'DB_NAME',
              defaultValue: 'triomino_score',
            ),
            web: DriftWebOptions(
              sqlite3Wasm: Uri.parse('sqlite3.wasm'),
              driftWorker: Uri.parse('drift_worker.js'),
            ),
          ),
        );

  /// Konstruktor dla testów (baza w pamięci).
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(players, players.avatarImage);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// Usuwa wszystkie dane (gry i graczy) — opcja "Reset danych" w ustawieniach.
  Future<void> resetAllData() {
    return transaction(() async {
      await delete(moves).go();
      await delete(rounds).go();
      await delete(gamePlayers).go();
      await delete(games).go();
      await delete(players).go();
    });
  }
}
