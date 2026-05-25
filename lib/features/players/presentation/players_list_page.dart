import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants.dart';
import '../../../core/database/app_database.dart';
import '../../../core/settings/settings_provider.dart';
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
        onPressed: () => _showPlayerDialog(context, ref),
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
                onTap: () => _showPlayerDialog(context, ref, player: p),
                child: Row(
                  children: [
                    PlayerAvatar(
                      initials: p.initials,
                      colorHex: p.avatarColor,
                      image: p.avatarImage,
                    ),
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

  Future<void> _showPlayerDialog(
    BuildContext context,
    WidgetRef ref, {
    Player? player,
  }) {
    final service = ref.read(playersServiceProvider);
    final premium = ref.read(settingsProvider).isPremium;
    return showDialog<void>(
      context: context,
      builder: (context) => _PlayerFormDialog(
        player: player,
        premium: premium,
        onSubmit: (name, color, image) async {
          if (player == null) {
            await service.create(name, color, image: image);
          } else {
            await service.update(player, name, color, image: image);
          }
        },
      ),
    );
  }
}

class _PlayerFormDialog extends StatefulWidget {
  const _PlayerFormDialog({
    required this.onSubmit,
    required this.premium,
    this.player,
  });

  final Player? player;
  final bool premium;
  final Future<void> Function(String name, String color, Uint8List? image)
      onSubmit;

  @override
  State<_PlayerFormDialog> createState() => _PlayerFormDialogState();
}

class _PlayerFormDialogState extends State<_PlayerFormDialog> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();
  late String _color;
  Uint8List? _image;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.player?.name ?? '');
    _color = widget.player?.avatarColor ?? avatarPalette.first;
    _image = widget.player?.avatarImage;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (!widget.premium) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(context.l10n.premiumPhotoHint)));
      return;
    }
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 256,
      maxHeight: 256,
      imageQuality: 80,
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    if (mounted) setState(() => _image = bytes);
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await widget.onSubmit(_controller.text.trim(), _color, _image);
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
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        PlayerAvatar(
                          initials: initialsFor(_controller.text),
                          colorHex: _color,
                          image: _image,
                          size: 56,
                        ),
                        Positioned(
                          right: -2,
                          bottom: -2,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: context.colors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: context.colors.surface,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              widget.premium
                                  ? Icons.photo_camera
                                  : Icons.lock_outline,
                              size: 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.player == null
                              ? l10n.playerNew
                              : l10n.playerEdit,
                          style: context.text.titleLarge,
                        ),
                        if (_image != null)
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              foregroundColor: context.colors.error,
                            ),
                            onPressed: () => setState(() => _image = null),
                            icon: const Icon(Icons.delete_outline, size: 16),
                            label: Text('${l10n.commonDelete} ${l10n.playerPhoto}'),
                          ),
                      ],
                    ),
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
              const SizedBox(height: AppSpacing.x24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.commonCancel),
                  ),
                  const SizedBox(width: AppSpacing.x8),
                  FilledButton(onPressed: _submit, child: Text(l10n.commonSave)),
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
    return Color(int.parse('FF$value', radix: 16));
  }
}
