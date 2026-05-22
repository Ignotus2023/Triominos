import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/game/game_status.dart';
import '../../../core/game/move_input.dart';
import '../../../core/game/scoring_rules.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/extensions/build_context.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/primary_button.dart';
import '../domain/game.dart';
import '../domain/move.dart';
import '../domain/round.dart';
import 'game_providers.dart';
import 'widgets/end_round_sheet.dart';
import 'widgets/player_score_card.dart';
import 'widgets/round_history_list.dart';
import 'widgets/smart_input_sheet.dart';
import 'widgets/starter_prompt_sheet.dart';

class GamePage extends ConsumerWidget {
  const GamePage({required this.gameId, super.key});

  final String gameId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    ref.listen(gameProvider(gameId), (prev, next) {
      final game = next.valueOrNull;
      if (game != null && game.status == GameStatus.finished) {
        context.pushReplacementNamed(
          AppRoute.gameSummary,
          pathParameters: {'gameId': gameId},
        );
      }
    });

    final gameAsync = ref.watch(gameProvider(gameId));

    return gameAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('${l10n.errorGeneric}\n$e'))),
      data: (game) {
        if (game == null) {
          return Scaffold(body: Center(child: Text(l10n.errorGeneric)));
        }
        return _GameView(game: game);
      },
    );
  }
}

class _GameView extends ConsumerWidget {
  const _GameView({required this.game});

  final Game game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final round = ref.watch(currentRoundProvider(game.id));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.gameRoundLabel(game.currentRound), style: context.textStyles.titleMedium),
            Text(
              l10n.gameTilesPlayedLabel(game.playedTilesCount, 56),
              style: context.textStyles.labelSmall,
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'end') {
                ref.read(gameActionsProvider).endGameManually(gameId: game.id);
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(value: 'end', child: Text(l10n.summaryTitle)),
            ],
          ),
        ],
      ),
      body: round == null
          ? _StartRoundView(game: game)
          : _ActiveRoundView(game: game, round: round),
    );
  }
}

class _StartRoundView extends ConsumerWidget {
  const _StartRoundView({required this.game});

  final Game game;

  Future<void> _startRound(BuildContext context, WidgetRef ref) async {
    final choice = await showStarterPrompt(
      context,
      players: game.players,
      roundNumber: game.currentRound,
    );
    if (choice == null) return;
    await ref.read(gameActionsProvider).startRound(
          gameId: game.id,
          starterPlayerId: choice.playerId,
          byTriplet: choice.byTriplet,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.flag_outlined, size: 64, color: context.colors.primary),
            AppSpacing.h16,
            Text(
              l10n.gameRoundLabel(game.currentRound),
              style: context.textStyles.headlineMedium,
            ),
            AppSpacing.h8,
            Text(
              l10n.starterPromptBody,
              style: context.textStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            AppSpacing.h24,
            PrimaryButton(
              label: l10n.commonStart,
              icon: Icons.play_arrow_rounded,
              expand: false,
              onPressed: () => _startRound(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveRoundView extends ConsumerWidget {
  const _ActiveRoundView({required this.game, required this.round});

  final Game game;
  final Round round;

  Future<void> _addMove(
    BuildContext context,
    WidgetRef ref,
    List<Move> moves,
  ) async {
    final active = game.activePlayer;
    if (active == null) return;
    final isStarterMove = round.roundNumber == 1 && moves.isEmpty;
    final input = await showSmartInputSheet(
      context,
      SmartInputArgs(
        playerName: active.displayName,
        roundNumber: round.roundNumber,
        moveNumber: moves.length + 1,
        variant: game.scoringVariant,
        isStarterMove: isStarterMove,
      ),
    );
    if (input == null) return;
    await ref.read(gameActionsProvider).submitMove(
          gameId: game.id,
          round: round,
          input: input,
        );
  }

  Future<void> _editMove(BuildContext context, WidgetRef ref, Move move) async {
    final player = game.players.firstWhere((p) => p.playerId == move.playerId);
    final input = await showSmartInputSheet(
      context,
      SmartInputArgs(
        playerName: player.displayName,
        roundNumber: round.roundNumber,
        moveNumber: move.moveIndex + 1,
        variant: game.scoringVariant,
        isStarterMove: move.isStarter,
        editing: move,
      ),
    );
    if (input == null) return;
    await ref.read(gameActionsProvider).editMove(
          gameId: game.id,
          oldMove: move,
          input: input,
        );
  }

  Future<void> _penalty(WidgetRef ref, MoveInput input) async {
    await ref.read(gameActionsProvider).submitMove(
          gameId: game.id,
          round: round,
          input: input,
        );
  }

  Future<void> _endRound(BuildContext context, WidgetRef ref) async {
    final result = await showEndRoundSheet(
      context,
      players: game.players,
      rules: ScoringRules.forVariant(game.scoringVariant),
    );
    if (result == null) return;
    await ref.read(gameActionsProvider).endRound(
          gameId: game.id,
          round: round,
          finisherPlayerId: result.finisherPlayerId,
          opponentHandSums: result.opponentHandSums,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final movesAsync = ref.watch(roundMovesProvider(round.id));
    final moves = movesAsync.valueOrNull ?? const <Move>[];

    final lastDeltaByPlayer = <String, int>{};
    for (final m in moves) {
      lastDeltaByPlayer[m.playerId] = m.totalScore;
    }

    final active = game.activePlayer;
    final ordered = [...game.players]..sort((a, b) => a.seatIndex.compareTo(b.seatIndex));
    final others = ordered.where((p) => p.playerId != active?.playerId).toList();

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.x16,
              AppSpacing.x16,
              AppSpacing.x16,
              AppSpacing.x8,
            ),
            children: [
              if (active != null)
                PlayerScoreCard(
                  player: active,
                  isActive: true,
                  turnLabel: l10n.gameTurnIndicator,
                  lastDelta: lastDeltaByPlayer[active.playerId],
                ),
              AppSpacing.h12,
              for (final p in others) ...[
                PlayerScoreCard(
                  player: p,
                  isActive: false,
                  lastDelta: lastDeltaByPlayer[p.playerId],
                ),
                AppSpacing.h12,
              ],
              AppSpacing.h8,
              GlassContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.historyTitle, style: context.textStyles.titleSmall),
                        if (moves.isNotEmpty)
                          TextButton.icon(
                            icon: const Icon(Icons.undo_rounded, size: 18),
                            label: Text(l10n.commonBack),
                            onPressed: () => ref.read(gameActionsProvider).undoLastMove(
                                  gameId: game.id,
                                  round: round,
                                ),
                          ),
                      ],
                    ),
                    RoundHistoryList(
                      moves: moves,
                      players: game.players,
                      onEditMove: (m) => _editMove(context, ref, m),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _ActionBar(
          onAddMove: () => _addMove(context, ref, moves),
          onPass: () => _penalty(ref, MoveInput.pass()),
          onDraw: () => _penalty(ref, MoveInput.draw()),
          onEndHand: () => _endRound(context, ref),
        ),
      ],
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.onAddMove,
    required this.onPass,
    required this.onDraw,
    required this.onEndHand,
  });

  final VoidCallback onAddMove;
  final VoidCallback onPass;
  final VoidCallback onDraw;
  final VoidCallback onEndHand;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.x16,
          AppSpacing.x8,
          AppSpacing.x16,
          AppSpacing.x12,
        ),
        child: Column(
          children: [
            PrimaryButton(
              label: l10n.gameAddMove,
              icon: Icons.add_rounded,
              onPressed: onAddMove,
            ),
            AppSpacing.h8,
            Row(
              children: [
                Expanded(
                  child: _SecondaryAction(
                    icon: Icons.skip_next_rounded,
                    label: l10n.gameActionPass,
                    onTap: onPass,
                  ),
                ),
                AppSpacing.w8,
                Expanded(
                  child: _SecondaryAction(
                    icon: Icons.download_rounded,
                    label: l10n.gameActionDraw,
                    onTap: onDraw,
                  ),
                ),
                AppSpacing.w8,
                Expanded(
                  child: _SecondaryAction(
                    icon: Icons.flag_rounded,
                    label: l10n.gameActionEndOfHand,
                    onTap: onEndHand,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SecondaryAction extends StatelessWidget {
  const _SecondaryAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    return Material(
      color: scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x12),
          child: Column(
            children: [
              Icon(icon, size: 22, color: scheme.onSurfaceVariant),
              AppSpacing.h4,
              Text(label, style: context.textStyles.labelSmall),
            ],
          ),
        ),
      ),
    );
  }
}
