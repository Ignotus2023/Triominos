import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/haptics/haptics_service.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/color_hex.dart';
import '../../../shared/extensions/build_context.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/player_avatar.dart';
import '../../../shared/widgets/primary_button.dart';
import '../domain/player.dart';
import 'players_providers.dart';

class PlayersListPage extends ConsumerWidget {
  const PlayersListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final playersAsync = ref.watch(savedPlayersStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.playersTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: l10n.playersAdd,
            onPressed: () => context.pushNamed(AppRoute.playerForm),
          ),
        ],
      ),
      body: playersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('${l10n.errorGeneric}\n$e')),
        data: (players) {
          if (players.isEmpty) return const _EmptyState();
          return ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x20,
              vertical: AppSpacing.x16,
            ),
            itemCount: players.length,
            separatorBuilder: (_, __) => AppSpacing.h12,
            itemBuilder: (_, i) => _PlayerTile(player: players[i]),
          );
        },
      ),
      floatingActionButton: playersAsync.maybeWhen(
        data: (players) => players.isEmpty
            ? null
            : FloatingActionButton.extended(
                onPressed: () => context.pushNamed(AppRoute.playerForm),
                icon: const Icon(Icons.add_rounded),
                label: Text(l10n.playersAdd),
              ),
        orElse: () => null,
      ),
    );
  }
}

class _EmptyState extends ConsumerWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.x24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.groups_outlined, size: 64, color: context.colors.primary),
          AppSpacing.h16,
          Text(l10n.playersEmptyTitle, style: context.textStyles.headlineSmall),
          AppSpacing.h8,
          Text(l10n.playersEmptyBody, style: context.textStyles.bodyMedium),
          AppSpacing.h24,
          PrimaryButton(
            label: l10n.playersAdd,
            icon: Icons.add_rounded,
            onPressed: () => context.pushNamed(AppRoute.playerForm),
          ),
        ],
      ),
    );
  }
}

class _PlayerTile extends ConsumerWidget {
  const _PlayerTile({required this.player});

  final Player player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return GlassContainer(
      padding: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x16,
          vertical: AppSpacing.x8,
        ),
        leading: PlayerAvatar(
          initials: player.initials,
          color: colorFromHex(player.avatarColor),
        ),
        title: Text(player.name, style: context.textStyles.titleMedium),
        trailing: PopupMenuButton<_TileAction>(
          icon: const Icon(Icons.more_horiz_rounded),
          onSelected: (action) async {
            switch (action) {
              case _TileAction.edit:
                await context.pushNamed(
                  AppRoute.playerForm,
                  queryParameters: {'id': player.id},
                );
              case _TileAction.delete:
                await _confirmDelete(context, ref);
            }
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              value: _TileAction.edit,
              child: Row(children: [
                const Icon(Icons.edit_outlined),
                AppSpacing.w12,
                Text(l10n.commonEdit),
              ]),
            ),
            PopupMenuItem(
              value: _TileAction.delete,
              child: Row(children: [
                const Icon(Icons.delete_outline_rounded, color: Colors.red),
                AppSpacing.w12,
                Text(l10n.commonDelete),
              ]),
            ),
          ],
        ),
        onTap: () => context.pushNamed(
          AppRoute.playerForm,
          queryParameters: {'id': player.id},
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.playersDeleteConfirmTitle),
        content: Text(l10n.playersDeleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await ref.read(playersRepositoryProvider).delete(player.id);
      await ref.read(hapticsServiceProvider).trigger(HapticPattern.medium);
    }
  }
}

enum _TileAction { edit, delete }
