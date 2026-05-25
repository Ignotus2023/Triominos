import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/daos/stats_dao.dart';
import '../../core/database/database_provider.dart';
import '../game/game_providers.dart';

final totalGamesProvider = StreamProvider<int>(
  (ref) => ref.watch(statsDaoProvider).watchTotalFinishedGames(),
);

final bestScoreProvider = StreamProvider<int>(
  (ref) => ref.watch(statsDaoProvider).watchBestScore(),
);

final totalHexagonsProvider = StreamProvider<int>(
  (ref) => ref.watch(statsDaoProvider).watchTotalHexagons(),
);

/// Zdobyte odznaki — przeliczane, gdy zmieni się lista zakończonych gier.
final achievementsProvider = FutureProvider<Set<Achievement>>((ref) async {
  ref.watch(finishedGamesProvider);
  return ref.watch(statsDaoProvider).computeAchievements();
});
