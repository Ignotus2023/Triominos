import 'package:flutter/material.dart';

import '../game/scoring_config.dart';
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
    this.isPremium = false,
    this.scoringConfig = ScoringConfig.standard,
  });

  final ThemeMode themeMode;

  /// `null` oznacza język systemowy.
  final Locale? locale;
  final bool soundsEnabled;
  final bool hapticsEnabled;
  final int defaultScoreLimit;

  /// Wersja Premium — odblokowuje edycję dowolnego ruchu i usuwa reklamy.
  /// Docelowo ustawiana przez zakup w aplikacji.
  final bool isPremium;

  /// Konfigurowalne zasady punktacji (Premium „zasady domowe").
  final ScoringConfig scoringConfig;

  AppSettings copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool clearLocale = false,
    bool? soundsEnabled,
    bool? hapticsEnabled,
    int? defaultScoreLimit,
    bool? isPremium,
    ScoringConfig? scoringConfig,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      locale: clearLocale ? null : (locale ?? this.locale),
      soundsEnabled: soundsEnabled ?? this.soundsEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      defaultScoreLimit: defaultScoreLimit ?? this.defaultScoreLimit,
      isPremium: isPremium ?? this.isPremium,
      scoringConfig: scoringConfig ?? this.scoringConfig,
    );
  }
}
