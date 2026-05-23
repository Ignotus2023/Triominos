import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/game/move.dart';
import '../../../../core/game/scoring_rules.dart';
import '../../../../core/haptics/haptics_service.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/extensions/build_context.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../game_controller.dart';

/// Smart Input — bottom sheet do wprowadzania ruchu (§8).
class SmartInputSheet extends ConsumerStatefulWidget {
  const SmartInputSheet({
    required this.game,
    required this.round,
    required this.playerId,
    required this.playerName,
    required this.moveNumber,
    required this.isStarterMove,
    required this.opponentsCount,
    super.key,
  });

  final Game game;
  final Round round;
  final String playerId;
  final String playerName;
  final int moveNumber;
  final bool isStarterMove;
  final int opponentsCount;

  @override
  ConsumerState<SmartInputSheet> createState() => _SmartInputSheetState();
}

class _SmartInputSheetState extends ConsumerState<SmartInputSheet> {
  int? _c1;
  int? _c2;
  int? _c3;
  bool _bridge = false;
  bool _hexagon = false;
  bool _doubleHex = false;
  bool _endHandMode = false;
  final _handSumController = TextEditingController();

  bool get _complete => _c1 != null && _c2 != null && _c3 != null;

  Move? get _previewMove => _complete
      ? Move.play(
          corner1: _c1!,
          corner2: _c2!,
          corner3: _c3!,
          isBridge: _bridge,
          isHexagon: _hexagon,
          isDoubleHexagon: _doubleHex,
          isStarter: widget.isStarterMove,
        )
      : null;

  @override
  void dispose() {
    _handSumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final move = _previewMove;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.x16,
        left: AppSpacing.x12,
        right: AppSpacing.x12,
      ),
      child: GlassContainer(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.inputTitle(widget.playerName), style: context.text.titleLarge),
              Text(
                l10n.inputContext(widget.round.roundNumber, widget.moveNumber),
                style: context.text.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.x16),
              if (!_endHandMode) ...[
                Text(l10n.inputCorners, style: context.text.labelLarge),
                const SizedBox(height: AppSpacing.x8),
                _CornerRow(value: _c1, onSelected: (v) => _setCorner(0, v)),
                _CornerRow(value: _c2, onSelected: (v) => _setCorner(1, v)),
                _CornerRow(value: _c3, onSelected: (v) => _setCorner(2, v)),
                const SizedBox(height: AppSpacing.x16),
                Text(l10n.inputBonuses, style: context.text.labelLarge),
                const SizedBox(height: AppSpacing.x8),
                _buildBonuses(context, move),
                const SizedBox(height: AppSpacing.x16),
                _buildSummary(context, move),
                const SizedBox(height: AppSpacing.x16),
                PrimaryButton(
                  label: l10n.inputConfirm,
                  icon: Icons.check,
                  onPressed: _complete ? _confirmPlay : null,
                ),
                const SizedBox(height: AppSpacing.x12),
                _buildOtherActions(context),
              ] else
                _buildEndHand(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBonuses(BuildContext context, Move? move) {
    final l10n = context.l10n;
    final isTriplet = move?.isTriplet ?? false;
    return Wrap(
      spacing: AppSpacing.x8,
      runSpacing: AppSpacing.x8,
      children: [
        FilterChip(
          avatar: Icon(
            isTriplet ? Icons.auto_awesome : Icons.auto_awesome_outlined,
            size: 18,
          ),
          label: Text(l10n.inputBonusTriplet),
          selected: isTriplet,
          onSelected: null,
        ),
        FilterChip(
          label: Text(l10n.inputBonusBridge),
          selected: _bridge,
          onSelected: (v) {
            ref.read(hapticsProvider).light();
            setState(() => _bridge = v);
          },
        ),
        FilterChip(
          label: Text(l10n.inputBonusHexagon),
          selected: _hexagon,
          onSelected: (v) {
            ref.read(hapticsProvider).light();
            setState(() {
              _hexagon = v;
              if (v) _doubleHex = false;
            });
          },
        ),
        FilterChip(
          label: Text(l10n.inputBonusDoubleHexagon),
          selected: _doubleHex,
          onSelected: (v) {
            ref.read(hapticsProvider).light();
            setState(() {
              _doubleHex = v;
              if (v) _hexagon = false;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSummary(BuildContext context, Move? move) {
    final l10n = context.l10n;
    final base = move?.baseScore ?? 0;
    final bonus = move?.bonusScore ?? 0;
    final total = move?.totalScore ?? 0;
    return Column(
      children: [
        _summaryRow(context, l10n.inputBase, '$base'),
        if (bonus != 0) _summaryRow(context, l10n.inputBonusLine, '+$bonus'),
        const Divider(),
        _summaryRow(
          context,
          l10n.inputTotal,
          '$total',
          emphasize: true,
        ),
      ],
    );
  }

  Widget _summaryRow(BuildContext context, String label, String value,
      {bool emphasize = false}) {
    final style = emphasize
        ? context.text.headlineSmall?.copyWith(color: context.colors.primary)
        : context.text.bodyLarge;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: style), Text(value, style: style)],
      ),
    );
  }

  Widget _buildOtherActions(BuildContext context) {
    final l10n = context.l10n;
    return Wrap(
      spacing: AppSpacing.x8,
      runSpacing: AppSpacing.x8,
      alignment: WrapAlignment.center,
      children: [
        OutlinedButton.icon(
          icon: const Icon(Icons.download_outlined, size: 18),
          label: Text(l10n.inputDrawPile(ScoringRules.drawPenalty)),
          onPressed: () => _confirmPenalty(MoveType.drawPenalty),
        ),
        OutlinedButton.icon(
          icon: const Icon(Icons.skip_next_outlined, size: 18),
          label: Text(l10n.inputPassPenalty(ScoringRules.passPenalty)),
          onPressed: () => _confirmPenalty(MoveType.passPenalty),
        ),
        OutlinedButton.icon(
          icon: const Icon(Icons.flag_outlined, size: 18),
          label: Text(l10n.inputEndHand),
          onPressed: () => setState(() => _endHandMode = true),
        ),
      ],
    );
  }

  Widget _buildEndHand(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.inputEndHand, style: context.text.titleLarge),
        const SizedBox(height: AppSpacing.x8),
        Text(l10n.inputOpponentsHandSumHint, style: context.text.bodyMedium),
        const SizedBox(height: AppSpacing.x12),
        TextField(
          controller: _handSumController,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: l10n.inputOpponentsHandSum),
        ),
        const SizedBox(height: AppSpacing.x16),
        Row(
          children: [
            TextButton(
              onPressed: () => setState(() => _endHandMode = false),
              child: Text(l10n.commonBack),
            ),
            const Spacer(),
            FilledButton(
              onPressed: _confirmEndHand,
              child: Text(l10n.inputConfirm),
            ),
          ],
        ),
      ],
    );
  }

  void _setCorner(int index, int value) {
    ref.read(hapticsProvider).selection();
    setState(() {
      switch (index) {
        case 0:
          _c1 = value;
        case 1:
          _c2 = value;
        case 2:
          _c3 = value;
      }
    });
    if (_previewMove?.isTriplet ?? false) {
      ref.read(hapticsProvider).medium();
    }
  }

  Future<void> _confirmPlay() async {
    final move = _previewMove;
    if (move == null) return;
    ref.read(hapticsProvider).medium();
    await ref.read(gameControllerProvider).addPlay(
          game: widget.game,
          round: widget.round,
          playerId: widget.playerId,
          move: move,
        );
    if (mounted) Navigator.pop(context);
  }

  Future<void> _confirmPenalty(MoveType type) async {
    ref.read(hapticsProvider).light();
    await ref.read(gameControllerProvider).addPenalty(
          game: widget.game,
          round: widget.round,
          playerId: widget.playerId,
          type: type,
        );
    if (mounted) Navigator.pop(context);
  }

  Future<void> _confirmEndHand() async {
    final sum = int.tryParse(_handSumController.text.trim()) ?? 0;
    ref.read(hapticsProvider).medium();
    await ref.read(gameControllerProvider).endHand(
          game: widget.game,
          round: widget.round,
          finisherId: widget.playerId,
          opponentsHandSum: sum,
        );
    if (mounted) Navigator.pop(context);
  }
}

class _CornerRow extends StatelessWidget {
  const _CornerRow({required this.value, required this.onSelected});

  final int? value;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var i = ScoringRules.minCorner; i <= ScoringRules.maxCorner; i++)
            ChoiceChip(
              label: Text('$i'),
              selected: value == i,
              onSelected: (_) => onSelected(i),
            ),
        ],
      ),
    );
  }
}
