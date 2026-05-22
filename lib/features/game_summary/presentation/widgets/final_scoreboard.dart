import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/color_hex.dart';
import '../../../../shared/extensions/build_context.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../../../shared/widgets/player_avatar.dart';
import '../../../game/domain/game.dart';

class FinalScoreboard extends StatelessWidget {
  const FinalScoreboard({required this.ranking, super.key});

  final List<GamePlayerSnapshot> ranking;

  static const _medals = ['🥇', '🥈', '🥉'];

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: Column(
        children: [
          for (var i = 0; i < ranking.length; i++) ...[
            if (i > 0) const Divider(),
            _ScoreRow(
              place: i + 1,
              medal: i < _medals.length ? _medals[i] : null,
              player: ranking[i],
            ),
          ],
        ],
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  const _ScoreRow({required this.place, required this.medal, required this.player});

  final int place;
  final String? medal;
  final GamePlayerSnapshot player;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x8),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: medal != null
                ? Text(medal!, style: const TextStyle(fontSize: 22))
                : Text('$place', style: context.textStyles.titleMedium),
          ),
          AppSpacing.w8,
          PlayerAvatar(
            initials: player.initials,
            color: colorFromHex(player.avatarColor),
            size: 40,
          ),
          AppSpacing.w12,
          Expanded(
            child: Text(player.displayName, style: context.textStyles.titleMedium),
          ),
          Text(
            '${player.totalScore}',
            style: context.textStyles.headlineSmall?.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
