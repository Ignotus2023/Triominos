import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/daos/players_dao.dart';
import '../../../core/database/tables/players_table.dart';
import '../domain/player.dart';
import '../domain/players_repository.dart';

class PlayersRepositoryImpl implements PlayersRepository {
  PlayersRepositoryImpl(this._dao);

  final PlayersDao _dao;

  @override
  Stream<List<Player>> watchAll({bool includeGuests = false}) {
    return _dao
        .watchAll(includeGuests: includeGuests)
        .map((rows) => rows.map(_toEntity).toList(growable: false));
  }

  @override
  Future<List<Player>> getAll({bool includeGuests = false}) async {
    final rows = await _dao.listAll(includeGuests: includeGuests);
    return rows.map(_toEntity).toList(growable: false);
  }

  @override
  Future<Player?> getById(String id) async {
    final row = await _dao.findById(id);
    return row == null ? null : _toEntity(row);
  }

  @override
  Future<void> create(Player player) async {
    await _dao.insertPlayer(_toCompanion(player));
  }

  @override
  Future<void> update(Player player) async {
    final updated = player.copyWith(updatedAt: DateTime.now());
    await _dao.updatePlayer(_toCompanion(updated));
  }

  @override
  Future<void> delete(String id) async {
    await _dao.deleteById(id);
  }

  Player _toEntity(PlayerRow row) {
    return Player(
      id: row.id,
      name: row.name,
      initials: row.initials,
      avatarColor: row.avatarColor,
      isGuest: row.isGuest,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  PlayersCompanion _toCompanion(Player p) {
    return PlayersCompanion(
      id: Value(p.id),
      name: Value(p.name),
      initials: Value(p.initials),
      avatarColor: Value(p.avatarColor),
      isGuest: Value(p.isGuest),
      createdAt: Value(p.createdAt),
      updatedAt: Value(p.updatedAt),
    );
  }
}
