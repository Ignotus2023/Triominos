import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_settings.dart';
import 'settings_repository.dart';

/// Nadpisywane w `main()` po inicjalizacji [SharedPreferences].
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPreferencesProvider must be overridden'),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(sharedPreferencesProvider)),
);

class SettingsNotifier extends Notifier<AppSettings> {
  SettingsRepository get _repo => ref.read(settingsRepositoryProvider);

  @override
  AppSettings build() => _repo.load();

  Future<void> setThemeMode(ThemeMode mode) async {
    await _repo.saveThemeMode(mode);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setLocale(Locale? locale) async {
    await _repo.saveLocale(locale);
    state = locale == null
        ? state.copyWith(clearLocale: true)
        : state.copyWith(locale: locale);
  }

  Future<void> setSounds(bool enabled) async {
    await _repo.saveSounds(enabled);
    state = state.copyWith(soundsEnabled: enabled);
  }

  Future<void> setHaptics(bool enabled) async {
    await _repo.saveHaptics(enabled);
    state = state.copyWith(hapticsEnabled: enabled);
  }

  Future<void> setDefaultScoreLimit(int value) async {
    await _repo.saveDefaultScoreLimit(value);
    state = state.copyWith(defaultScoreLimit: value);
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);
