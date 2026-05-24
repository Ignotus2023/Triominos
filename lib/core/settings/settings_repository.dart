import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    );
  }

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
