import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/game/scoring_rules.dart';
import '../../../core/settings/app_settings.dart';
import '../../../core/settings/settings_provider.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/extensions/build_context.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.x20),
        children: [
          ListTile(
            title: Text(l10n.settingsTheme),
            subtitle: Text(_themeLabel(settings.themeMode, context)),
            trailing: SegmentedButton<ThemeModeChoice>(
              segments: [
                ButtonSegment(
                  value: ThemeModeChoice.system,
                  label: Text(l10n.settingsThemeSystem),
                ),
                ButtonSegment(
                  value: ThemeModeChoice.light,
                  label: Text(l10n.settingsThemeLight),
                ),
                ButtonSegment(
                  value: ThemeModeChoice.dark,
                  label: Text(l10n.settingsThemeDark),
                ),
              ],
              selected: {settings.themeMode},
              onSelectionChanged: (s) =>
                  controller.update((curr) => curr.copyWith(themeMode: s.first)),
            ),
          ),
          const Divider(),
          SwitchListTile(
            title: Text(l10n.settingsSounds),
            value: settings.soundsEnabled,
            onChanged: (v) => controller.update((c) => c.copyWith(soundsEnabled: v)),
          ),
          SwitchListTile(
            title: Text(l10n.settingsHaptics),
            value: settings.hapticsEnabled,
            onChanged: (v) => controller.update((c) => c.copyWith(hapticsEnabled: v)),
          ),
          const Divider(),
          ListTile(
            title: Text(l10n.settingsDefaultVariant),
            subtitle: Text(
              settings.defaultScoringVariant == ScoringVariant.goliath
                  ? l10n.gameSetupVariantGoliath
                  : l10n.gameSetupVariantPressman,
            ),
            trailing: DropdownButton<ScoringVariant>(
              value: settings.defaultScoringVariant,
              items: [
                DropdownMenuItem(
                  value: ScoringVariant.goliath,
                  child: Text(l10n.gameSetupVariantGoliath),
                ),
                DropdownMenuItem(
                  value: ScoringVariant.pressman,
                  child: Text(l10n.gameSetupVariantPressman),
                ),
              ],
              onChanged: (v) {
                if (v == null) return;
                controller.update((c) => c.copyWith(defaultScoringVariant: v));
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(l10n.settingsAbout),
            subtitle: Text(l10n.settingsAppVersion('1.0.0')),
          ),
        ],
      ),
    );
  }

  String _themeLabel(ThemeModeChoice mode, BuildContext context) {
    final l10n = context.l10n;
    switch (mode) {
      case ThemeModeChoice.system:
        return l10n.settingsThemeSystem;
      case ThemeModeChoice.light:
        return l10n.settingsThemeLight;
      case ThemeModeChoice.dark:
        return l10n.settingsThemeDark;
    }
  }
}
