import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/monetization/purchase_provider.dart';
import '../../../core/routing/app_routes.dart';
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
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text(
                        l10n.settingsThemeSystem,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text(
                        l10n.settingsThemeLight,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text(
                        l10n.settingsThemeDark,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
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
            padding: EdgeInsets.zero,
            glow: settings.isPremium,
            child: Column(
              children: [
                SwitchListTile(
                  secondary: Icon(
                    Icons.workspace_premium_outlined,
                    color: context.colors.primary,
                  ),
                  title: Text(l10n.settingsPremium),
                  subtitle: Text(l10n.settingsPremiumDesc),
                  value: settings.isPremium,
                  onChanged: notifier.setPremium,
                ),
                if (!kIsWeb && !settings.isPremium)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.x16,
                      0,
                      AppSpacing.x8,
                      AppSpacing.x8,
                    ),
                    child: Row(
                      children: [
                        FilledButton(
                          onPressed: () =>
                              ref.read(purchaseServiceProvider).buy(),
                          child: Text(l10n.premiumBuy),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () =>
                              ref.read(purchaseServiceProvider).restore(),
                          child: Text(l10n.premiumRestore),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x12),
          GlassContainer(
            padding: EdgeInsets.zero,
            child: ListTile(
              leading: Icon(Icons.tune, color: context.colors.primary),
              title: Text(l10n.settingsHouseRules),
              trailing: Icon(
                settings.isPremium ? Icons.chevron_right : Icons.lock_outline,
              ),
              onTap: () {
                if (settings.isPremium) {
                  context.pushNamed(AppRoutes.houseRules);
                } else {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(
                          '${l10n.settingsHouseRules} — ${l10n.settingsPremium}',
                        ),
                      ),
                    );
                }
              },
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
                Text(l10n.settingsVersion('2.0.0'), style: context.text.bodyMedium),
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
