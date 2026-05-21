import 'package:drift/drift.dart';

import 'games_table.dart';

@DataClassName('RoundRow')
class Rounds extends Table {
  TextColumn get id => text()();
  TextColumn get gameId =>
      text().references(Games, #id, onDelete: KeyAction.cascade)();
  IntColumn get roundNumber => integer()();
  TextColumn get starterPlayerId => text()();
  BoolColumn get starterByTriplet => boolean().withDefault(const Constant(false))();
  TextColumn get finisherPlayerId => text().nullable()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get finishedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
