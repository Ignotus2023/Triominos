import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants.dart';
import '../../../core/database/app_database.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/extensions/build_context.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/player_avatar.dart';
import '../player_icons.dart';
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
        onPressed: () => _showPlayerDialog(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l10n.playersAdd),
      ),
      body: players.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(error: e),
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
                onTap: () => _showPlayerDialog(context, ref, player: p),
                child: Row(
                  children: [
                    PlayerAvatar(
                      initials: p.initials,
                      colorHex: p.avatarColor,
                      iconKey: p.avatarIcon,
                    ),
                    const SizedBox(width: AppSpacing.x16),
                    Expanded(
                      child: Text(p.name, style: context.text.titleLarge),
                    ),
                    IconButton(
                      tooltip: l10n.commonDelete,
                      icon: Icon(
                        Icons.delete_outline,
                        color: context.colors.error,
                      ),
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
    final messenger = ScaffoldMessenger.of(context);

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
    if (!(ok ?? false)) return;

    // Gracz z historią jest archiwizowany (soft-delete) w warstwie serwisu —
    // historia gier pozostaje nienaruszona; gracz bez historii usuwany twardo.
    try {
      await ref.read(playersServiceProvider).delete(player.id);
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.commonError)));
    }
  }

  Future<void> _showPlayerDialog(
    BuildContext context,
    WidgetRef ref, {
    Player? player,
  }) {
    final service = ref.read(playersServiceProvider);
    return showDialog<void>(
      context: context,
      builder: (context) => _PlayerFormDialog(
        player: player,
        onSubmit: (name, color, icon) async {
          if (player == null) {
            await service.create(name, color, icon: icon);
          } else {
            await service.update(player, name, color, icon: icon);
          }
        },
      ),
    );
  }
}

class _PlayerFormDialog extends StatefulWidget {
  const _PlayerFormDialog({required this.onSubmit, this.player});

  final Player? player;
  final Future<void> Function(String name, String color, String? icon) onSubmit;

  @override
  State<_PlayerFormDialog> createState() => _PlayerFormDialogState();
}

class _PlayerFormDialogState extends State<_PlayerFormDialog> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();
  late String _color;
  late String? _icon;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.player?.name ?? '');
    _color = widget.player?.avatarColor ?? avatarPalette.first;
    _icon = widget.player?.avatarIcon;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final messenger = ScaffoldMessenger.of(context);
    final errorText = context.l10n.commonError;
    try {
      await widget.onSubmit(_controller.text.trim(), _color, _icon);
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(errorText)));
      return;
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Dialog(
      alignment: Alignment.topCenter,
      insetPadding: const EdgeInsets.only(
        top: 72,
        left: AppSpacing.x24,
        right: AppSpacing.x24,
        bottom: AppSpacing.x24,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  PlayerAvatar(
                    initials: initialsFor(_controller.text),
                    colorHex: _color,
                    iconKey: _icon,
                    size: 48,
                  ),
                  const SizedBox(width: AppSpacing.x16),
                  Text(
                    widget.player == null ? l10n.playerNew : l10n.playerEdit,
                    style: context.text.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x16),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _controller,
                  autofocus: true,
                  maxLength: AppConstants.maxPlayerNameLength,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: l10n.playerName,
                    hintText: l10n.playerNameHint,
                  ),
                  onChanged: (_) => setState(() {}),
                  validator: (value) {
                    final v = value?.trim() ?? '';
                    if (v.isEmpty) return l10n.playerErrorNameEmpty;
                    if (v.length > AppConstants.maxPlayerNameLength) {
                      return l10n.playerErrorNameTooLong;
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _submit(),
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(l10n.playerColor, style: context.text.labelLarge),
              const SizedBox(height: AppSpacing.x12),
              Wrap(
                spacing: AppSpacing.x12,
                runSpacing: AppSpacing.x12,
                children: [
                  for (final hex in avatarPalette)
                    _ColorSwatch(
                      hex: hex,
                      selected: hex == _color,
                      onTap: () => setState(() => _color = hex),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.x16),
              Text(l10n.playerIcon, style: context.text.labelLarge),
              const SizedBox(height: AppSpacing.x12),
              Wrap(
                spacing: AppSpacing.x12,
                runSpacing: AppSpacing.x12,
                children: [
                  _IconChoice(
                    icon: Icons.text_fields,
                    selected: _icon == null,
                    onTap: () => setState(() => _icon = null),
                  ),
                  for (final entry in playerIconCatalog.entries)
                    _IconChoice(
                      icon: entry.value,
                      selected: _icon == entry.key,
                      onTap: () => setState(() => _icon = entry.key),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.x24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.commonCancel),
                  ),
                  const SizedBox(width: AppSpacing.x8),
                  FilledButton(
                    onPressed: _submit,
                    child: Text(l10n.commonSave),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.hex,
    required this.selected,
    required this.onTap,
  });

  final String hex;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _parseHex(hex);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? context.colors.onSurface : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 6),
          ],
        ),
        child: selected
            ? const Icon(Icons.check, color: Colors.white, size: 20)
            : null,
      ),
    );
  }

  static Color _parseHex(String hex) {
    final value = hex.replaceFirst('#', '');
    return Color(int.tryParse('FF$value', radix: 16) ?? 0xFF6366F1);
  }
}

class _IconChoice extends StatelessWidget {
  const _IconChoice({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: selected
              ? context.colors.primary.withValues(alpha: 0.15)
              : context.colors.onSurface.withValues(alpha: 0.05),
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? context.colors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          size: 22,
          color: selected
              ? context.colors.primary
              : context.colors.onSurfaceVariant,
        ),
      ),
    );
  }
}
