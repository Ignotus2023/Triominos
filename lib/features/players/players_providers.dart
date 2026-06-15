import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/database/daos/games_dao.dart';
import '../../core/database/daos/players_dao.dart';
import '../../core/database/database_provider.dart';
import '../../core/utils/id.dart';

/// Paleta kolorów awatarów (Indigo / Violet i akcenty).
const avatarPalette = <String>[
  '#6366F1',
  '#8B5CF6',
  '#A78BFA',
  '#EC4899',
  '#F59E0B',
  '#10B981',
  '#06B6D4',
  '#EF4444',
];

String avatarColorFor(String seed) {
  if (seed.isEmpty) return avatarPalette.first;
  final hash = seed.codeUnits.fold<int>(0, (a, b) => a + b);
  return avatarPalette[hash % avatarPalette.length];
}

String initialsFor(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
  if (parts.isEmpty) return '?';
  if (parts.length == 1) {
    final p = parts.first;
    return p.substring(0, p.length >= 2 ? 2 : 1).toUpperCase();
  }
  return (parts.first[0] + parts.last[0]).toUpperCase();
}

class PlayersService {
  PlayersService(this._dao, this._gamesDao);

  final PlayersDao _dao;
  final GamesDao _gamesDao;

  Future<void> create(String name, String color, {String? icon}) {
    final trimmed = name.trim();
    final now = DateTime.now();
    return _dao.upsert(
      PlayersCompanion.insert(
        id: newId(),
        name: trimmed,
        avatarColor: color,
        initials: initialsFor(trimmed),
        avatarIcon: Value(icon),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<void> update(
    Player player,
    String name,
    String color, {
    String? icon,
  }) {
    final trimmed = name.trim();
    // toCompanion(false) — zapisujemy też wartości null (np. usunięcie ikony);
    // toCompanion(true) zamieniłoby null na Value.absent() i nie wyczyściłoby
    // kolumny avatarIcon.
    return _dao.upsert(
      player
          .copyWith(
            name: trimmed,
            avatarColor: color,
            initials: initialsFor(trimmed),
            avatarIcon: Value(icon),
            updatedAt: DateTime.now(),
          )
          .toCompanion(false),
    );
  }

  /// Gracz z historią gier jest archiwizowany (soft-delete), aby nie naruszyć
  /// klucza obcego `game_players`; gracz bez historii usuwany jest twardo.
  Future<void> delete(String id) async {
    final played = await _gamesDao.countGamesForPlayer(id);
    if (played > 0) {
      await _dao.archiveById(id);
    } else {
      await _dao.deleteById(id);
    }
  }
}

final playersServiceProvider = Provider<PlayersService>(
  (ref) => PlayersService(
    ref.watch(playersDaoProvider),
    ref.watch(gamesDaoProvider),
  ),
);

final playersStreamProvider = StreamProvider<List<Player>>(
  (ref) => ref.watch(playersDaoProvider).watchAll(),
);

/// Mapa playerId -> kolor awatara (do pokazania kolorów w rozgrywce).
final playerColorsProvider = Provider<Map<String, String>>((ref) {
  final players = ref.watch(playersStreamProvider).value ?? [];
  return {for (final p in players) p.id: p.avatarColor};
});

/// Mapa playerId -> klucz ikony awatara (do pokazania ikon w rozgrywce).
final playerIconsProvider = Provider<Map<String, String>>((ref) {
  final players = ref.watch(playersStreamProvider).value ?? [];
  return {
    for (final p in players)
      if (p.avatarIcon != null) p.id: p.avatarIcon!,
  };
});
