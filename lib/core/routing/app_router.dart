import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/game/presentation/game_page.dart';
import '../../features/game_setup/presentation/game_setup_page.dart';
import '../../features/game_summary/presentation/game_summary_page.dart';
import '../../features/history/presentation/history_details_page.dart';
import '../../features/history/presentation/history_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/onboarding/presentation/onboarding_page.dart';
import '../../features/players/presentation/player_form_page.dart';
import '../../features/players/presentation/players_list_page.dart';
import '../../features/rules/presentation/rules_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/statistics/presentation/statistics_page.dart';
import '../settings/settings_provider.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final settings = ref.watch(settingsControllerProvider);
  final initialPath = settings.onboardingCompleted ? AppPath.home : AppPath.onboarding;

  return GoRouter(
    initialLocation: initialPath,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: AppPath.onboarding,
        name: AppRoute.onboarding,
        builder: (_, __) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppPath.home,
        name: AppRoute.home,
        builder: (_, __) => const HomePage(),
        routes: [
          GoRoute(
            path: 'players',
            name: AppRoute.players,
            builder: (_, __) => const PlayersListPage(),
            routes: [
              GoRoute(
                path: 'edit',
                name: AppRoute.playerForm,
                builder: (_, state) => PlayerFormPage(
                  playerId: state.uri.queryParameters['id'],
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'game/setup',
            name: AppRoute.gameSetup,
            builder: (_, __) => const GameSetupPage(),
          ),
          GoRoute(
            path: 'game/:gameId',
            name: AppRoute.game,
            builder: (_, state) => GamePage(gameId: state.pathParameters['gameId']!),
            routes: [
              GoRoute(
                path: 'summary',
                name: AppRoute.gameSummary,
                builder: (_, state) =>
                    GameSummaryPage(gameId: state.pathParameters['gameId']!),
              ),
            ],
          ),
          GoRoute(
            path: 'history',
            name: AppRoute.history,
            builder: (_, __) => const HistoryPage(),
            routes: [
              GoRoute(
                path: ':gameId',
                name: AppRoute.historyDetails,
                builder: (_, state) =>
                    HistoryDetailsPage(gameId: state.pathParameters['gameId']!),
              ),
            ],
          ),
          GoRoute(
            path: 'statistics',
            name: AppRoute.statistics,
            builder: (_, __) => const StatisticsPage(),
          ),
          GoRoute(
            path: 'rules',
            name: AppRoute.rules,
            builder: (_, __) => const RulesPage(),
          ),
          GoRoute(
            path: 'settings',
            name: AppRoute.settings,
            builder: (_, __) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );
});
