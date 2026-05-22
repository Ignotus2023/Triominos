import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/color_hex.dart';
import '../../../../shared/extensions/build_context.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../../../shared/widgets/player_avatar.dart';
import '../../../../shared/widgets/score_chip.dart';
import '../../domain/game.dart';

class PlayerScoreCard extends StatelessWidget {
  const PlayerScoreCard({
    required this.player,
    required this.isActive,
    this.lastDelta,
    this.turnLabel,
    super.key,
  });

  final GamePlayerSnapshot player;
  final bool isActive;
  final int? lastDelta;
  final String? turnLabel;

  @override
  Widget build(BuildContext context) {
    final color = colorFromHex(player.avatarColor);
    final scheme = context.colors;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: isActive ? scheme.primary : Colors.transparent,
          width: 2,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.35),
                  blurRadius: 24,
                  spreadRadius: -2,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: GlassContainer(
        tintColor: isActive ? color.withValues(alpha: 0.12) : null,
        padding: const EdgeInsets.all(AppSpacing.x16),
        child: Row(
          children: [
            PlayerAvatar(
              initials: player.initials,
              color: color,
              size: isActive ? 56 : 44,
              isActive: isActive,
            ),
            AppSpacing.w16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    player.displayName,
                    style: isActive
                        ? context.textStyles.titleLarge
                        : context.textStyles.titleMedium,
                  ),
                  if (isActive && turnLabel != null)
                    Text(
                      turnLabel!,
                      style: context.textStyles.labelMedium?.copyWith(
                        color: scheme.primary,
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${player.totalScore}',
                  style: (isActive
                          ? context.textStyles.displaySmall
                          : context.textStyles.headlineSmall)
                      ?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                    color: isActive ? AppColors.indigo500 : scheme.onSurface,
                  ),
                ),
                if (lastDelta != null && lastDelta != 0) ...[
                  AppSpacing.h4,
                  ScoreChip(value: lastDelta!, compact: true),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
