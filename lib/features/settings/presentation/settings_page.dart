import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/settings/settings_provider.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/extensions/build_context.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/glass_container.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return AppScaffold(
      title: l10n.settingsTitle,
      body: ListView(
        children: [
          GlassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.settingsTheme, style: context.text.titleLarge),
                const SizedBox(height: AppSpacing.x12),
                SegmentedButton<ThemeMode>(
                  segments: [
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text(l10n.settingsThemeSystem),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text(l10n.settingsThemeLight),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text(l10n.settingsThemeDark),
                    ),
                  ],
                  selected: {settings.themeMode},
                  onSelectionChanged: (s) => notifier.setThemeMode(s.first),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x12),
          GlassContainer(
            child: Row(
              children: [
                Expanded(
                  child: Text(l10n.settingsLanguage, style: context.text.titleLarge),
                ),
                DropdownButton<String>(
                  value: settings.locale?.languageCode ?? 'system',
                  underline: const SizedBox.shrink(),
                  items: [
                    DropdownMenuItem(
                      value: 'system',
                      child: Text(l10n.settingsThemeSystem),
                    ),
                    DropdownMenuItem(value: 'pl', child: Text(l10n.languagePolish)),
                    DropdownMenuItem(value: 'en', child: Text(l10n.languageEnglish)),
                    DropdownMenuItem(value: 'de', child: Text(l10n.languageGerman)),
                    DropdownMenuItem(value: 'fr', child: Text(l10n.languageFrench)),
                    DropdownMenuItem(value: 'es', child: Text(l10n.languageSpanish)),
                    DropdownMenuItem(value: 'it', child: Text(l10n.languageItalian)),
                  ],
                  onChanged: (code) => notifier.setLocale(
                    code == null || code == 'system' ? null : Locale(code),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x12),
          GlassContainer(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(l10n.settingsSounds),
                  value: settings.soundsEnabled,
                  onChanged: notifier.setSounds,
                ),
                SwitchListTile(
                  title: Text(l10n.settingsHaptics),
                  value: settings.hapticsEnabled,
                  onChanged: notifier.setHaptics,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x12),
          GlassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.settingsDefaultScoreLimit,
                        style: context.text.titleLarge,
                      ),
                    ),
                    Text(
                      '${settings.defaultScoreLimit}',
                      style: context.text.titleLarge?.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: settings.defaultScoreLimit.toDouble(),
                  min: AppConstants.minScoreLimit.toDouble(),
                  max: AppConstants.maxScoreLimit.toDouble(),
                  divisions: (AppConstants.maxScoreLimit -
                          AppConstants.minScoreLimit) ~/
                      AppConstants.scoreLimitStep,
                  label: '${settings.defaultScoreLimit}',
                  onChanged: (v) => notifier.setDefaultScoreLimit(v.round()),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x12),
          GlassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.settingsAbout, style: context.text.titleLarge),
                const SizedBox(height: AppSpacing.x8),
                Text(l10n.settingsVersion('1.0.0'), style: context.text.bodyMedium),
                const SizedBox(height: AppSpacing.x16),
                TextButton.icon(
                  style: TextButton.styleFrom(foregroundColor: context.colors.error),
                  icon: const Icon(Icons.delete_forever_outlined),
                  label: Text(l10n.settingsResetData),
                  onPressed: () => _confirmReset(context, ref),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.settingsResetConfirm),
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
      await ref.read(databaseProvider).resetAllData();
    }
  }
}
