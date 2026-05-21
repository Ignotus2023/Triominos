import 'package:drift/drift.dart';

import '../../game/end_game_evaluator.dart';
import '../../game/scoring_rules.dart';

enum GameStatus { inProgress, finished, abandoned }

@DataClassName('GameRow')
class Games extends Table {
  TextColumn get id => text()();
  TextColumn get endMode => textEnum<EndMode>()();
  TextColumn get scoringVariant => textEnum<ScoringVariant>()();
  IntColumn get scoreLimit => integer().nullable()();
  IntColumn get totalRounds => integer().nullable()();
  IntColumn get currentRound => integer().withDefault(const Constant(1))();
  IntColumn get currentSeatIndex => integer().withDefault(const Constant(0))();
  TextColumn get status => textEnum<GameStatus>()();
  TextColumn get winnerId => text().nullable()();
  IntColumn get playedTilesCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get finishedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
