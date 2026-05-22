import 'package:flutter/material.dart';

import '../../../../core/game/move_input.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/extensions/build_context.dart';
import '../../../../shared/widgets/score_chip.dart';
import '../../domain/game.dart';
import '../../domain/move.dart';

class RoundHistoryList extends StatelessWidget {
  const RoundHistoryList({
    required this.moves,
    required this.players,
    required this.onEditMove,
    super.key,
  });

  final List<Move> moves;
  final List<GamePlayerSnapshot> players;
  final ValueChanged<Move> onEditMove;

  String _nameFor(String playerId) {
    return players
            .where((p) => p.playerId == playerId)
            .map((p) => p.displayName)
            .firstOrNull ??
        '?';
  }

  @override
  Widget build(BuildContext context) {
    if (moves.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x12),
        child: Text(
          '—',
          style: context.textStyles.bodyMedium,
          textAlign: TextAlign.center,
        ),
      );
    }

    final reversed = moves.reversed.toList();
    return Column(
      children: [
        for (final move in reversed)
          _MoveRow(
            move: move,
            playerName: _nameFor(move.playerId),
            onEdit: move.type == MoveType.play ? () => onEditMove(move) : null,
          ),
      ],
    );
  }
}

class _MoveRow extends StatelessWidget {
  const _MoveRow({
    required this.move,
    required this.playerName,
    required this.onEdit,
  });

  final Move move;
  final String playerName;
  final VoidCallback? onEdit;

  String _label(BuildContext context) {
    final l10n = context.l10n;
    switch (move.type) {
      case MoveType.play:
        final tile = '${move.corner1}-${move.corner2}-${move.corner3}';
        return '$playerName · $tile';
      case MoveType.drawPenalty:
        return '$playerName · ${l10n.penaltyDraw}';
      case MoveType.passPenalty:
        return '$playerName · ${l10n.penaltyPass}';
      case MoveType.endOfHandBonus:
        return '$playerName · ${l10n.bonusEndOfHand}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final highlight = move.isTriplet || move.isHexagon || move.isDoubleHexagon || move.isBridge;
    return InkWell(
      onLongPress: onEdit,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x8,
          vertical: AppSpacing.x12,
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      _label(context),
                      style: context.textStyles.bodyLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (highlight) ...[
                    AppSpacing.w4,
                    const Icon(Icons.auto_awesome_rounded, size: 16),
                  ],
                ],
              ),
            ),
            AppSpacing.w8,
            ScoreChip(value: move.totalScore, compact: true),
          ],
        ),
      ),
    );
  }
}
