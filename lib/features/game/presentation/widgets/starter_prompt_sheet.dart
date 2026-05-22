import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/color_hex.dart';
import '../../../../shared/extensions/build_context.dart';
import '../../../../shared/widgets/player_avatar.dart';
import '../../domain/game.dart';

class StarterChoice {
  const StarterChoice({required this.playerId, required this.byTriplet});
  final String playerId;
  final bool byTriplet;
}

Future<StarterChoice?> showStarterPrompt(
  BuildContext context, {
  required List<GamePlayerSnapshot> players,
  required int roundNumber,
}) {
  return showModalBottomSheet<StarterChoice>(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    builder: (_) => _StarterPromptSheet(players: players, roundNumber: roundNumber),
  );
}

class _StarterPromptSheet extends StatefulWidget {
  const _StarterPromptSheet({required this.players, required this.roundNumber});

  final List<GamePlayerSnapshot> players;
  final int roundNumber;

  @override
  State<_StarterPromptSheet> createState() => _StarterPromptSheetState();
}

class _StarterPromptSheetState extends State<_StarterPromptSheet> {
  bool _byTriplet = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x20,
        AppSpacing.x8,
        AppSpacing.x20,
        AppSpacing.x24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.starterPromptTitle, style: context.textStyles.headlineSmall),
          AppSpacing.h4,
          Text(l10n.starterPromptBody, style: context.textStyles.bodyMedium),
          AppSpacing.h8,
          Text(l10n.starterNoTripletHint, style: context.textStyles.bodySmall),
          AppSpacing.h16,
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: _byTriplet,
            onChanged: (v) => setState(() => _byTriplet = v),
            title: Text(l10n.starterByHighestSum, style: context.textStyles.bodyMedium),
            secondary: const Icon(Icons.casino_outlined),
          ),
          AppSpacing.h8,
          ...widget.players.map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x8),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  side: BorderSide(color: context.colors.outlineVariant),
                ),
                leading: PlayerAvatar(
                  initials: p.initials,
                  color: colorFromHex(p.avatarColor),
                  size: 40,
                ),
                title: Text(p.displayName, style: context.textStyles.titleMedium),
                trailing: const Icon(Icons.play_arrow_rounded),
                onTap: () => Navigator.pop(
                  context,
                  StarterChoice(playerId: p.playerId, byTriplet: _byTriplet),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
