import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/date_format.dart';
import '../../../shared/extensions/build_context.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/secondary_button.dart';
import '../../game/domain/game.dart';
import '../../game/presentation/game_providers.dart';
import '../domain/summary_stats.dart';
import 'widgets/final_scoreboard.dart';
import 'widgets/winner_celebration.dart';

class GameSummaryPage extends ConsumerWidget {
  const GameSummaryPage({required this.gameId, super.key});

  final String gameId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final detailsAsync = ref.watch(gameDetailsProvider(gameId));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n.summaryTitle),
      ),
      body: detailsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('${l10n.errorGeneric}\n$e')),
        data: (details) {
          if (details == null) {
            return Center(child: Text(l10n.errorGeneric));
          }
          final stats = computeSummary(details);
          final winner = stats.ranking.isNotEmpty ? stats.ranking.first : null;
          return _SummaryBody(
            gameId: gameId,
            stats: stats,
            winner: winner,
          );
        },
      ),
    );
  }
}

class _SummaryBody extends ConsumerWidget {
  const _SummaryBody({
    required this.gameId,
    required this.stats,
    required this.winner,
  });

  final String gameId;
  final SummaryStats stats;
  final GamePlayerSnapshot? winner;

  String _bestMoveName(BuildContext context) {
    final best = stats.bestMove;
    if (best == null) return '—';
    final name = stats.ranking
            .where((p) => p.playerId == best.playerId)
            .map((p) => p.displayName)
            .firstOrNull ??
        '?';
    return '$name · ${best.tileLabel} (+${best.score})';
  }

  Future<void> _rematch(BuildContext context, WidgetRef ref) async {
    final newId = await ref.read(gameActionsProvider).rematch(gameId: gameId);
    if (context.mounted) {
      context.pushReplacementNamed(
        AppRoute.game,
        pathParameters: {'gameId': newId},
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
              children: [
                if (winner != null) WinnerCelebration(winner: winner!),
                AppSpacing.h24,
                FinalScoreboard(ranking: stats.ranking),
                AppSpacing.h12,
                GlassContainer(
                  child: Column(
                    children: [
                      _StatRow(
                        icon: Icons.timer_outlined,
                        label: l10n.summaryDuration,
                        value: formatDuration(stats.duration),
                      ),
                      const Divider(),
                      _StatRow(
                        icon: Icons.repeat_rounded,
                        label: l10n.summaryRoundsPlayed,
                        value: '${stats.roundsPlayed}',
                      ),
                      const Divider(),
                      _StatRow(
                        icon: Icons.auto_awesome_rounded,
                        label: l10n.summaryBestMove,
                        value: _bestMoveName(context),
                      ),
                      if (stats.hexagonCount > 0) ...[
                        const Divider(),
                        _StatRow(
                          icon: Icons.hexagon_outlined,
                          label: l10n.bonusHexagon,
                          value: '${stats.hexagonCount}',
                        ),
                      ],
                    ],
                  ),
                ),
                AppSpacing.h24,
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.x20,
              AppSpacing.x8,
              AppSpacing.x20,
              AppSpacing.x16,
            ),
            child: Column(
              children: [
                PrimaryButton(
                  label: l10n.summaryRematch,
                  icon: Icons.replay_rounded,
                  onPressed: () => _rematch(context, ref),
                ),
                AppSpacing.h8,
                SecondaryButton(
                  label: l10n.summaryBackHome,
                  icon: Icons.home_outlined,
                  onPressed: () => context.goNamed(AppRoute.home),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: context.colors.primary),
          AppSpacing.w12,
          Expanded(child: Text(label, style: context.textStyles.bodyMedium)),
          Flexible(
            child: Text(
              value,
              style: context.textStyles.titleSmall,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
