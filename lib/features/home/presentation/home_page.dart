import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/extensions/build_context.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../game/presentation/game_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.pushNamed(AppRoute.settings),
          ),
        ],
      ),
      body: Stack(
        children: [
          const _BackgroundGradient(),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x20,
                AppSpacing.x16,
                AppSpacing.x20,
                AppSpacing.x32,
              ),
              children: [
                AppSpacing.h16,
                Text(l10n.homeWelcome, style: context.textStyles.displaySmall),
                AppSpacing.h4,
                Text(
                  l10n.homeWelcomeSubtitle,
                  style: context.textStyles.bodyLarge,
                ),
                AppSpacing.h32,
                PrimaryButton(
                  label: l10n.homeNewGame,
                  icon: Icons.add_rounded,
                  onPressed: () => context.pushNamed(AppRoute.gameSetup),
                ),
                AppSpacing.h12,
                const _ResumeBanner(),
                AppSpacing.h16,
                _HomeTile(
                  icon: Icons.group_outlined,
                  label: l10n.homePlayers,
                  onTap: () => context.pushNamed(AppRoute.players),
                ),
                AppSpacing.h12,
                _HomeTile(
                  icon: Icons.history_rounded,
                  label: l10n.homeHistory,
                  onTap: () => context.pushNamed(AppRoute.history),
                ),
                AppSpacing.h12,
                _HomeTile(
                  icon: Icons.bar_chart_rounded,
                  label: l10n.homeStatistics,
                  onTap: () => context.pushNamed(AppRoute.statistics),
                ),
                AppSpacing.h12,
                _HomeTile(
                  icon: Icons.menu_book_rounded,
                  label: l10n.homeRules,
                  onTap: () => context.pushNamed(AppRoute.rules),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResumeBanner extends ConsumerWidget {
  const _ResumeBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final games = ref.watch(activeGamesProvider).valueOrNull ?? const [];
    if (games.isEmpty) return const SizedBox.shrink();
    final game = games.first;

    return GlassContainer(
      padding: EdgeInsets.zero,
      child: ListTile(
        leading: Icon(Icons.play_circle_outline_rounded, color: context.colors.primary),
        title: Text(l10n.homeResumeGame, style: context.textStyles.titleMedium),
        subtitle: Text(
          l10n.homeResumeGameSubtitle(game.currentRound, game.players.length),
          style: context.textStyles.bodyMedium,
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => context.pushNamed(
          AppRoute.game,
          pathParameters: {'gameId': game.id},
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
      ),
    );
  }
}

class _HomeTile extends StatelessWidget {
  const _HomeTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: EdgeInsets.zero,
      child: ListTile(
        leading: Icon(icon, color: context.colors.primary),
        title: Text(label, style: context.textStyles.titleMedium),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
      ),
    );
  }
}

class _BackgroundGradient extends StatelessWidget {
  const _BackgroundGradient();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? const [
                    AppColors.darkBackground,
                    Color(0xFF1A1245),
                    AppColors.darkBackground,
                  ]
                : const [
                    AppColors.lightBackground,
                    Color(0xFFE7E1FF),
                    AppColors.lightBackground,
                  ],
          ),
        ),
      ),
    );
  }
}
