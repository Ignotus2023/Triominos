import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/color_hex.dart';
import '../../../../shared/extensions/build_context.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../../../shared/widgets/player_avatar.dart';
import '../../../players/presentation/players_providers.dart';
import '../game_setup_controller.dart';
import 'add_guest_sheet.dart';

class PlayersStep extends ConsumerWidget {
  const PlayersStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(gameSetupControllerProvider);
    final controller = ref.read(gameSetupControllerProvider.notifier);
    final profilesAsync = ref.watch(savedPlayersStreamProvider);
    final selectedIds = state.players.map((p) => p.id).toSet();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.gameSetupSelectPlayers, style: context.textStyles.titleMedium),
            Text(
              '${state.players.length}/${AppConstants.maxPlayers}',
              style: context.textStyles.labelLarge?.copyWith(
                color: state.canStart ? context.colors.primary : context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        AppSpacing.h4,
        Text(l10n.gameSetupSelectPlayersHint, style: context.textStyles.bodyMedium),
        AppSpacing.h16,
        if (state.players.isEmpty)
          GlassContainer(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.x16),
              child: Center(
                child: Text(
                  l10n.gameSetupSelectPlayersHint,
                  style: context.textStyles.bodyMedium,
                ),
              ),
            ),
          )
        else
          ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            buildDefaultDragHandles: false,
            onReorder: controller.reorder,
            children: [
              for (var i = 0; i < state.players.length; i++)
                _SelectedPlayerTile(
                  key: ValueKey(state.players[i].id),
                  index: i,
                  player: state.players[i],
                  onRemove: () => controller.togglePlayer(state.players[i]),
                ),
            ],
          ),
        AppSpacing.h24,
        Text(l10n.playersTitle, style: context.textStyles.titleSmall),
        AppSpacing.h12,
        profilesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('${l10n.errorGeneric}\n$e'),
          data: (profiles) {
            final available = profiles.where((p) => !selectedIds.contains(p.id)).toList();
            return Wrap(
              spacing: AppSpacing.x8,
              runSpacing: AppSpacing.x8,
              children: [
                for (final p in available)
                  ActionChip(
                    avatar: PlayerAvatar(
                      initials: p.initials,
                      color: colorFromHex(p.avatarColor),
                      size: 28,
                    ),
                    label: Text(p.name),
                    onPressed: state.players.length >= AppConstants.maxPlayers
                        ? null
                        : () => controller.togglePlayer(SetupPlayer.fromProfile(p)),
                  ),
                ActionChip(
                  avatar: const Icon(Icons.person_add_alt_1_rounded, size: 20),
                  label: Text(l10n.gameSetupAddGuest),
                  onPressed: state.players.length >= AppConstants.maxPlayers
                      ? null
                      : () async {
                          final guest = await showAddGuestSheet(context);
                          if (guest != null) controller.addGuest(guest);
                        },
                ),
              ],
            );
          },
        ),
        AppSpacing.h24,
      ],
    );
  }
}

class _SelectedPlayerTile extends StatelessWidget {
  const _SelectedPlayerTile({
    required this.index,
    required this.player,
    required this.onRemove,
    super.key,
  });

  final int index;
  final SetupPlayer player;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      key: ValueKey('pad_${player.id}'),
      padding: const EdgeInsets.only(bottom: AppSpacing.x8),
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x12,
          vertical: AppSpacing.x8,
        ),
        child: Row(
          children: [
            ReorderableDragStartListener(
              index: index,
              child: const Padding(
                padding: EdgeInsets.only(right: AppSpacing.x8),
                child: Icon(Icons.drag_indicator_rounded),
              ),
            ),
            PlayerAvatar(
              initials: player.initials,
              color: colorFromHex(player.avatarColor),
              size: 36,
            ),
            AppSpacing.w12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(player.name, style: context.textStyles.titleSmall),
                  Text(
                    '#${index + 1}',
                    style: context.textStyles.labelSmall,
                  ),
                ],
              ),
            ),
            if (player.isGuest)
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.x4),
                child: Chip(
                  label: Text(l10n.gameSetupAddGuest),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}
