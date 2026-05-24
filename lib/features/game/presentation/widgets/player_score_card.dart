import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/extensions/build_context.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../../../shared/widgets/player_avatar.dart';
import '../../../players/players_providers.dart';

class PlayerScoreCard extends StatelessWidget {
  const PlayerScoreCard({
    required this.seat,
    required this.active,
    required this.colorHex,
    super.key,
  });

  final GamePlayer seat;
  final bool active;
  final String colorHex;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final card = GlassContainer(
      glow: active,
      child: Row(
        children: [
          PlayerAvatar(
            initials: initialsFor(seat.displayNameSnapshot),
            colorHex: colorHex,
            active: active,
            size: 44,
          ),
          const SizedBox(width: AppSpacing.x16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(seat.displayNameSnapshot, style: context.text.titleLarge),
                if (active)
                  Text(
                    l10n.gameYourTurn,
                    style: context.text.labelSmall?.copyWith(
                      color: context.colors.primary,
                      letterSpacing: 1.2,
                    ),
                  ),
              ],
            ),
          ),
          AnimatedFlipCounter(
            value: seat.totalScore,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            suffix: ' ${l10n.scoreSuffix}',
            textStyle: context.text.headlineSmall,
          ),
        ],
      ),
    );

    return active ? card.animate().fadeIn(duration: 200.ms) : card;
  }
}
