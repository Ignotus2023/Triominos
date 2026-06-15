import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/players_table.dart';

part 'players_dao.g.dart';

@DriftAccessor(tables: [Players])
class PlayersDao extends DatabaseAccessor<AppDatabase> with _$PlayersDaoMixin {
  PlayersDao(super.db);

  Stream<List<Player>> watchAll() {
    return (select(players)
          ..where((p) => p.deletedAt.isNull())
          ..orderBy([(p) => OrderingTerm(expression: p.name)]))
        .watch();
  }

  Future<List<Player>> getAll() {
    return (select(players)
          ..where((p) => p.deletedAt.isNull())
          ..orderBy([(p) => OrderingTerm(expression: p.name)]))
        .get();
  }

  Future<Player?> getById(String id) {
    return (select(players)..where((p) => p.id.equals(id))).getSingleOrNull();
  }

  Future<void> upsert(PlayersCompanion player) {
    return into(players).insertOnConflictUpdate(player);
  }

  Future<void> deleteById(String id) {
    return (delete(players)..where((p) => p.id.equals(id))).go();
  }

  /// Soft-delete: oznacza gracza jako usuniętego, zachowując wiersz dla
  /// integralności historii (klucz obcy `game_players`).
  Future<void> archiveById(String id) {
    return (update(players)..where((p) => p.id.equals(id))).write(
      PlayersCompanion(deletedAt: Value(DateTime.now())),
    );
  }
}
