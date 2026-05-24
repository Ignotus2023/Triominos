import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/extensions/build_context.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../../../shared/widgets/player_avatar.dart';

class PlayerScoreCard extends StatelessWidget {
  const PlayerScoreCard({
    required this.seat,
    required this.active,
    super.key,
  });

  final GamePlayer seat;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final card = GlassContainer(
      glow: active,
      child: Row(
        children: [
          PlayerAvatar(
            initials: seat.displayNameSnapshot.isNotEmpty
                ? seat.displayNameSnapshot[0].toUpperCase()
                : '?',
            colorHex: '#6366F1',
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
          Text(
            l10n.scoreUnit(seat.totalScore),
            style: context.text.headlineSmall,
          ),
        ],
      ),
    );

    return active ? card.animate().fadeIn(duration: 200.ms) : card;
  }
}
