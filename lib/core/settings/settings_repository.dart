import 'package:shared_preferences/shared_preferences.dart';

import '../game/scoring_rules.dart';
import 'app_settings.dart';

class SettingsRepository {
  SettingsRepository(this._prefs);

  static const _keyThemeMode = 'settings.themeMode';
  static const _keyLocale = 'settings.locale';
  static const _keySounds = 'settings.sounds';
  static const _keyHaptics = 'settings.haptics';
  static const _keyVariant = 'settings.scoringVariant';
  static const _keyScoreLimit = 'settings.scoreLimit';
  static const _keyOnboarding = 'settings.onboardingCompleted';

  final SharedPreferences _prefs;

  AppSettings load() {
    final defaults = AppSettings.defaults();
    return AppSettings(
      themeMode: _readThemeMode() ?? defaults.themeMode,
      localeCode: _prefs.getString(_keyLocale),
      soundsEnabled: _prefs.getBool(_keySounds) ?? defaults.soundsEnabled,
      hapticsEnabled: _prefs.getBool(_keyHaptics) ?? defaults.hapticsEnabled,
      defaultScoringVariant: _readVariant() ?? defaults.defaultScoringVariant,
      defaultScoreLimit: _prefs.getInt(_keyScoreLimit) ?? defaults.defaultScoreLimit,
      onboardingCompleted: _prefs.getBool(_keyOnboarding) ?? defaults.onboardingCompleted,
    );
  }

  Future<void> save(AppSettings s) async {
    await _prefs.setString(_keyThemeMode, s.themeMode.name);
    if (s.localeCode == null) {
      await _prefs.remove(_keyLocale);
    } else {
      await _prefs.setString(_keyLocale, s.localeCode!);
    }
    await _prefs.setBool(_keySounds, s.soundsEnabled);
    await _prefs.setBool(_keyHaptics, s.hapticsEnabled);
    await _prefs.setString(_keyVariant, s.defaultScoringVariant.name);
    await _prefs.setInt(_keyScoreLimit, s.defaultScoreLimit);
    await _prefs.setBool(_keyOnboarding, s.onboardingCompleted);
  }

  ThemeModeChoice? _readThemeMode() {
    final raw = _prefs.getString(_keyThemeMode);
    if (raw == null) return null;
    return ThemeModeChoice.values.where((v) => v.name == raw).firstOrNull;
  }

  ScoringVariant? _readVariant() {
    final raw = _prefs.getString(_keyVariant);
    if (raw == null) return null;
    return ScoringVariant.values.where((v) => v.name == raw).firstOrNull;
  }
}
