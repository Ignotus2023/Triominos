import 'package:drift/drift.dart';

import '../../game/move.dart';
import 'rounds_table.dart';

@DataClassName('MoveRow')
class Moves extends Table {
  TextColumn get id => text()();
  TextColumn get roundId =>
      text().references(Rounds, #id, onDelete: KeyAction.cascade)();
  TextColumn get playerId => text()();
  IntColumn get moveIndex => integer()();
  TextColumn get moveType => textEnum<MoveType>()();
  IntColumn get corner1 => integer().nullable()();
  IntColumn get corner2 => integer().nullable()();
  IntColumn get corner3 => integer().nullable()();
  IntColumn get baseScore => integer()();
  IntColumn get bonusScore => integer().withDefault(const Constant(0))();
  BoolColumn get isTriplet => boolean().withDefault(const Constant(false))();
  BoolColumn get isBridge => boolean().withDefault(const Constant(false))();
  BoolColumn get isHexagon => boolean().withDefault(const Constant(false))();
  BoolColumn get isDoubleHexagon =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isStarter => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
