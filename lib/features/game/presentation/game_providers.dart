import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../data/game_repository_impl.dart';
import '../domain/game.dart';
import '../domain/game_repository.dart';
import '../domain/move.dart';
import '../domain/round.dart';

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return GameRepositoryImpl(db, db.gamesDao);
});

final activeGamesProvider = StreamProvider<List<Game>>((ref) {
  return ref.watch(gameRepositoryProvider).watchActiveGames();
});

final finishedGamesProvider = StreamProvider<List<Game>>((ref) {
  return ref.watch(gameRepositoryProvider).watchFinishedGames();
});

final gameProvider = StreamProvider.family<Game?, String>((ref, gameId) {
  return ref.watch(gameRepositoryProvider).watchGame(gameId);
});

final currentRoundProvider = FutureProvider.family<Round?, String>((ref, gameId) {
  ref.watch(gameProvider(gameId));
  return ref.watch(gameRepositoryProvider).getCurrentRound(gameId);
});

final roundMovesProvider = StreamProvider.family<List<Move>, String>((ref, roundId) {
  return ref.watch(gameRepositoryProvider).watchMovesForRound(roundId);
});
