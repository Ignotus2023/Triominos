import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/games_dao.dart';
import 'daos/players_dao.dart';
import 'tables/game_players_table.dart';
import 'tables/games_table.dart';
import 'tables/moves_table.dart';
import 'tables/players_table.dart';
import 'tables/rounds_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Players, Games, GamePlayers, Rounds, Moves],
  daos: [PlayersDao, GamesDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {},
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON;');
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'triomino_score.sqlite'));
    return NativeDatabase.createInBackground(file, logStatements: false);
  });
}
