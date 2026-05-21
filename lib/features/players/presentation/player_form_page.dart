import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/haptics/haptics_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/extensions/build_context.dart';
import '../../../shared/widgets/player_avatar.dart';
import '../../../shared/widgets/primary_button.dart';
import '../domain/player.dart';
import 'players_providers.dart';
import 'widgets/avatar_color_picker.dart';

class PlayerFormPage extends ConsumerStatefulWidget {
  const PlayerFormPage({this.playerId, super.key});

  final String? playerId;

  @override
  ConsumerState<PlayerFormPage> createState() => _PlayerFormPageState();
}

class _PlayerFormPageState extends ConsumerState<PlayerFormPage> {
  final _nameController = TextEditingController();
  final _initialsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Color _selectedColor = AppColors.avatarPalette.first;
  bool _initialsTouched = false;
  bool _isGuest = false;
  bool _saving = false;
  Player? _editing;

  @override
  void initState() {
    super.initState();
    final id = widget.playerId;
    if (id != null) {
      Future.microtask(() async {
        final player = await ref.read(playerByIdProvider(id).future);
        if (player != null && mounted) {
          setState(() {
            _editing = player;
            _nameController.text = player.name;
            _initialsController.text = player.initials;
            _selectedColor = _parseColor(player.avatarColor);
            _isGuest = player.isGuest;
            _initialsTouched = true;
          });
        }
      });
    } else {
      _initialsController.text = '';
    }

    _nameController.addListener(_handleNameChange);
    _initialsController.addListener(() => _initialsTouched = true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _initialsController.dispose();
    super.dispose();
  }

  void _handleNameChange() {
    if (_initialsTouched) return;
    setState(() {
      _initialsController.text = PlayerValidator.initialsFromName(_nameController.text);
    });
  }

  Future<void> _save() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    setState(() => _saving = true);
    final repo = ref.read(playersRepositoryProvider);
    final haptics = ref.read(hapticsServiceProvider);

    final name = _nameController.text.trim();
    final initials = _initialsController.text.trim().isEmpty
        ? PlayerValidator.initialsFromName(name)
        : _initialsController.text.trim();
    final colorHex = '#${_selectedColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';

    final existing = _editing;
    if (existing == null) {
      final player = Player.draft(
        name: name,
        initials: initials,
        avatarColor: colorHex,
        isGuest: _isGuest,
      );
      await repo.create(player);
    } else {
      await repo.update(existing.copyWith(
        name: name,
        initials: initials,
        avatarColor: colorHex,
        isGuest: _isGuest,
      ));
    }
    await haptics.trigger(HapticPattern.medium);

    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isEditing = widget.playerId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? l10n.playersFormTitleEdit : l10n.playersFormTitleNew,
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x20,
              vertical: AppSpacing.x24,
            ),
            children: [
              Center(
                child: PlayerAvatar(
                  initials: _initialsController.text.isEmpty
                      ? '?'
                      : _initialsController.text,
                  color: _selectedColor,
                  size: 96,
                  isActive: true,
                ),
              ),
              AppSpacing.h32,
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.playersFormName,
                  helperText: l10n.playersFormNameHint,
                ),
                maxLength: AppConstants.playerNameMaxLength,
                autofocus: !isEditing,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  final error = PlayerValidator.validateName(value);
                  if (error == 'required') return l10n.playersErrorNameRequired;
                  if (error == 'tooLong') return l10n.playersErrorNameTooLong;
                  return null;
                },
              ),
              AppSpacing.h12,
              TextFormField(
                controller: _initialsController,
                decoration: InputDecoration(
                  labelText: l10n.playersFormInitials,
                ),
                textCapitalization: TextCapitalization.characters,
                maxLength: 3,
              ),
              AppSpacing.h24,
              Text(l10n.playersFormAvatarColor, style: context.textStyles.titleSmall),
              AppSpacing.h12,
              AvatarColorPicker(
                selected: _selectedColor,
                haptics: ref.read(hapticsServiceProvider),
                onChanged: (c) => setState(() => _selectedColor = c),
              ),
              AppSpacing.h24,
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.playersFormGuestToggle),
                value: _isGuest,
                onChanged: (v) => setState(() => _isGuest = v),
              ),
              AppSpacing.h32,
              PrimaryButton(
                label: l10n.commonSave,
                onPressed: _saving ? null : _save,
                loading: _saving,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color _parseColor(String hex) {
  final cleaned = hex.replaceFirst('#', '');
  final value = int.parse(cleaned, radix: 16);
  return Color(cleaned.length == 6 ? 0xFF000000 | value : value);
}
