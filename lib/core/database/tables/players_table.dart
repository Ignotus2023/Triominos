import 'package:drift/drift.dart';

class Players extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 32)();
  TextColumn get avatarColor => text()();
  TextColumn get initials => text().withLength(min: 1, max: 3)();

  /// Opcjonalny klucz ikony awatara (patrz `player_icons.dart`). Gdy null,
  /// awatar pokazuje inicjały.
  TextColumn get avatarIcon => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  /// Soft-delete: ustawiane przy usunięciu gracza, który ma historię gier.
  /// Wiersz pozostaje (klucz obcy `game_players` nienaruszony), ale jest
  /// odfiltrowany z list. Gracze bez historii są usuwani twardo.
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
