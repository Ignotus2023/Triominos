import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/database/app_database.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/extensions/build_context.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../game/game_providers.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final games = ref.watch(finishedGamesProvider);

    return AppScaffold(
      title: l10n.historyTitle,
      body: games.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) {
          if (list.isEmpty) {
            return EmptyState(icon: Icons.history, message: l10n.historyEmpty);
          }
          return ListView.separated(
            itemCount: list.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.x12),
            itemBuilder: (context, i) => _GameHistoryTile(game: list[i]),
          );
        },
      ),
    );
  }
}

class _GameHistoryTile extends ConsumerWidget {
  const _GameHistoryTile({required this.game});

  final Game game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final seats = ref.watch(gamePlayersProvider(game.id)).value ?? [];
    final locale = Localizations.localeOf(context).toString();
    final date = game.finishedAt ?? game.startedAt;
    final winner = seats.where((s) => s.playerId == game.winnerId).firstOrNull;

    return GlassContainer(
      child: Row(
        children: [
          Icon(Icons.emoji_events, color: context.colors.primary),
          const SizedBox(width: AppSpacing.x16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMd(locale).add_Hm().format(date),
                  style: context.text.titleLarge,
                ),
                if (winner != null)
                  Text(
                    l10n.historyWinner(winner.displayNameSnapshot),
                    style: context.text.bodyMedium,
                  ),
              ],
            ),
          ),
          Text(
            '${seats.length}',
            style: context.text.bodyMedium,
          ),
          Icon(Icons.group_outlined, size: 16, color: context.text.bodyMedium?.color),
        ],
      ),
    );
  }
}
