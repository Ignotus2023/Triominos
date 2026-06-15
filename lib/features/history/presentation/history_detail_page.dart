import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/game/move.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/extensions/build_context.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/player_avatar.dart';
import '../../game/game_providers.dart';
import '../../players/players_providers.dart';

/// Read-only odtworzenie zakończonej gry: tablica wyników + ruchy w rundach.
class HistoryDetailPage extends ConsumerWidget {
  const HistoryDetailPage({required this.gameId, super.key});

  final String gameId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final replay = ref.watch(gameReplayProvider(gameId));
    final icons = ref.watch(playerIconsProvider);

    return AppScaffold(
      title: l10n.historyTitle,
      body: replay.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(error: e),
        data: (data) {
          if (data.seats.isEmpty) {
            return ErrorView();
          }
          final seats = [...data.seats]
            ..sort((a, b) => b.totalScore.compareTo(a.totalScore));
          final nameOf = {
            for (final s in data.seats) s.playerId: s.displayNameSnapshot,
          };

          return ListView(
            children: [
              Text(l10n.summaryScoreboard, style: context.text.titleLarge),
              const SizedBox(height: AppSpacing.x12),
              for (final s in seats)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.x8),
                  child: GlassContainer(
                    child: Row(
                      children: [
                        PlayerAvatar(
                          initials: initialsFor(s.displayNameSnapshot),
                          colorHex: avatarColorFor(s.displayNameSnapshot),
                          iconKey: icons[s.playerId],
                        ),
                        const SizedBox(width: AppSpacing.x16),
                        Expanded(
                          child: Text(
                            s.displayNameSnapshot,
                            style: context.text.titleLarge,
                          ),
                        ),
                        Text(
                          l10n.scoreUnit(s.totalScore),
                          style: context.text.titleLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: AppSpacing.x24),
              for (final entry in data.rounds) ...[
                Text(
                  l10n.gameRound(entry.round.roundNumber),
                  style: context.text.titleLarge,
                ),
                const SizedBox(height: AppSpacing.x8),
                if (entry.moves.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.x16),
                    child: Text(
                      l10n.gameNoMoves,
                      style: context.text.bodyMedium,
                    ),
                  )
                else
                  for (final m in entry.moves)
                    _ReplayMoveTile(move: m, name: nameOf[m.playerId] ?? '?'),
                const SizedBox(height: AppSpacing.x16),
              ],
              const SizedBox(height: AppSpacing.x24),
            ],
          );
        },
      ),
    );
  }
}

class _ReplayMoveTile extends StatelessWidget {
  const _ReplayMoveTile({required this.move, required this.name});

  final MoveRow move;
  final String name;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final total = move.baseScore + move.bonusScore;
    final positive = total >= 0;
    final detail = switch (move.moveType) {
      MoveType.play => '(${move.corner1}-${move.corner2}-${move.corner3})',
      MoveType.drawPenalty => l10n.moveDraw,
      MoveType.passPenalty => l10n.gamePass,
      MoveType.endOfHandBonus => l10n.gameEndHand,
    };

    return GlassContainer(
      enableBlur: false,
      margin: const EdgeInsets.only(bottom: AppSpacing.x8),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x16,
        vertical: AppSpacing.x12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '$name  ', style: context.text.bodyLarge),
                  TextSpan(text: detail, style: context.text.bodyMedium),
                ],
              ),
            ),
          ),
          Text(
            '${positive ? '+' : ''}$total',
            style: context.text.titleLarge?.copyWith(
              color: positive ? context.colors.primary : context.colors.error,
            ),
          ),
        ],
      ),
    );
  }
}
