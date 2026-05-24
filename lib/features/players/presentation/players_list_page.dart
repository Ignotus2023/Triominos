import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants.dart';
import '../../../core/database/app_database.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/extensions/build_context.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/player_avatar.dart';
import '../players_providers.dart';

class PlayersListPage extends ConsumerWidget {
  const PlayersListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final players = ref.watch(playersStreamProvider);

    return AppScaffold(
      title: l10n.playersTitle,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showPlayerSheet(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l10n.playersAdd),
      ),
      body: players.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) {
          if (list.isEmpty) {
            return EmptyState(
              icon: Icons.group_outlined,
              message: l10n.playersEmpty,
            );
          }
          return ListView.separated(
            itemCount: list.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.x12),
            itemBuilder: (context, i) {
              final p = list[i];
              return GlassContainer(
                onTap: () => _showPlayerSheet(context, ref, player: p),
                child: Row(
                  children: [
                    PlayerAvatar(initials: p.initials, colorHex: p.avatarColor),
                    const SizedBox(width: AppSpacing.x16),
                    Expanded(
                      child: Text(p.name, style: context.text.titleLarge),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: context.colors.error),
                      onPressed: () => _confirmDelete(context, ref, p),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Player player,
  ) async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.playerDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (ok ?? false) {
      await ref.read(playersServiceProvider).delete(player.id);
    }
  }

  Future<void> _showPlayerSheet(
    BuildContext context,
    WidgetRef ref, {
    Player? player,
  }) async {
    final l10n = context.l10n;
    final controller = TextEditingController(text: player?.name ?? '');
    final formKey = GlobalKey<FormState>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
          left: AppSpacing.x16,
          right: AppSpacing.x16,
          top: AppSpacing.x16,
        ),
        child: GlassContainer(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player == null ? l10n.playerNew : l10n.playerEdit,
                  style: context.text.titleLarge,
                ),
                const SizedBox(height: AppSpacing.x16),
                TextFormField(
                  controller: controller,
                  autofocus: true,
                  maxLength: AppConstants.maxPlayerNameLength,
                  decoration: InputDecoration(
                    labelText: l10n.playerName,
                    hintText: l10n.playerNameHint,
                  ),
                  validator: (value) {
                    final v = value?.trim() ?? '';
                    if (v.isEmpty) return l10n.playerErrorNameEmpty;
                    if (v.length > AppConstants.maxPlayerNameLength) {
                      return l10n.playerErrorNameTooLong;
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) =>
                      _submit(context, ref, formKey, controller, player),
                ),
                const SizedBox(height: AppSpacing.x12),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    onPressed: () =>
                        _submit(context, ref, formKey, controller, player),
                    child: Text(l10n.commonSave),
                  ),
                ),
                const SizedBox(height: AppSpacing.x8),
              ],
            ),
          ),
        ),
      ),
    );
    controller.dispose();
  }

  Future<void> _submit(
    BuildContext context,
    WidgetRef ref,
    GlobalKey<FormState> formKey,
    TextEditingController controller,
    Player? player,
  ) async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    final service = ref.read(playersServiceProvider);
    if (player == null) {
      await service.create(controller.text);
    } else {
      await service.rename(player, controller.text);
    }
    if (context.mounted) Navigator.pop(context);
  }
}
