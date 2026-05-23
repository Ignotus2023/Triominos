import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/database/daos/players_dao.dart';
import '../../core/database/database_provider.dart';
import '../../core/utils/id.dart';

/// Paleta kolorów awatarów (Indigo / Violet i akcenty).
const _avatarColors = <String>[
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
  if (seed.isEmpty) return _avatarColors.first;
  final hash = seed.codeUnits.fold<int>(0, (a, b) => a + b);
  return _avatarColors[hash % _avatarColors.length];
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

  Future<void> create(String name) {
    final trimmed = name.trim();
    final now = DateTime.now();
    return _dao.upsert(
      PlayersCompanion.insert(
        id: newId(),
        name: trimmed,
        avatarColor: avatarColorFor(trimmed),
        initials: initialsFor(trimmed),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<void> rename(Player player, String name) {
    final trimmed = name.trim();
    return _dao.upsert(
      player
          .copyWith(
            name: trimmed,
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
