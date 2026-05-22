import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/game/end_game_evaluator.dart';
import '../../../../core/game/scoring_rules.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/color_hex.dart';
import '../../../../shared/extensions/build_context.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../../../shared/widgets/player_avatar.dart';
import '../game_setup_controller.dart';

class ReviewStep extends ConsumerWidget {
  const ReviewStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(gameSetupControllerProvider);

    final variantLabel = state.variant == ScoringVariant.goliath
        ? l10n.gameSetupVariantGoliath
        : l10n.gameSetupVariantPressman;

    final (endModeLabel, endModeValue) = switch (state.endMode) {
      EndMode.scoreLimit => (l10n.gameSetupEndModeScoreLimit, '${state.scoreLimit}'),
      EndMode.rounds => (l10n.gameSetupEndModeRounds, '${state.totalRounds}'),
      EndMode.freeform => (l10n.gameSetupEndModeFreeform, ''),
    };

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
      children: [
        Text(l10n.gameSetupStepReview, style: context.textStyles.titleMedium),
        AppSpacing.h16,
        GlassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.gameSetupStepPlayers, style: context.textStyles.titleSmall),
              AppSpacing.h12,
              for (var i = 0; i < state.players.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.x8),
                  child: Row(
                    children: [
                      Text('${i + 1}', style: context.textStyles.labelLarge),
                      AppSpacing.w12,
                      PlayerAvatar(
                        initials: state.players[i].initials,
                        color: colorFromHex(state.players[i].avatarColor),
                        size: 32,
                      ),
                      AppSpacing.w12,
                      Text(state.players[i].name, style: context.textStyles.bodyLarge),
                    ],
                  ),
                ),
            ],
          ),
        ),
        AppSpacing.h12,
        GlassContainer(
          child: Column(
            children: [
              _ReviewRow(label: l10n.gameSetupVariantTitle, value: variantLabel),
              const Divider(),
              _ReviewRow(
                label: endModeLabel,
                value: endModeValue,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: context.textStyles.bodyMedium),
        Text(value, style: context.textStyles.titleSmall),
      ],
    );
  }
}
