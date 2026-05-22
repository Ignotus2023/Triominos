import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/game/move_input.dart';
import '../../../../core/game/score_breakdown.dart';
import '../../../../core/game/score_calculator.dart';
import '../../../../core/game/scoring_rules.dart';
import '../../../../core/haptics/haptics_service.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/extensions/build_context.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/tile_glyph.dart';
import '../../domain/move.dart';
import 'corner_picker.dart';

class SmartInputArgs {
  const SmartInputArgs({
    required this.playerName,
    required this.roundNumber,
    required this.moveNumber,
    required this.variant,
    this.isStarterMove = false,
    this.editing,
  });

  final String playerName;
  final int roundNumber;
  final int moveNumber;
  final ScoringVariant variant;
  final bool isStarterMove;
  final Move? editing;
}

Future<MoveInput?> showSmartInputSheet(
  BuildContext context,
  SmartInputArgs args,
) {
  return showModalBottomSheet<MoveInput>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _SmartInputSheet(args: args),
  );
}

class _SmartInputSheet extends ConsumerStatefulWidget {
  const _SmartInputSheet({required this.args});

  final SmartInputArgs args;

  @override
  ConsumerState<_SmartInputSheet> createState() => _SmartInputSheetState();
}

class _SmartInputSheetState extends ConsumerState<_SmartInputSheet> {
  int? _c1;
  int? _c2;
  int? _c3;
  bool _bridge = false;
  bool _hexagon = false;
  bool _doubleHexagon = false;
  bool _wasTriplet = false;

  @override
  void initState() {
    super.initState();
    final editing = widget.args.editing;
    if (editing != null) {
      _c1 = editing.corner1;
      _c2 = editing.corner2;
      _c3 = editing.corner3;
      _bridge = editing.isBridge;
      _hexagon = editing.isHexagon;
      _doubleHexagon = editing.isDoubleHexagon;
    }
  }

  bool get _isComplete => _c1 != null && _c2 != null && _c3 != null;

  bool get _isTriplet => _isComplete && _c1 == _c2 && _c2 == _c3;

  MoveInput? get _currentInput {
    if (!_isComplete) return null;
    return MoveInput.play(
      corner1: _c1!,
      corner2: _c2!,
      corner3: _c3!,
      isBridge: _bridge,
      isHexagon: _hexagon,
      isDoubleHexagon: _doubleHexagon,
      isStarter: widget.args.isStarterMove,
    );
  }

  void _onCornerChanged() {
    if (_isTriplet && !_wasTriplet) {
      ref.read(hapticsServiceProvider).trigger(HapticPattern.medium);
    }
    _wasTriplet = _isTriplet;
    setState(() {});
  }

  void _toggleHexagon() {
    setState(() {
      _hexagon = !_hexagon;
      if (_hexagon) _doubleHexagon = false;
    });
    ref.read(hapticsServiceProvider).trigger(HapticPattern.light);
  }

  void _toggleDoubleHexagon() {
    setState(() {
      _doubleHexagon = !_doubleHexagon;
      if (_doubleHexagon) _hexagon = false;
    });
    ref.read(hapticsServiceProvider).trigger(HapticPattern.light);
  }

  void _submit() {
    final input = _currentInput;
    if (input == null) return;
    ref.read(hapticsServiceProvider).trigger(HapticPattern.medium);
    Navigator.pop(context, input);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final haptics = ref.read(hapticsServiceProvider);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final rules = ScoringRules.forVariant(widget.args.variant);
    final breakdown = _currentInput == null
        ? null
        : ScoreCalculator(rules).calculate(_currentInput!);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.x20,
        AppSpacing.x8,
        AppSpacing.x20,
        AppSpacing.x24 + bottomInset,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.smartInputTitle(widget.args.playerName),
              style: context.textStyles.headlineSmall,
            ),
            Text(
              '${l10n.gameRoundLabel(widget.args.roundNumber)} · '
              '${l10n.gameMoveLabel(widget.args.moveNumber)}',
              style: context.textStyles.bodyMedium,
            ),
            AppSpacing.h20,
            if (_isComplete)
              Center(
                child: TileGlyph(
                  corner1: _c1!,
                  corner2: _c2!,
                  corner3: _c3!,
                  size: 96,
                ),
              ),
            AppSpacing.h16,
            Text(l10n.smartInputCornersLabel, style: context.textStyles.titleSmall),
            AppSpacing.h12,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CornerPicker(
                  value: _c1,
                  haptics: haptics,
                  onChanged: (v) {
                    _c1 = v;
                    _onCornerChanged();
                  },
                ),
                CornerPicker(
                  value: _c2,
                  haptics: haptics,
                  onChanged: (v) {
                    _c2 = v;
                    _onCornerChanged();
                  },
                ),
                CornerPicker(
                  value: _c3,
                  haptics: haptics,
                  onChanged: (v) {
                    _c3 = v;
                    _onCornerChanged();
                  },
                ),
              ],
            ),
            AppSpacing.h20,
            if (_isTriplet)
              _TripletBanner(label: l10n.smartInputAutoTripletHint),
            AppSpacing.h12,
            Text(l10n.smartInputBonusesLabel, style: context.textStyles.titleSmall),
            AppSpacing.h12,
            Wrap(
              spacing: AppSpacing.x8,
              runSpacing: AppSpacing.x8,
              children: [
                _BonusChip(
                  label: '${l10n.bonusBridge} +${rules.bridgeBonus}',
                  selected: _bridge,
                  onTap: () {
                    setState(() => _bridge = !_bridge);
                    haptics.trigger(HapticPattern.light);
                  },
                ),
                _BonusChip(
                  label: '${l10n.bonusHexagon} +${rules.hexagonBonus}',
                  selected: _hexagon,
                  onTap: _toggleHexagon,
                ),
                _BonusChip(
                  label: '${l10n.bonusDoubleHexagon} +${rules.hexagonBonus + rules.doubleHexagonBonus}',
                  selected: _doubleHexagon,
                  onTap: _toggleDoubleHexagon,
                ),
                if (widget.args.isStarterMove && rules.starterBonus > 0)
                  _BonusChip(
                    label: '${l10n.bonusStarter} +${rules.starterBonus}',
                    selected: true,
                    locked: true,
                    onTap: () {},
                  ),
              ],
            ),
            AppSpacing.h20,
            if (breakdown != null) _Breakdown(breakdown: breakdown, l10n: l10n),
            AppSpacing.h16,
            PrimaryButton(
              label: l10n.smartInputConfirm,
              icon: Icons.check_rounded,
              onPressed: _isComplete ? _submit : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _TripletBanner extends StatelessWidget {
  const _TripletBanner({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.x12),
      decoration: BoxDecoration(
        color: context.colors.tertiary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome_rounded, color: context.colors.tertiary, size: 20),
          AppSpacing.w8,
          Text(label, style: context.textStyles.titleSmall),
        ],
      ),
    );
  }
}

class _BonusChip extends StatelessWidget {
  const _BonusChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.locked = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    return FilterChip(
      label: Text(label),
      selected: selected,
      showCheckmark: !locked,
      avatar: locked ? const Icon(Icons.lock_rounded, size: 16) : null,
      onSelected: locked ? null : (_) => onTap(),
      selectedColor: scheme.primary.withValues(alpha: 0.18),
      side: BorderSide(
        color: selected ? scheme.primary : scheme.outline.withValues(alpha: 0.4),
      ),
    );
  }
}

class _Breakdown extends StatelessWidget {
  const _Breakdown({required this.breakdown, required this.l10n});

  final ScoreBreakdown breakdown;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final rows = <(String, int)>[
      (l10n.smartInputBaseLabel, breakdown.base),
      if (breakdown.tripletBonus != 0) (l10n.bonusTriplet, breakdown.tripletBonus),
      if (breakdown.bridgeBonus != 0) (l10n.bonusBridge, breakdown.bridgeBonus),
      if (breakdown.hexagonBonus != 0) (l10n.bonusHexagon, breakdown.hexagonBonus),
      if (breakdown.doubleHexagonBonus != 0)
        (l10n.bonusDoubleHexagon, breakdown.doubleHexagonBonus),
      if (breakdown.starterBonus != 0) (l10n.bonusStarter, breakdown.starterBonus),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.x16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        children: [
          for (final (label, value) in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(label, style: context.textStyles.bodyMedium),
                  Text(
                    '${value >= 0 ? '+' : ''}$value',
                    style: context.textStyles.titleSmall,
                  ),
                ],
              ),
            ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.smartInputTotalLabel, style: context.textStyles.titleMedium),
              Text(
                '+${breakdown.total}',
                style: context.textStyles.displaySmall?.copyWith(color: scheme.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
