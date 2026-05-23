import 'package:flutter/material.dart';

import '../../../core/game/scoring_rules.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/extensions/build_context.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/glass_container.dart';

class RulesPage extends StatelessWidget {
  const RulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final rows = <(String, String)>[
      (l10n.inputBonusTriplet, '+${ScoringRules.tripletBonus}'),
      ('0-0-0', '+${ScoringRules.zeroTripletBonus}'),
      (l10n.inputBonusBridge, '+${ScoringRules.bridgeBonus}'),
      (l10n.inputBonusHexagon, '+${ScoringRules.hexagonBonus}'),
      (
        l10n.inputBonusDoubleHexagon,
        '+${ScoringRules.hexagonBonus + ScoringRules.doubleHexagonBonus}'
      ),
      (l10n.inputEndHand, '+${ScoringRules.endOfHandBonus}'),
      (l10n.inputDrawPile(ScoringRules.drawPenalty), '${ScoringRules.drawPenalty}'),
      (l10n.inputPassPenalty(ScoringRules.passPenalty), '${ScoringRules.passPenalty}'),
    ];

    return AppScaffold(
      title: l10n.rulesTitle,
      body: ListView(
        children: [
          GlassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.inputSummary, style: context.text.titleLarge),
                const SizedBox(height: AppSpacing.x16),
                for (final row in rows) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.x8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(child: Text(row.$1, style: context.text.bodyLarge)),
                        Text(
                          row.$2,
                          style: context.text.titleLarge?.copyWith(
                            color: context.colors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (row != rows.last)
                    Divider(color: context.colors.onSurface.withValues(alpha: 0.1)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
