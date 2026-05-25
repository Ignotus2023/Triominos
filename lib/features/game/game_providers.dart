import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';

/// Aktywna (niezakończona) gra — do bannera "Wznów grę".
final activeGameProvider = StreamProvider<Game?>(
  (ref) => ref.watch(gamesDaoProvider).watchActiveGame(),
);

/// Ostatnia gra (dowolny status) — do szybkiego rewanżu.
final lastGameProvider = StreamProvider<Game?>(
  (ref) => ref.watch(gamesDaoProvider).watchLastGame(),
);

final gameProvider = StreamProvider.family<Game?, String>(
  (ref, id) => ref.watch(gamesDaoProvider).watchGame(id),
);

final gamePlayersProvider = StreamProvider.family<List<GamePlayer>, String>(
  (ref, gameId) => ref.watch(gamesDaoProvider).watchGamePlayers(gameId),
);

final currentRoundProvider = StreamProvider.family<Round?, String>(
  (ref, gameId) => ref.watch(gamesDaoProvider).watchCurrentRound(gameId),
);

final roundMovesProvider = StreamProvider.family<List<MoveRow>, String>(
  (ref, roundId) => ref.watch(gamesDaoProvider).watchMoves(roundId),
);

final finishedGamesProvider = StreamProvider<List<Game>>(
  (ref) => ref.watch(gamesDaoProvider).watchFinishedGames(),
);
