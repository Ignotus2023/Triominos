import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
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
  PlayersService(this._dao);

  final PlayersDao _dao;

  Future<void> create(String name, String color) {
    final trimmed = name.trim();
    final now = DateTime.now();
    return _dao.upsert(
      PlayersCompanion.insert(
        id: newId(),
        name: trimmed,
        avatarColor: color,
        initials: initialsFor(trimmed),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<void> update(Player player, String name, String color) {
    final trimmed = name.trim();
    return _dao.upsert(
      player
          .copyWith(
            name: trimmed,
            avatarColor: color,
            initials: initialsFor(trimmed),
            updatedAt: DateTime.now(),
          )
          .toCompanion(true),
    );
  }

  Future<void> delete(String id) => _dao.deleteById(id);
}

final playersServiceProvider =
    Provider<PlayersService>((ref) => PlayersService(ref.watch(playersDaoProvider)));

final playersStreamProvider = StreamProvider<List<Player>>(
  (ref) => ref.watch(playersDaoProvider).watchAll(),
);

/// Mapa playerId -> kolor awatara (do pokazania kolorów w rozgrywce).
final playerColorsProvider = Provider<Map<String, String>>((ref) {
  final players = ref.watch(playersStreamProvider).value ?? [];
  return {for (final p in players) p.id: p.avatarColor};
});
