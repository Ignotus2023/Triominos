import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/settings/settings_provider.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/extensions/build_context.dart';
import '../../../shared/widgets/ad_banner.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../game/game_providers.dart';
import '../../game_setup/game_setup_controller.dart';
import '../../players/players_providers.dart';
import 'widgets/home_action_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final activeGame = ref.watch(activeGameProvider).value;
    final lastGame = ref.watch(lastGameProvider).value;
    final premium = ref.watch(settingsProvider.select((s) => s.isPremium));

    return AppScaffold(
      body: ListView(
        children: [
          const SizedBox(height: AppSpacing.x16),
          Row(
            children: [
              Expanded(
                child: Text(l10n.appTitle, style: context.text.headlineLarge),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => context.pushNamed(AppRoutes.settings),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(l10n.homeSubtitle, style: context.text.bodyMedium),
          const SizedBox(height: AppSpacing.x24),
          PrimaryButton(
            label: l10n.homeNewGame,
            icon: Icons.add,
            onPressed: () => context.pushNamed(AppRoutes.gameSetup),
          ),
          if (activeGame != null) ...[
            const SizedBox(height: AppSpacing.x16),
            GlassContainer(
              onTap: () => context.pushNamed(
                AppRoutes.game,
                pathParameters: {'id': activeGame.id},
              ),
              child: Row(
                children: [
                  Icon(Icons.play_arrow_rounded, color: context.colors.primary),
                  const SizedBox(width: AppSpacing.x12),
                  Expanded(
                    child: Text(
                      l10n.homeResumeGame,
                      style: context.text.titleLarge,
                    ),
                  ),
                  Text(
                    l10n.gameRound(activeGame.currentRound),
                    style: context.text.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
          if (lastGame != null) ...[
            const SizedBox(height: AppSpacing.x12),
            GlassContainer(
              onTap: () => _quickRematch(context, ref, lastGame.id),
              child: Row(
                children: [
                  Icon(Icons.replay_rounded, color: context.colors.primary),
                  const SizedBox(width: AppSpacing.x12),
                  Expanded(
                    child: Text(
                      l10n.homeQuickRematch,
                      style: context.text.titleLarge,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.x24),
          GridView.count(
            crossAxisCount: context.isTablet ? 3 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.x12,
            crossAxisSpacing: AppSpacing.x12,
            childAspectRatio: 1.4,
            children: [
              HomeActionCard(
                icon: Icons.group_outlined,
                label: l10n.homePlayers,
                onTap: () => context.pushNamed(AppRoutes.players),
              ),
              HomeActionCard(
                icon: Icons.history,
                label: l10n.homeHistory,
                onTap: () => context.pushNamed(AppRoutes.history),
              ),
              HomeActionCard(
                icon: Icons.bar_chart_rounded,
                label: l10n.homeStatistics,
                onTap: () => context.pushNamed(AppRoutes.statistics),
              ),
              HomeActionCard(
                icon: Icons.menu_book_outlined,
                label: l10n.homeRules,
                onTap: () => context.pushNamed(AppRoutes.rules),
              ),
            ],
          ),
          if (AppConstants.isFreeVersion && !premium) ...[
            const SizedBox(height: AppSpacing.x16),
            const AdBanner(),
          ],
        ],
      ),
    );
  }

  Future<void> _quickRematch(
    BuildContext context,
    WidgetRef ref,
    String gameId,
  ) async {
    final players = ref.read(playersStreamProvider).value ?? [];
    final id =
        await ref.read(gameSetupControllerProvider).rematchFrom(gameId, players);
    if (!context.mounted) return;
    if (id != null) {
      context.pushNamed(AppRoutes.game, pathParameters: {'id': id});
    } else {
      context.pushNamed(AppRoutes.gameSetup);
    }
  }
}
