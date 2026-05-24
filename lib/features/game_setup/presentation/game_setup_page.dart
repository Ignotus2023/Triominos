import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/database/app_database.dart';
import '../../../core/game/game_enums.dart';
import '../../../core/game/scoring_rules.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/settings/settings_provider.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/extensions/build_context.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/player_avatar.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../players/players_providers.dart';
import '../game_setup_controller.dart';

class GameSetupPage extends ConsumerStatefulWidget {
  const GameSetupPage({super.key});

  @override
  ConsumerState<GameSetupPage> createState() => _GameSetupPageState();
}

class _GameSetupPageState extends ConsumerState<GameSetupPage> {
  final _selected = <String>[];
  EndMode _endMode = EndMode.scoreLimit;
  late int _scoreLimit;
  int _rounds = ScoringRules.defaultRounds;
  bool _creating = false;

  @override
  void initState() {
    super.initState();
    _scoreLimit = ref.read(settingsProvider).defaultScoreLimit;
  }

  bool get _canStart =>
      _selected.length >= AppConstants.minPlayers &&
      _selected.length <= AppConstants.maxPlayers;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final players = ref.watch(playersStreamProvider);

    return AppScaffold(
      title: l10n.setupTitle,
      bottomBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x16),
          child: PrimaryButton(
            label: l10n.setupStartGame,
            icon: Icons.play_arrow_rounded,
            onPressed: _canStart && !_creating ? _start : null,
          ),
        ),
      ),
      body: players.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) {
          if (list.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                EmptyState(
                  icon: Icons.group_add_outlined,
                  message: l10n.playersEmpty,
                ),
                TextButton.icon(
                  onPressed: () => context.pushNamed(AppRoutes.players),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.playersAdd),
                ),
              ],
            );
          }
          final byId = {for (final p in list) p.id: p};
          return ListView(
            children: [
              Text(
                l10n.setupSelectPlayers,
                style: context.text.titleLarge,
              ),
              Text(
                l10n.setupPlayersRange(
                  AppConstants.minPlayers,
                  AppConstants.maxPlayers,
                ),
                style: context.text.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.x12),
              ...list.map((p) {
                final selected = _selected.contains(p.id);
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.x8),
                  child: GlassContainer(
                    glow: selected,
                    onTap: () => _toggle(p.id),
                    child: Row(
                      children: [
                        PlayerAvatar(
                          initials: p.initials,
                          colorHex: p.avatarColor,
                          active: selected,
                        ),
                        const SizedBox(width: AppSpacing.x16),
                        Expanded(
                          child: Text(p.name, style: context.text.titleLarge),
                        ),
                        Icon(
                          selected ? Icons.check_circle : Icons.circle_outlined,
                          color: selected
                              ? context.colors.primary
                              : context.colors.onSurface.withValues(alpha: 0.3),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              if (_selected.length >= 2) ...[
                const SizedBox(height: AppSpacing.x24),
                Text(l10n.setupOrder, style: context.text.titleLarge),
                const SizedBox(height: AppSpacing.x12),
                ReorderableListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  buildDefaultDragHandles: false,
                  onReorderItem: _onReorder,
                  children: [
                    for (var i = 0; i < _selected.length; i++)
                      _orderTile(context, i, byId[_selected[i]]),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.x24),
              Text(l10n.setupEndMode, style: context.text.titleLarge),
              const SizedBox(height: AppSpacing.x12),
              _EndModeSelector(
                value: _endMode,
                onChanged: (m) => setState(() => _endMode = m),
              ),
              const SizedBox(height: AppSpacing.x16),
              if (_endMode == EndMode.scoreLimit)
                _ThresholdSlider(
                  label: l10n.setupScoreLimit,
                  value: _scoreLimit,
                  min: AppConstants.minScoreLimit,
                  max: AppConstants.maxScoreLimit,
                  step: AppConstants.scoreLimitStep,
                  onChanged: (v) => setState(() => _scoreLimit = v),
                ),
              if (_endMode == EndMode.rounds)
                _ThresholdSlider(
                  label: l10n.setupRounds,
                  value: _rounds,
                  min: AppConstants.minRounds,
                  max: AppConstants.maxRounds,
                  step: 1,
                  onChanged: (v) => setState(() => _rounds = v),
                ),
              const SizedBox(height: AppSpacing.x64),
            ],
          );
        },
      ),
    );
  }

  void _toggle(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else if (_selected.length < AppConstants.maxPlayers) {
        _selected.add(id);
      }
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      final id = _selected.removeAt(oldIndex);
      _selected.insert(newIndex, id);
    });
  }

  Widget _orderTile(BuildContext context, int index, Player? player) {
    final initials = player == null ? '?' : initialsFor(player.name);
    return Padding(
      key: ValueKey(player?.id ?? 'seat_$index'),
      padding: const EdgeInsets.only(bottom: AppSpacing.x8),
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x16,
          vertical: AppSpacing.x12,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: context.colors.primary,
              child: Text(
                '${index + 1}',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
            const SizedBox(width: AppSpacing.x12),
            PlayerAvatar(
              initials: initials,
              colorHex: player?.avatarColor ?? '#6366F1',
              size: 36,
            ),
            const SizedBox(width: AppSpacing.x12),
            Expanded(
              child: Text(player?.name ?? '?', style: context.text.titleLarge),
            ),
            ReorderableDragStartListener(
              index: index,
              child: Icon(
                Icons.drag_handle,
                color: context.colors.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _start() async {
    setState(() => _creating = true);
    final all = ref.read(playersStreamProvider).value ?? [];
    final selectedPlayers = _selected
        .map((id) => all.firstWhere((p) => p.id == id))
        .toList();

    final gameId = await ref.read(gameSetupControllerProvider).createGame(
          players: selectedPlayers,
          endMode: _endMode,
          scoreLimit: _scoreLimit,
          totalRounds: _rounds,
        );
    if (mounted) {
      context.pushReplacementNamed(AppRoutes.game, pathParameters: {'id': gameId});
    }
  }
}

class _EndModeSelector extends StatelessWidget {
  const _EndModeSelector({required this.value, required this.onChanged});

  final EndMode value;
  final ValueChanged<EndMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final entries = <(EndMode, String, String)>[
      (EndMode.scoreLimit, l10n.setupEndModeScoreLimit, l10n.setupEndModeScoreLimitDesc),
      (EndMode.rounds, l10n.setupEndModeRounds, l10n.setupEndModeRoundsDesc),
      (EndMode.freeform, l10n.setupEndModeFreeform, l10n.setupEndModeFreeformDesc),
    ];
    return Column(
      children: [
        for (final e in entries)
          GlassContainer(
            margin: const EdgeInsets.only(bottom: AppSpacing.x8),
            glow: value == e.$1,
            onTap: () => onChanged(e.$1),
            child: Row(
              children: [
                Icon(
                  value == e.$1
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: context.colors.primary,
                ),
                const SizedBox(width: AppSpacing.x12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.$2, style: context.text.titleLarge),
                      Text(e.$3, style: context.text.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ThresholdSlider extends StatelessWidget {
  const _ThresholdSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.step,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final int step;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: context.text.titleLarge)),
              Text(
                '$value',
                style: context.text.titleLarge?.copyWith(color: context.colors.primary),
              ),
            ],
          ),
          Slider(
            value: value.toDouble(),
            min: min.toDouble(),
            max: max.toDouble(),
            divisions: (max - min) ~/ step,
            label: '$value',
            onChanged: (v) => onChanged(v.round()),
          ),
        ],
      ),
    );
  }
}
