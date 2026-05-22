import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../data/game_repository_impl.dart';
import '../domain/game.dart';
import '../domain/game_repository.dart';
import '../domain/move.dart';
import '../domain/round.dart';
import 'game_actions.dart';

export '../domain/game_repository.dart' show GameDetails;

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

final gameRoundsProvider = StreamProvider.family<List<Round>, String>((ref, gameId) {
  return ref.watch(gameRepositoryProvider).watchRounds(gameId);
});

final currentRoundProvider = Provider.family<Round?, String>((ref, gameId) {
  final rounds = ref.watch(gameRoundsProvider(gameId)).valueOrNull ?? const [];
  for (final round in rounds.reversed) {
    if (!round.isFinished) return round;
  }
  return null;
});

final roundMovesProvider = StreamProvider.family<List<Move>, String>((ref, roundId) {
  return ref.watch(gameRepositoryProvider).watchMovesForRound(roundId);
});

final gameActionsProvider = Provider<GameActions>((ref) {
  return GameActions(ref.watch(gameRepositoryProvider));
});

final gameDetailsProvider = FutureProvider.family<GameDetails?, String>((ref, gameId) {
  return ref.watch(gameRepositoryProvider).loadDetails(gameId);
});

