import 'dart:typed_data';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/audio/audio_service.dart';
import '../../../core/database/app_database.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/extensions/build_context.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/player_avatar.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../game/game_providers.dart';
import '../../game_setup/game_setup_controller.dart';
import '../../players/players_providers.dart';

class GameSummaryPage extends ConsumerStatefulWidget {
  const GameSummaryPage({required this.gameId, super.key});

  final String gameId;

  @override
  ConsumerState<GameSummaryPage> createState() => _GameSummaryPageState();
}

class _GameSummaryPageState extends ConsumerState<GameSummaryPage> {
  late final ConfettiController _confetti;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 3))..play();
    ref.read(audioServiceProvider).play(AppSound.win);
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = ref.watch(gameProvider(widget.gameId)).value;
    final colors = ref.watch(playerColorsProvider);
    final images = ref.watch(playerImagesProvider);
    final seats = [...?ref.watch(gamePlayersProvider(widget.gameId)).value]
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
                  onPressed: () => _rematch(context),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
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
                    TweenAnimationBuilder<int>(
                      tween: IntTween(begin: 0, end: winner.totalScore),
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, _) => Text(
                        l10n.scoreUnit(value),
                        style: context.text.displayMedium
                            ?.copyWith(color: context.colors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.x32),
              Text(l10n.summaryScoreboard, style: context.text.titleLarge),
              const SizedBox(height: AppSpacing.x12),
              for (var i = 0; i < seats.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.x8),
                  child: _ScoreboardRow(
                    seat: seats[i],
                    position: i,
                    colorHex: colors[seats[i].playerId] ??
                        avatarColorFor(seats[i].displayNameSnapshot),
                    image: images[seats[i].playerId],
                  ),
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
              const SizedBox(height: AppSpacing.x16),
              Center(
                child: OutlinedButton.icon(
                  onPressed: () => _share(context, seats),
                  icon: const Icon(Icons.share_outlined),
                  label: Text(l10n.summaryShare),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              maxBlastForce: 22,
              minBlastForce: 8,
              gravity: 0.25,
              colors: const [
                Color(0xFF6366F1),
                Color(0xFF8B5CF6),
                Color(0xFFEC4899),
                Color(0xFFF59E0B),
                Color(0xFF10B981),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _share(BuildContext context, List<GamePlayer> seats) async {
    final l10n = context.l10n;
    const medals = ['🥇', '🥈', '🥉'];
    final b = StringBuffer()..writeln('🏆 ${l10n.appTitle}');
    for (var i = 0; i < seats.length; i++) {
      final medal = i < medals.length ? medals[i] : '${i + 1}.';
      b.writeln(
        '$medal ${seats[i].displayNameSnapshot} — '
        '${l10n.scoreUnit(seats[i].totalScore)}',
      );
    }
    b.write('\nhttps://ignotus2023.github.io/Triominos/');
    await SharePlus.instance.share(
      ShareParams(text: b.toString(), subject: l10n.appTitle),
    );
  }

  Future<void> _rematch(BuildContext context) async {
    final players = ref.read(playersStreamProvider).value ?? [];
    final id = await ref
        .read(gameSetupControllerProvider)
        .rematchFrom(widget.gameId, players);
    if (!context.mounted) return;
    if (id != null) {
      context.pushReplacementNamed(AppRoutes.game, pathParameters: {'id': id});
    } else {
      context.pushReplacementNamed(AppRoutes.gameSetup);
    }
  }
}

class _ScoreboardRow extends StatelessWidget {
  const _ScoreboardRow({
    required this.seat,
    required this.position,
    required this.colorHex,
    this.image,
  });

  final GamePlayer seat;
  final int position;
  final String colorHex;
  final Uint8List? image;

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
            initials: initialsFor(seat.displayNameSnapshot),
            colorHex: colorHex,
            image: image,
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
