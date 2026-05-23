import 'package:drift/drift.dart';

import '../../game/game_enums.dart';
import '../app_database.dart';
import '../tables/game_players_table.dart';
import '../tables/games_table.dart';
import '../tables/moves_table.dart';

part 'stats_dao.g.dart';

@DriftAccessor(tables: [Games, GamePlayers, Moves])
class StatsDao extends DatabaseAccessor<AppDatabase> with _$StatsDaoMixin {
  StatsDao(super.db);

  Stream<int> watchTotalFinishedGames() {
    final cnt = countAll();
    final query = selectOnly(games)
      ..addColumns([cnt])
      ..where(games.status.equalsValue(GameStatus.finished));
    return query.map((row) => row.read(cnt) ?? 0).watchSingle();
  }

  Stream<int> watchBestScore() {
    final maxScore = gamePlayers.totalScore.max();
    final query = selectOnly(gamePlayers)..addColumns([maxScore]);
    return query.map((row) => row.read(maxScore) ?? 0).watchSingle();
  }

  Stream<int> watchTotalHexagons() {
    final cnt = countAll(filter: moves.isHexagon.equals(true));
    final query = selectOnly(moves)..addColumns([cnt]);
    return query.map((row) => row.read(cnt) ?? 0).watchSingle();
  }
}
