import 'package:drift/drift.dart';

import 'games_table.dart';

class Rounds extends Table {
  TextColumn get id => text()();
  TextColumn get gameId =>
      text().references(Games, #id, onDelete: KeyAction.cascade)();
  IntColumn get roundNumber => integer()();
  TextColumn get starterPlayerId => text()();
  TextColumn get finisherPlayerId => text().nullable()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get finishedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
