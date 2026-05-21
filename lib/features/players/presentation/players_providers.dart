import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../data/players_repository_impl.dart';
import '../domain/player.dart';
import '../domain/players_repository.dart';

final playersRepositoryProvider = Provider<PlayersRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return PlayersRepositoryImpl(db.playersDao);
});

final savedPlayersStreamProvider = StreamProvider<List<Player>>((ref) {
  return ref.watch(playersRepositoryProvider).watchAll();
});

final playerByIdProvider = FutureProvider.family<Player?, String>((ref, id) {
  return ref.watch(playersRepositoryProvider).getById(id);
});
