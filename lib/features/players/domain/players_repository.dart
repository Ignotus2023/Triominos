import 'player.dart';

abstract class PlayersRepository {
  Stream<List<Player>> watchAll({bool includeGuests = false});
  Future<List<Player>> getAll({bool includeGuests = false});
  Future<Player?> getById(String id);
  Future<void> create(Player player);
  Future<void> update(Player player);
  Future<void> delete(String id);
}
