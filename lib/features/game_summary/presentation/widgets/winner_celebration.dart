import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/color_hex.dart';
import '../../../../shared/extensions/build_context.dart';
import '../../../../shared/widgets/player_avatar.dart';
import '../../../game/domain/game.dart';

class WinnerCelebration extends StatefulWidget {
  const WinnerCelebration({required this.winner, super.key});

  final GamePlayerSnapshot winner;

  @override
  State<WinnerCelebration> createState() => _WinnerCelebrationState();
}

class _WinnerCelebrationState extends State<WinnerCelebration> {
  late final ConfettiController _confetti;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 3))..play();
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color = colorFromHex(widget.winner.avatarColor);

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          children: [
            AppSpacing.h16,
            PlayerAvatar(
              initials: widget.winner.initials,
              color: color,
              size: 112,
              isActive: true,
            ),
            AppSpacing.h16,
            const Text('🏆', style: TextStyle(fontSize: 40)),
            AppSpacing.h8,
            Text(
              widget.winner.displayName,
              style: context.textStyles.displaySmall,
              textAlign: TextAlign.center,
            ),
            Text(
              l10n.summaryWinner(widget.winner.displayName),
              style: context.textStyles.bodyMedium,
            ),
            Text(
              '${widget.winner.totalScore}',
              style: context.textStyles.displayMedium?.copyWith(color: color),
            ),
          ],
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confetti,
            blastDirection: math.pi / 2,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            gravity: 0.2,
            shouldLoop: false,
          ),
        ),
      ],
    );
  }
}
