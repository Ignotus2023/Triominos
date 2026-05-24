import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Buduje motywy light/dark aplikacji.
abstract class AppTheme {
  static ThemeData get light => _build(
        brightness: Brightness.light,
        scheme: const ColorScheme.light(
          primary: AppColors.lightPrimary,
          onPrimary: Colors.white,
          secondary: AppColors.lightSecondary,
          onSecondary: AppColors.lightText,
          surface: AppColors.lightSurface,
          onSurface: AppColors.lightText,
          error: AppColors.error,
        ),
        background: AppColors.lightBackground,
        textColor: AppColors.lightText,
        secondaryText: AppColors.lightTextSecondary,
        glass: GlassColors.light,
      );

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        scheme: const ColorScheme.dark(
          primary: AppColors.darkPrimary,
          onPrimary: AppColors.darkBackground,
          secondary: AppColors.darkSecondary,
          onSecondary: AppColors.darkText,
          surface: AppColors.darkSurface,
          onSurface: AppColors.darkText,
          error: AppColors.error,
        ),
        background: AppColors.darkBackground,
        textColor: AppColors.darkText,
        secondaryText: AppColors.darkTextSecondary,
        glass: GlassColors.dark,
      );

  static ThemeData _build({
    required Brightness brightness,
    required ColorScheme scheme,
    required Color background,
    required Color textColor,
    required Color secondaryText,
    required GlassColors glass,
  }) {
    final textTheme = AppTypography.textTheme(textColor, secondaryText);
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      extensions: [glass],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: textColor,
        titleTextStyle: textTheme.titleLarge,
        centerTitle: false,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.primary,
        contentTextStyle: textTheme.bodyLarge?.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: secondaryText.withValues(alpha: 0.2),
        space: AppSpacing.x24,
      ),
    );
  }
}
