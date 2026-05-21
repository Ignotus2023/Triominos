import 'package:flutter/material.dart';

import '../game/scoring_rules.dart';

enum ThemeModeChoice { system, light, dark;

  ThemeMode toMaterial() {
    switch (this) {
      case ThemeModeChoice.system:
        return ThemeMode.system;
      case ThemeModeChoice.light:
        return ThemeMode.light;
      case ThemeModeChoice.dark:
        return ThemeMode.dark;
    }
  }
}

class AppSettings {
  const AppSettings({
    required this.themeMode,
    required this.localeCode,
    required this.soundsEnabled,
    required this.hapticsEnabled,
    required this.defaultScoringVariant,
    required this.defaultScoreLimit,
    required this.onboardingCompleted,
  });

  factory AppSettings.defaults() => const AppSettings(
        themeMode: ThemeModeChoice.system,
        localeCode: null,
        soundsEnabled: true,
        hapticsEnabled: true,
        defaultScoringVariant: ScoringVariant.goliath,
        defaultScoreLimit: 400,
        onboardingCompleted: false,
      );

  final ThemeModeChoice themeMode;
  final String? localeCode;
  final bool soundsEnabled;
  final bool hapticsEnabled;
  final ScoringVariant defaultScoringVariant;
  final int defaultScoreLimit;
  final bool onboardingCompleted;

  AppSettings copyWith({
    ThemeModeChoice? themeMode,
    String? localeCode,
    bool clearLocale = false,
    bool? soundsEnabled,
    bool? hapticsEnabled,
    ScoringVariant? defaultScoringVariant,
    int? defaultScoreLimit,
    bool? onboardingCompleted,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      localeCode: clearLocale ? null : (localeCode ?? this.localeCode),
      soundsEnabled: soundsEnabled ?? this.soundsEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      defaultScoringVariant: defaultScoringVariant ?? this.defaultScoringVariant,
      defaultScoreLimit: defaultScoreLimit ?? this.defaultScoreLimit,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }
}
