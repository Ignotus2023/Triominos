import 'package:drift/drift.dart';

import '../../game/game_enums.dart';

class Games extends Table {
  TextColumn get id => text()();
  TextColumn get endMode => textEnum<EndMode>()();
  IntColumn get scoreLimit => integer().nullable()();
  IntColumn get totalRounds => integer().nullable()();
  IntColumn get currentRound => integer().withDefault(const Constant(1))();
  TextColumn get status => textEnum<GameStatus>()();
  TextColumn get winnerId => text().nullable()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get finishedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
