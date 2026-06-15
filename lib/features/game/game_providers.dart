import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';

/// Aktywna (niezakończona) gra — do bannera "Wznów grę".
final activeGameProvider = StreamProvider<Game?>(
  (ref) => ref.watch(gamesDaoProvider).watchActiveGame(),
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

typedef RoundWithMoves = ({Round round, List<MoveRow> moves});
typedef GameReplay = ({List<GamePlayer> seats, List<RoundWithMoves> rounds});

/// Pełne dane zakończonej gry do odtworzenia w historii (read-only).
final gameReplayProvider = FutureProvider.family<GameReplay, String>((
  ref,
  gameId,
) async {
  final dao = ref.watch(gamesDaoProvider);
  final seats = await dao.getGamePlayers(gameId);
  final rounds = await dao.getRounds(gameId);
  final withMoves = <RoundWithMoves>[
    for (final r in rounds) (round: r, moves: await dao.getMoves(r.id)),
  ];
  return (seats: seats, rounds: withMoves);
});
