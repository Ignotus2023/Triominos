import 'package:flutter/material.dart';

import '../../../../core/game/scoring_rules.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/color_hex.dart';
import '../../../../shared/extensions/build_context.dart';
import '../../../../shared/widgets/player_avatar.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/game.dart';

class EndRoundResult {
  const EndRoundResult({
    required this.finisherPlayerId,
    required this.opponentHandSums,
  });

  final String finisherPlayerId;
  final Map<String, int> opponentHandSums;
}

Future<EndRoundResult?> showEndRoundSheet(
  BuildContext context, {
  required List<GamePlayerSnapshot> players,
  required ScoringRules rules,
}) {
  return showModalBottomSheet<EndRoundResult>(
    context: context,
    isScrollControlled: true,
    builder: (_) => FractionallySizedBox(
      heightFactor: 0.85,
      child: _EndRoundSheet(players: players, rules: rules),
    ),
  );
}

class _EndRoundSheet extends StatefulWidget {
  const _EndRoundSheet({required this.players, required this.rules});

  final List<GamePlayerSnapshot> players;
  final ScoringRules rules;

  @override
  State<_EndRoundSheet> createState() => _EndRoundSheetState();
}

class _EndRoundSheetState extends State<_EndRoundSheet> {
  String? _finisherId;
  final Map<String, int> _sums = {};

  int get _opponentTotal => _sums.values.fold(0, (a, b) => a + b);

  int get _finisherBonus => widget.rules.endOfHandBonus + _opponentTotal;

  void _selectFinisher(String id) {
    setState(() {
      _finisherId = id;
      _sums
        ..clear()
        ..addEntries(
          widget.players.where((p) => p.playerId != id).map((p) => MapEntry(p.playerId, 0)),
        );
    });
  }

  void _adjust(String playerId, int delta) {
    setState(() {
      final next = (_sums[playerId] ?? 0) + delta;
      _sums[playerId] = next.clamp(0, 999);
    });
  }

  void _confirm() {
    final finisher = _finisherId;
    if (finisher == null) return;
    Navigator.pop(
      context,
      EndRoundResult(finisherPlayerId: finisher, opponentHandSums: Map.of(_sums)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final finisher = _finisherId;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x20,
        AppSpacing.x16,
        AppSpacing.x20,
        AppSpacing.x24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.endRoundTitle, style: context.textStyles.headlineSmall),
          AppSpacing.h4,
          Text(l10n.endRoundChoosePlayer, style: context.textStyles.bodyMedium),
          AppSpacing.h12,
          Wrap(
            spacing: AppSpacing.x8,
            runSpacing: AppSpacing.x8,
            children: widget.players.map((p) {
              final selected = p.playerId == finisher;
              return ChoiceChip(
                label: Text(p.displayName),
                selected: selected,
                avatar: PlayerAvatar(
                  initials: p.initials,
                  color: colorFromHex(p.avatarColor),
                  size: 24,
                ),
                onSelected: (_) => _selectFinisher(p.playerId),
              );
            }).toList(),
          ),
          if (finisher != null) ...[
            AppSpacing.h20,
            Text(l10n.endRoundOpponentsHandTitle, style: context.textStyles.titleMedium),
            AppSpacing.h4,
            Text(l10n.endRoundOpponentsHandBody, style: context.textStyles.bodySmall),
            AppSpacing.h12,
            Expanded(
              child: ListView(
                children: [
                  for (final p in widget.players.where((p) => p.playerId != finisher))
                    _HandSumRow(
                      player: p,
                      value: _sums[p.playerId] ?? 0,
                      onMinus: () => _adjust(p.playerId, -1),
                      onPlus: () => _adjust(p.playerId, 1),
                      onSet: (v) => setState(() => _sums[p.playerId] = v),
                    ),
                ],
              ),
            ),
            _FinisherSummary(
              bonusLabel: l10n.endRoundBonusPlus25,
              total: _finisherBonus,
            ),
            AppSpacing.h12,
            PrimaryButton(label: l10n.endRoundConfirm, onPressed: _confirm),
          ] else
            const Spacer(),
        ],
      ),
    );
  }
}

class _HandSumRow extends StatelessWidget {
  const _HandSumRow({
    required this.player,
    required this.value,
    required this.onMinus,
    required this.onPlus,
    required this.onSet,
  });

  final GamePlayerSnapshot player;
  final int value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final ValueChanged<int> onSet;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x12),
      child: Row(
        children: [
          PlayerAvatar(
            initials: player.initials,
            color: colorFromHex(player.avatarColor),
            size: 36,
          ),
          AppSpacing.w12,
          Expanded(child: Text(player.displayName, style: context.textStyles.titleSmall)),
          IconButton.filledTonal(
            icon: const Icon(Icons.remove_rounded),
            onPressed: value > 0 ? onMinus : null,
          ),
          SizedBox(
            width: 48,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: context.textStyles.headlineSmall,
            ),
          ),
          IconButton.filledTonal(
            icon: const Icon(Icons.add_rounded),
            onPressed: onPlus,
          ),
        ],
      ),
    );
  }
}

class _FinisherSummary extends StatelessWidget {
  const _FinisherSummary({required this.bonusLabel, required this.total});

  final String bonusLabel;
  final int total;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.x16),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(bonusLabel, style: context.textStyles.titleSmall),
          Text(
            '+$total',
            style: context.textStyles.displaySmall?.copyWith(color: scheme.primary),
          ),
        ],
      ),
    );
  }
}
