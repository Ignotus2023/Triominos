import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart';
import '../../../core/game/game_enums.dart';
import '../../../core/game/move.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/extensions/build_context.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../players/players_providers.dart';
import '../game_controller.dart';
import '../game_providers.dart';
import 'widgets/player_score_card.dart';
import 'widgets/round_history_list.dart';
import 'widgets/smart_input_sheet.dart';

class GamePage extends ConsumerWidget {
  const GamePage({required this.gameId, super.key});

  final String gameId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    ref.listen(gameProvider(gameId), (prev, next) {
      final game = next.value;
      if (game != null && game.status == GameStatus.finished) {
        context.pushReplacementNamed(
          AppRoutes.gameSummary,
          pathParameters: {'id': gameId},
        );
      }
    });

    final gameAsync = ref.watch(gameProvider(gameId));

    return gameAsync.when(
      loading: () =>
          const AppScaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => AppScaffold(body: Center(child: Text('$e'))),
      data: (game) {
        if (game == null) {
          return AppScaffold(
            title: l10n.appTitle,
            body: Center(child: Text(l10n.historyEmpty)),
          );
        }

        final seats = ref.watch(gamePlayersProvider(gameId)).value ?? [];
        final round = ref.watch(currentRoundProvider(gameId)).value;
        final moves = round == null
            ? const <MoveRow>[]
            : ref.watch(roundMovesProvider(round.id)).value ?? [];

        final colors = ref.watch(playerColorsProvider);
        final activeIndex = _activeIndex(seats, round, moves);
        final activeSeat = seats.isEmpty ? null : seats[activeIndex];
        final leader = seats.isEmpty
            ? null
            : seats.reduce((a, b) => b.totalScore > a.totalScore ? b : a);
        final thresholdReached = game.endMode == EndMode.scoreLimit &&
            game.scoreLimit != null &&
            leader != null &&
            leader.totalScore >= game.scoreLimit!;

        return AppScaffold(
          title: l10n.gameRound(game.currentRound),
          actions: [
            if (game.endMode == EndMode.freeform)
              TextButton(
                onPressed: () => _finishNow(context, ref, game),
                child: Text(l10n.gameFinish),
              ),
          ],
          bottomBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x16),
              child: PrimaryButton(
                label: l10n.gameAddMove,
                icon: Icons.add,
                onPressed: (activeSeat == null || round == null)
                    ? null
                    : () => _openSmartInput(
                          context,
                          ref,
                          game: game,
                          round: round,
                          seat: activeSeat,
                          moveNumber: moves.length + 1,
                          isStarterMove: game.currentRound == 1 && moves.isEmpty,
                          opponentsCount: seats.length - 1,
                        ),
              ),
            ),
          ),
          body: ListView(
            children: [
              if (thresholdReached)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.x16),
                  child: GlassContainer(
                    glow: true,
                    child: Row(
                      children: [
                        const Text('🏆', style: TextStyle(fontSize: 28)),
                        const SizedBox(width: AppSpacing.x12),
                        Expanded(
                          child: Text(
                            l10n.gameThresholdReached(leader.displayNameSnapshot),
                            style: context.text.titleLarge,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x8),
                        FilledButton(
                          onPressed: () => _finishNow(context, ref, game),
                          child: Text(l10n.gameFinish),
                        ),
                      ],
                    ),
                  ),
                ),
              for (var i = 0; i < seats.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.x12),
                  child: PlayerScoreCard(
                    seat: seats[i],
                    active: i == activeIndex,
                    colorHex: colors[seats[i].playerId] ??
                        avatarColorFor(seats[i].displayNameSnapshot),
                  ),
                ),
              const SizedBox(height: AppSpacing.x16),
              Text(l10n.gameRoundHistory, style: context.text.titleLarge),
              const SizedBox(height: AppSpacing.x12),
              if (round != null)
                RoundHistoryList(
                  moves: moves,
                  seats: seats,
                  onUndoLast: () => ref
                      .read(gameControllerProvider)
                      .undo(game: game, round: round),
                ),
              const SizedBox(height: AppSpacing.x48),
            ],
          ),
        );
      },
    );
  }

  int _activeIndex(List<GamePlayer> seats, Round? round, List<MoveRow> moves) {
    if (seats.isEmpty || round == null) return 0;
    final starter = seats.indexWhere((s) => s.playerId == round.starterPlayerId);
    final base = starter < 0 ? 0 : starter;
    final turns = moves
        .where((m) =>
            m.moveType == MoveType.play || m.moveType == MoveType.passPenalty)
        .length;
    return (base + turns) % seats.length;
  }

  Future<void> _openSmartInput(
    BuildContext context,
    WidgetRef ref, {
    required Game game,
    required Round round,
    required GamePlayer seat,
    required int moveNumber,
    required bool isStarterMove,
    required int opponentsCount,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SmartInputSheet(
        game: game,
        round: round,
        playerId: seat.playerId,
        playerName: seat.displayNameSnapshot,
        moveNumber: moveNumber,
        isStarterMove: isStarterMove,
        opponentsCount: opponentsCount,
      ),
    );
  }

  Future<void> _finishNow(BuildContext context, WidgetRef ref, Game game) async {
    await ref.read(gameControllerProvider).finishNow(game);
  }
}
