import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/daos/stats_dao.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/extensions/build_context.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/glass_container.dart';
import '../stats_providers.dart';

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final totalGames = ref.watch(totalGamesProvider).value ?? 0;
    final bestScore = ref.watch(bestScoreProvider).value ?? 0;
    final hexagons = ref.watch(totalHexagonsProvider).value ?? 0;
    final earned = ref.watch(achievementsProvider).value ?? const <Achievement>{};

    final badges = <(Achievement, IconData, String)>[
      (Achievement.firstGame, Icons.flag_outlined, l10n.achFirstGame),
      (Achievement.firstHexagon, Icons.hexagon_outlined, l10n.achFirstHexagon),
      (Achievement.firstBridge, Icons.timeline_outlined, l10n.achFirstBridge),
      (Achievement.bigMove, Icons.bolt_outlined, l10n.achBigMove),
      (Achievement.games10, Icons.casino_outlined, l10n.achGames10),
      (Achievement.hatTrick, Icons.emoji_events_outlined, l10n.achHatTrick),
    ];

    return AppScaffold(
      title: l10n.statsTitle,
      body: ListView(
        children: [
          _StatCard(
            icon: Icons.casino_outlined,
            label: l10n.statsTotalGames,
            value: '$totalGames',
          ),
          const SizedBox(height: AppSpacing.x12),
          _StatCard(
            icon: Icons.emoji_events_outlined,
            label: l10n.statsBestScore,
            value: l10n.scoreUnit(bestScore),
          ),
          const SizedBox(height: AppSpacing.x12),
          _StatCard(
            icon: Icons.hexagon_outlined,
            label: l10n.statsMostHexagons,
            value: '$hexagons',
          ),
          const SizedBox(height: AppSpacing.x24),
          Text(l10n.achievementsTitle, style: context.text.titleLarge),
          const SizedBox(height: AppSpacing.x12),
          GlassContainer(
            child: Wrap(
              spacing: AppSpacing.x16,
              runSpacing: AppSpacing.x16,
              alignment: WrapAlignment.center,
              children: [
                for (final b in badges)
                  _Badge(
                    icon: b.$2,
                    label: b.$3,
                    earned: earned.contains(b.$1),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.icon,
    required this.label,
    required this.earned,
  });

  final IconData icon;
  final String label;
  final bool earned;

  @override
  Widget build(BuildContext context) {
    final color =
        earned ? context.colors.primary : context.colors.onSurface.withValues(alpha: 0.3);
    return SizedBox(
      width: 84,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.15),
              border: Border.all(color: color, width: 2),
            ),
            child: Icon(
              earned ? icon : Icons.lock_outline,
              color: color,
              size: 26,
            ),
          ),
          const SizedBox(height: AppSpacing.x8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: context.text.labelSmall?.copyWith(
              color: earned ? null : color,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: Row(
        children: [
          Icon(icon, color: context.colors.primary, size: 32),
          const SizedBox(width: AppSpacing.x16),
          Expanded(child: Text(label, style: context.text.titleLarge)),
          Text(value, style: context.text.headlineSmall),
        ],
      ),
    );
  }
}
