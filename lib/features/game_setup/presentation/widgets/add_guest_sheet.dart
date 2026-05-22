import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/color_hex.dart';
import '../../../../shared/extensions/build_context.dart';
import '../../../../shared/widgets/player_avatar.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../players/domain/player.dart';
import '../../../players/presentation/widgets/avatar_color_picker.dart';
import '../game_setup_controller.dart';

Future<SetupPlayer?> showAddGuestSheet(BuildContext context) {
  return showModalBottomSheet<SetupPlayer>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _AddGuestSheet(),
  );
}

class _AddGuestSheet extends ConsumerStatefulWidget {
  const _AddGuestSheet();

  @override
  ConsumerState<_AddGuestSheet> createState() => _AddGuestSheetState();
}

class _AddGuestSheetState extends ConsumerState<_AddGuestSheet> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Color _color = AppColors.avatarPalette[2];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final name = _nameController.text.trim();
    final colorHex = hexFromColor(_color);
    Navigator.pop(
      context,
      SetupPlayer.guest(
        name: name,
        initials: PlayerValidator.initialsFromName(name),
        avatarColor: colorHex,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.x20,
        AppSpacing.x24,
        AppSpacing.x20,
        AppSpacing.x24 + bottomInset,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.gameSetupAddGuest, style: context.textStyles.headlineSmall),
            AppSpacing.h20,
            Center(
              child: PlayerAvatar(
                initials: _nameController.text.isEmpty
                    ? '?'
                    : PlayerValidator.initialsFromName(_nameController.text),
                color: _color,
                size: 72,
              ),
            ),
            AppSpacing.h20,
            TextFormField(
              controller: _nameController,
              autofocus: true,
              maxLength: AppConstants.playerNameMaxLength,
              decoration: InputDecoration(labelText: l10n.gameSetupGuestNameLabel),
              onChanged: (_) => setState(() {}),
              validator: (value) {
                final error = PlayerValidator.validateName(value);
                if (error == 'required') return l10n.playersErrorNameRequired;
                if (error == 'tooLong') return l10n.playersErrorNameTooLong;
                return null;
              },
              onFieldSubmitted: (_) => _submit(),
            ),
            AppSpacing.h12,
            AvatarColorPicker(
              selected: _color,
              onChanged: (c) => setState(() => _color = c),
            ),
            AppSpacing.h24,
            PrimaryButton(label: l10n.commonAdd, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
