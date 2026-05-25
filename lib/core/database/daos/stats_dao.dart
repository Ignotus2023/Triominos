import 'package:drift/drift.dart';

import '../../game/game_enums.dart';
import '../app_database.dart';
import '../tables/game_players_table.dart';
import '../tables/games_table.dart';
import '../tables/moves_table.dart';

part 'stats_dao.g.dart';

/// Podstawowe odznaki wyliczane z bazy.
enum Achievement {
  firstGame,
  firstHexagon,
  firstBridge,
  bigMove,
  games10,
  hatTrick,
}

@DriftAccessor(tables: [Games, GamePlayers, Moves])
class StatsDao extends DatabaseAccessor<AppDatabase> with _$StatsDaoMixin {
  StatsDao(super.db);

  /// Wylicza zdobyte odznaki na podstawie historii gier i ruchów.
  Future<Set<Achievement>> computeAchievements() async {
    final earned = <Achievement>{};

    final finished = await (select(games)
          ..where((g) => g.status.equalsValue(GameStatus.finished))
          ..orderBy([(g) => OrderingTerm(expression: g.finishedAt)]))
        .get();
    if (finished.isNotEmpty) earned.add(Achievement.firstGame);
    if (finished.length >= 10) earned.add(Achievement.games10);

    // Hat-trick: najdłuższa seria zwycięstw tego samego gracza pod rząd.
    var best = 0;
    var current = 0;
    String? prev;
    for (final g in finished) {
      final w = g.winnerId;
      if (w == null) {
        current = 0;
        prev = null;
        continue;
      }
      current = (w == prev) ? current + 1 : 1;
      prev = w;
      if (current > best) best = current;
    }
    if (best >= 3) earned.add(Achievement.hatTrick);

    Future<bool> exists(Expression<bool> filter) async {
      final row =
          await (select(moves)..where((_) => filter)..limit(1)).getSingleOrNull();
      return row != null;
    }

    if (await exists(moves.isHexagon.equals(true))) {
      earned.add(Achievement.firstHexagon);
    }
    if (await exists(moves.isBridge.equals(true))) {
      earned.add(Achievement.firstBridge);
    }
    if (await exists((moves.baseScore + moves.bonusScore)
        .isBiggerOrEqualValue(40))) {
      earned.add(Achievement.bigMove);
    }

    return earned;
  }

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
