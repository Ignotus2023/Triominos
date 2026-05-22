import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants.dart';
import '../../../../core/game/end_game_evaluator.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/extensions/build_context.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../../../shared/widgets/selectable_card.dart';
import '../game_setup_controller.dart';

class EndModeStep extends ConsumerWidget {
  const EndModeStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(gameSetupControllerProvider);
    final controller = ref.read(gameSetupControllerProvider.notifier);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
      children: [
        Text(l10n.gameSetupEndModeTitle, style: context.textStyles.titleMedium),
        AppSpacing.h16,
        _ModeCard(
          title: l10n.gameSetupEndModeScoreLimit,
          description: l10n.gameSetupEndModeScoreLimitDescription,
          selected: state.endMode == EndMode.scoreLimit,
          onTap: () => controller.setEndMode(EndMode.scoreLimit),
        ),
        AppSpacing.h12,
        _ModeCard(
          title: l10n.gameSetupEndModeRounds,
          description: l10n.gameSetupEndModeRoundsDescription,
          selected: state.endMode == EndMode.rounds,
          onTap: () => controller.setEndMode(EndMode.rounds),
        ),
        AppSpacing.h12,
        _ModeCard(
          title: l10n.gameSetupEndModeFreeform,
          description: l10n.gameSetupEndModeFreeformDescription,
          selected: state.endMode == EndMode.freeform,
          onTap: () => controller.setEndMode(EndMode.freeform),
        ),
        AppSpacing.h24,
        if (state.endMode == EndMode.scoreLimit)
          _ThresholdControl(
            label: l10n.gameSetupScoreLimit,
            value: state.scoreLimit,
            min: AppConstants.minScoreLimit,
            max: AppConstants.maxScoreLimit,
            step: AppConstants.scoreLimitStep,
            onChanged: controller.setScoreLimit,
          ),
        if (state.endMode == EndMode.rounds)
          _ThresholdControl(
            label: l10n.gameSetupRoundsCount,
            value: state.totalRounds,
            min: AppConstants.minRoundCount,
            max: AppConstants.maxRoundCount,
            step: 1,
            onChanged: controller.setTotalRounds,
          ),
      ],
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SelectableCard(
      selected: selected,
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
            color: selected ? context.colors.primary : context.colors.outline,
          ),
          AppSpacing.w16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.textStyles.titleMedium),
                AppSpacing.h4,
                Text(description, style: context.textStyles.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThresholdControl extends StatelessWidget {
  const _ThresholdControl({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.step,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final int step;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final divisions = ((max - min) / step).round();
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: context.textStyles.titleSmall),
              Text(
                '$value',
                style: context.textStyles.headlineSmall?.copyWith(
                  color: context.colors.primary,
                ),
              ),
            ],
          ),
          Slider(
            value: value.toDouble().clamp(min.toDouble(), max.toDouble()),
            min: min.toDouble(),
            max: max.toDouble(),
            divisions: divisions,
            label: '$value',
            onChanged: (v) => onChanged(v.round()),
          ),
        ],
      ),
    );
  }
}
