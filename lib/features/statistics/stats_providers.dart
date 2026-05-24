import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_provider.dart';

final totalGamesProvider = StreamProvider<int>(
  (ref) => ref.watch(statsDaoProvider).watchTotalFinishedGames(),
);

final bestScoreProvider = StreamProvider<int>(
  (ref) => ref.watch(statsDaoProvider).watchBestScore(),
);

final totalHexagonsProvider = StreamProvider<int>(
  (ref) => ref.watch(statsDaoProvider).watchTotalHexagons(),
);
