import 'package:drift/drift.dart';

import 'games_table.dart';
import 'players_table.dart';

@DataClassName('GamePlayerRow')
class GamePlayers extends Table {
  TextColumn get gameId =>
      text().references(Games, #id, onDelete: KeyAction.cascade)();
  TextColumn get playerId => text().references(Players, #id)();
  IntColumn get seatIndex => integer()();
  IntColumn get totalScore => integer().withDefault(const Constant(0))();
  TextColumn get displayNameSnapshot => text()();
  TextColumn get avatarColorSnapshot => text()();
  TextColumn get initialsSnapshot => text()();

  @override
  Set<Column<Object>> get primaryKey => {gameId, playerId};
}
