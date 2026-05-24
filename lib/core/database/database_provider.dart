import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';
import 'daos/games_dao.dart';
import 'daos/players_dao.dart';
import 'daos/stats_dao.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final playersDaoProvider =
    Provider<PlayersDao>((ref) => ref.watch(databaseProvider).playersDao);

final gamesDaoProvider =
    Provider<GamesDao>((ref) => ref.watch(databaseProvider).gamesDao);

final statsDaoProvider =
    Provider<StatsDao>((ref) => ref.watch(databaseProvider).statsDao);
