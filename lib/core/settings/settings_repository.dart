import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../game/scoring_config.dart';
import 'app_settings.dart';

/// Cienka warstwa nad [SharedPreferences] do trwałego zapisu preferencji UI.
class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _kThemeMode = 'themeMode';
  static const _kLocale = 'locale';
  static const _kSounds = 'soundsEnabled';
  static const _kHaptics = 'hapticsEnabled';
  static const _kScoreLimit = 'defaultScoreLimit';
  static const _kPremium = 'isPremium';
  static const _kScoringConfig = 'scoringConfig';
  static const _kOnboarding = 'onboardingCompleted';

  AppSettings load() {
    final localeCode = _prefs.getString(_kLocale);
    return AppSettings(
      themeMode: _themeFromString(_prefs.getString(_kThemeMode)),
      locale: localeCode == null ? null : Locale(localeCode),
      soundsEnabled: _prefs.getBool(_kSounds) ?? true,
      hapticsEnabled: _prefs.getBool(_kHaptics) ?? true,
      defaultScoreLimit:
          _prefs.getInt(_kScoreLimit) ?? const AppSettings().defaultScoreLimit,
      isPremium: _prefs.getBool(_kPremium) ?? false,
      scoringConfig: _loadScoringConfig(),
    );
  }

  ScoringConfig _loadScoringConfig() {
    final json = _prefs.getString(_kScoringConfig);
    if (json == null) return ScoringConfig.standard;
    try {
      return ScoringConfig.fromJson(json);
    } catch (_) {
      return ScoringConfig.standard;
    }
  }

  Future<void> saveScoringConfig(ScoringConfig config) =>
      _prefs.setString(_kScoringConfig, config.toJson());

  Future<void> savePremium(bool value) => _prefs.setBool(_kPremium, value);

  Future<void> saveThemeMode(ThemeMode mode) =>
      _prefs.setString(_kThemeMode, mode.name);

  Future<void> saveLocale(Locale? locale) => locale == null
      ? _prefs.remove(_kLocale)
      : _prefs.setString(_kLocale, locale.languageCode);

  Future<void> saveSounds(bool enabled) => _prefs.setBool(_kSounds, enabled);

  Future<void> saveHaptics(bool enabled) => _prefs.setBool(_kHaptics, enabled);

  Future<void> saveDefaultScoreLimit(int value) =>
      _prefs.setInt(_kScoreLimit, value);

  bool get onboardingCompleted => _prefs.getBool(_kOnboarding) ?? false;

  Future<void> setOnboardingCompleted() =>
      _prefs.setBool(_kOnboarding, true);

  ThemeMode _themeFromString(String? value) {
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
}
