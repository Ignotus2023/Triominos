import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/game/scoring_rules.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/extensions/build_context.dart';
import '../../../../shared/widgets/selectable_card.dart';
import '../game_setup_controller.dart';

class VariantStep extends ConsumerWidget {
  const VariantStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(gameSetupControllerProvider);
    final controller = ref.read(gameSetupControllerProvider.notifier);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
      children: [
        Text(l10n.gameSetupVariantTitle, style: context.textStyles.titleMedium),
        AppSpacing.h16,
        _VariantCard(
          title: l10n.gameSetupVariantGoliath,
          description: l10n.gameSetupVariantGoliathDescription,
          selected: state.variant == ScoringVariant.goliath,
          onTap: () => controller.setVariant(ScoringVariant.goliath),
        ),
        AppSpacing.h12,
        _VariantCard(
          title: l10n.gameSetupVariantPressman,
          description: l10n.gameSetupVariantPressmanDescription,
          selected: state.variant == ScoringVariant.pressman,
          onTap: () => controller.setVariant(ScoringVariant.pressman),
        ),
      ],
    );
  }
}

class _VariantCard extends StatelessWidget {
  const _VariantCard({
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
