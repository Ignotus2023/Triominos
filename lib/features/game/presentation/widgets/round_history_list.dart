import 'package:flutter/material.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/game/move.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/extensions/build_context.dart';
import '../../../../shared/widgets/glass_container.dart';

class RoundHistoryList extends StatelessWidget {
  const RoundHistoryList({
    required this.moves,
    required this.seats,
    required this.onUndoLast,
    this.onEdit,
    super.key,
  });

  final List<MoveRow> moves;
  final List<GamePlayer> seats;
  final VoidCallback onUndoLast;

  /// Long-press na zagraniu (edycja Premium). Tylko dla ruchów typu `play`.
  final void Function(MoveRow move)? onEdit;

  String _nameOf(String playerId) => seats
      .firstWhere(
        (s) => s.playerId == playerId,
        orElse: () => seats.first,
      )
      .displayNameSnapshot;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (moves.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.x16),
        child: Text(l10n.gameNoMoves, style: context.text.bodyMedium),
      );
    }

    final reversed = moves.reversed.toList();
    return Column(
      children: [
        for (var i = 0; i < reversed.length; i++)
          _MoveTile(
            move: reversed[i],
            name: _nameOf(reversed[i].playerId),
            canUndo: i == 0,
            onUndo: onUndoLast,
            onLongPress:
                (onEdit != null && reversed[i].moveType == MoveType.play)
                    ? () => onEdit!(reversed[i])
                    : null,
          ),
      ],
    );
  }
}

class _MoveTile extends StatelessWidget {
  const _MoveTile({
    required this.move,
    required this.name,
    required this.canUndo,
    required this.onUndo,
    this.onLongPress,
  });

  final MoveRow move;
  final String name;
  final bool canUndo;
  final VoidCallback onUndo;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final total = move.baseScore + move.bonusScore;
    final hasBonus = move.bonusScore != 0 &&
        (move.isTriplet || move.isBridge || move.isHexagon || move.isDoubleHexagon);
    final positive = total >= 0;

    final tile = GlassContainer(
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
                  TextSpan(
                    text: '$name  ',
                    style: context.text.bodyLarge,
                  ),
                  TextSpan(
                    text: _describe(context),
                    style: context.text.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          if (hasBonus)
            const Padding(
              padding: EdgeInsets.only(right: AppSpacing.x8),
              child: Icon(Icons.auto_awesome, size: 16, color: Colors.amber),
            ),
          Text(
            '${positive ? '+' : ''}$total',
            style: context.text.titleLarge?.copyWith(
              color: positive ? context.colors.primary : context.colors.error,
            ),
          ),
          if (canUndo)
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.undo, size: 18),
              onPressed: onUndo,
            ),
        ],
      ),
    );

    if (onLongPress == null) return tile;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: onLongPress,
      child: tile,
    );
  }

  String _describe(BuildContext context) {
    final l10n = context.l10n;
    return switch (move.moveType) {
      MoveType.play => '(${move.corner1}-${move.corner2}-${move.corner3})',
      MoveType.drawPenalty => l10n.moveDraw,
      MoveType.passPenalty => l10n.gamePass,
      MoveType.endOfHandBonus => l10n.gameEndHand,
    };
  }
}
