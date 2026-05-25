import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/game/scoring_config.dart';
import '../../../core/settings/settings_provider.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/extensions/build_context.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/glass_container.dart';

/// Ekran konfiguracji zasad domowych (Premium): wartości bonusów i kar.
class HouseRulesPage extends ConsumerWidget {
  const HouseRulesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final config = ref.watch(settingsProvider.select((s) => s.scoringConfig));
    final notifier = ref.read(settingsProvider.notifier);
    void set(ScoringConfig c) => notifier.setScoringConfig(c);

    return AppScaffold(
      title: l10n.settingsHouseRules,
      body: ListView(
        children: [
          GlassContainer(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x16,
              vertical: AppSpacing.x8,
            ),
            child: Column(
              children: [
                _RuleRow(
                  label: l10n.inputBonusTriplet,
                  value: config.tripletBonus,
                  min: 0,
                  max: 100,
                  onChanged: (v) => set(config.copyWith(tripletBonus: v)),
                ),
                _RuleRow(
                  label: '0-0-0',
                  value: config.zeroTripletBonus,
                  min: 0,
                  max: 100,
                  onChanged: (v) => set(config.copyWith(zeroTripletBonus: v)),
                ),
                _RuleRow(
                  label: l10n.inputBonusBridge,
                  value: config.bridgeBonus,
                  min: 0,
                  max: 100,
                  onChanged: (v) => set(config.copyWith(bridgeBonus: v)),
                ),
                _RuleRow(
                  label: l10n.inputBonusHexagon,
                  value: config.hexagonBonus,
                  min: 0,
                  max: 150,
                  onChanged: (v) => set(config.copyWith(hexagonBonus: v)),
                ),
                _RuleRow(
                  label: l10n.inputBonusDoubleHexagon,
                  value: config.doubleHexagonBonus,
                  min: 0,
                  max: 150,
                  onChanged: (v) => set(config.copyWith(doubleHexagonBonus: v)),
                ),
                _RuleRow(
                  label: l10n.rulesStarterBonus,
                  value: config.starterBonus,
                  min: 0,
                  max: 50,
                  onChanged: (v) => set(config.copyWith(starterBonus: v)),
                ),
                _RuleRow(
                  label: l10n.rulesEndOfHand,
                  value: config.endOfHandBonus,
                  min: 0,
                  max: 100,
                  onChanged: (v) => set(config.copyWith(endOfHandBonus: v)),
                ),
                _RuleRow(
                  label: l10n.moveDraw,
                  value: config.drawPenalty,
                  min: -50,
                  max: 0,
                  onChanged: (v) => set(config.copyWith(drawPenalty: v)),
                ),
                _RuleRow(
                  label: l10n.gamePass,
                  value: config.passPenalty,
                  min: -50,
                  max: 0,
                  onChanged: (v) => set(config.copyWith(passPenalty: v)),
                  last: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x16),
          Center(
            child: TextButton.icon(
              onPressed: () => set(ScoringConfig.standard),
              icon: const Icon(Icons.restore),
              label: Text(l10n.rulesReset),
            ),
          ),
        ],
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.last = false,
  });

  static const int step = 5;

  final String label;
  final int value;
  final int min;
  final int max;
  final bool last;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4),
          child: Row(
            children: [
              Expanded(child: Text(label, style: context.text.bodyLarge)),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: value > min
                    ? () => onChanged((value - step).clamp(min, max))
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              SizedBox(
                width: 44,
                child: Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: context.text.titleLarge
                      ?.copyWith(color: context.colors.primary),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: value < max
                    ? () => onChanged((value + step).clamp(min, max))
                    : null,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
        ),
        if (!last)
          Divider(
            height: 1,
            color: context.colors.onSurface.withValues(alpha: 0.1),
          ),
      ],
    );
  }
}
