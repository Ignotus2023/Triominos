import 'package:flutter/material.dart';

import '../game/scoring_rules.dart';

/// Niemutowalny stan preferencji użytkownika (trzymany w shared_preferences).
@immutable
class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.locale,
    this.soundsEnabled = true,
    this.hapticsEnabled = true,
    this.defaultScoreLimit = ScoringRules.defaultScoreLimit,
  });

  final ThemeMode themeMode;

  /// `null` oznacza język systemowy.
  final Locale? locale;
  final bool soundsEnabled;
  final bool hapticsEnabled;
  final int defaultScoreLimit;

  AppSettings copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool clearLocale = false,
    bool? soundsEnabled,
    bool? hapticsEnabled,
    int? defaultScoreLimit,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      locale: clearLocale ? null : (locale ?? this.locale),
      soundsEnabled: soundsEnabled ?? this.soundsEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      defaultScoreLimit: defaultScoreLimit ?? this.defaultScoreLimit,
    );
  }
}
