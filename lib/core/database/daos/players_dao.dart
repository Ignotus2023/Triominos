import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/players_table.dart';

part 'players_dao.g.dart';

@DriftAccessor(tables: [Players])
class PlayersDao extends DatabaseAccessor<AppDatabase> with _$PlayersDaoMixin {
  PlayersDao(super.db);

  Stream<List<PlayerRow>> watchAll({bool includeGuests = false}) {
    final query = select(players);
    if (!includeGuests) {
      query.where((t) => t.isGuest.equals(false));
    }
    query.orderBy([(t) => OrderingTerm.asc(t.name)]);
    return query.watch();
  }

  Future<List<PlayerRow>> listAll({bool includeGuests = false}) {
    final query = select(players);
    if (!includeGuests) {
      query.where((t) => t.isGuest.equals(false));
    }
    query.orderBy([(t) => OrderingTerm.asc(t.name)]);
    return query.get();
  }

  Future<PlayerRow?> findById(String id) {
    return (select(players)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertPlayer(PlayersCompanion entry) async {
    await into(players).insert(entry, mode: InsertMode.insertOrReplace);
  }

  Future<void> updatePlayer(PlayersCompanion entry) async {
    await update(players).replace(entry);
  }

  Future<int> deleteById(String id) {
    return (delete(players)..where((t) => t.id.equals(id))).go();
  }
}
