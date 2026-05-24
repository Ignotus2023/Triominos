import 'package:drift/drift.dart';

class Players extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 32)();
  TextColumn get avatarColor => text()();
  TextColumn get initials => text().withLength(min: 1, max: 3)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
