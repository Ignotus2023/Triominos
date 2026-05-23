import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/extensions/build_context.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/player_avatar.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../game/game_providers.dart';

class GameSummaryPage extends ConsumerWidget {
  const GameSummaryPage({required this.gameId, super.key});

  final String gameId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final game = ref.watch(gameProvider(gameId)).value;
    final seats = [...?ref.watch(gamePlayersProvider(gameId)).value]
      ..sort((a, b) => b.totalScore.compareTo(a.totalScore));

    if (game == null || seats.isEmpty) {
      return const AppScaffold(body: Center(child: CircularProgressIndicator()));
    }

    final winner = seats.first;

    return AppScaffold(
      automaticBack: false,
      bottomBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.goNamed(AppRoutes.home),
                  child: Text(l10n.summaryHome),
                ),
              ),
              const SizedBox(width: AppSpacing.x12),
              Expanded(
                child: PrimaryButton(
                  label: l10n.summaryRematch,
                  onPressed: () =>
                      context.pushReplacementNamed(AppRoutes.gameSetup),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: AppSpacing.x32),
          Center(
            child: Column(
              children: [
                const Text('🏆', style: TextStyle(fontSize: 64))
                    .animate()
                    .scale(duration: 400.ms, curve: Curves.elasticOut),
                const SizedBox(height: AppSpacing.x16),
                Text(
                  l10n.summaryWinner(winner.displayNameSnapshot),
                  style: context.text.headlineLarge,
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: AppSpacing.x4),
                Text(
                  l10n.scoreUnit(winner.totalScore),
                  style: context.text.displayMedium
                      ?.copyWith(color: context.colors.primary),
                ).animate().fadeIn(delay: 300.ms),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x32),
          Text(l10n.summaryScoreboard, style: context.text.titleLarge),
          const SizedBox(height: AppSpacing.x12),
          for (var i = 0; i < seats.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x8),
              child: _ScoreboardRow(seat: seats[i], position: i),
            ),
          const SizedBox(height: AppSpacing.x16),
          GlassContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.summaryRoundsPlayed, style: context.text.bodyLarge),
                Text('${game.currentRound}', style: context.text.titleLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreboardRow extends StatelessWidget {
  const _ScoreboardRow({required this.seat, required this.position});

  final GamePlayer seat;
  final int position;

  @override
  Widget build(BuildContext context) {
    const medals = ['🥇', '🥈', '🥉'];
    final badge = position < medals.length ? medals[position] : '${position + 1}';

    return GlassContainer(
      glow: position == 0,
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(badge, style: context.text.titleLarge),
          ),
          const SizedBox(width: AppSpacing.x8),
          PlayerAvatar(
            initials: seat.displayNameSnapshot.isNotEmpty
                ? seat.displayNameSnapshot[0].toUpperCase()
                : '?',
            colorHex: '#6366F1',
          ),
          const SizedBox(width: AppSpacing.x16),
          Expanded(
            child: Text(seat.displayNameSnapshot, style: context.text.titleLarge),
          ),
          Text(
            context.l10n.scoreUnit(seat.totalScore),
            style: context.text.headlineSmall,
          ),
        ],
      ),
    );
  }
}
