// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'games_dao.dart';

// ignore_for_file: type=lint
mixin _$GamesDaoMixin on DatabaseAccessor<AppDatabase> {
  $GamesTable get games => attachedDatabase.games;
  $PlayersTable get players => attachedDatabase.players;
  $GamePlayersTable get gamePlayers => attachedDatabase.gamePlayers;
  $RoundsTable get rounds => attachedDatabase.rounds;
  $MovesTable get moves => attachedDatabase.moves;
  GamesDaoManager get managers => GamesDaoManager(this);
}

class GamesDaoManager {
  final _$GamesDaoMixin _db;
  GamesDaoManager(this._db);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db.attachedDatabase, _db.games);
  $$PlayersTableTableManager get players =>
      $$PlayersTableTableManager(_db.attachedDatabase, _db.players);
  $$GamePlayersTableTableManager get gamePlayers =>
      $$GamePlayersTableTableManager(_db.attachedDatabase, _db.gamePlayers);
  $$RoundsTableTableManager get rounds =>
      $$RoundsTableTableManager(_db.attachedDatabase, _db.rounds);
  $$MovesTableTableManager get moves =>
      $$MovesTableTableManager(_db.attachedDatabase, _db.moves);
}
