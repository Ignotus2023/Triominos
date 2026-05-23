import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
