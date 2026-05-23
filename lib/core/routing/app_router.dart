import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/game/presentation/game_page.dart';
import '../../features/game_setup/presentation/game_setup_page.dart';
import '../../features/game_summary/presentation/game_summary_page.dart';
import '../../features/history/presentation/history_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/players/presentation/players_list_page.dart';
import '../../features/rules/presentation/rules_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/statistics/presentation/statistics_page.dart';
import 'app_routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.homePath,
    routes: [
      GoRoute(
        path: AppRoutes.homePath,
        name: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.playersPath,
        name: AppRoutes.players,
        builder: (context, state) => const PlayersListPage(),
      ),
      GoRoute(
        path: AppRoutes.gameSetupPath,
        name: AppRoutes.gameSetup,
        builder: (context, state) => const GameSetupPage(),
      ),
      GoRoute(
        path: AppRoutes.gamePath,
        name: AppRoutes.game,
        builder: (context, state) =>
            GamePage(gameId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.gameSummaryPath,
        name: AppRoutes.gameSummary,
        builder: (context, state) =>
            GameSummaryPage(gameId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.historyPath,
        name: AppRoutes.history,
        builder: (context, state) => const HistoryPage(),
      ),
      GoRoute(
        path: AppRoutes.statisticsPath,
        name: AppRoutes.statistics,
        builder: (context, state) => const StatisticsPage(),
      ),
      GoRoute(
        path: AppRoutes.rulesPath,
        name: AppRoutes.rules,
        builder: (context, state) => const RulesPage(),
      ),
      GoRoute(
        path: AppRoutes.settingsPath,
        name: AppRoutes.settings,
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
});
