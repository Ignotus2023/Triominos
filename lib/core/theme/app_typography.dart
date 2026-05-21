import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTypography {
  AppTypography._();

  static TextTheme buildTextTheme(Color textColor, Color textSecondary) {
    final base = GoogleFonts.interTextTheme();

    TextStyle s(double size, FontWeight weight, {Color? color, double? height, double? letter}) {
      return GoogleFonts.inter(
        fontSize: size,
        fontWeight: weight,
        color: color ?? textColor,
        height: height,
        letterSpacing: letter,
      );
    }

    return base.copyWith(
      displayLarge: s(56, FontWeight.w700, height: 1.05, letter: -1.5),
      displayMedium: s(40, FontWeight.w700, height: 1.1, letter: -1),
      displaySmall: s(32, FontWeight.w700, height: 1.15, letter: -0.5),
      headlineLarge: s(28, FontWeight.w600, height: 1.2),
      headlineMedium: s(24, FontWeight.w600, height: 1.25),
      headlineSmall: s(20, FontWeight.w600, height: 1.3),
      titleLarge: s(18, FontWeight.w600, height: 1.35),
      titleMedium: s(16, FontWeight.w600, height: 1.4),
      titleSmall: s(14, FontWeight.w600, height: 1.4),
      bodyLarge: s(16, FontWeight.w400, height: 1.5, color: textColor),
      bodyMedium: s(14, FontWeight.w400, height: 1.5, color: textSecondary),
      bodySmall: s(12, FontWeight.w400, height: 1.4, color: textSecondary),
      labelLarge: s(14, FontWeight.w600, letter: 0.2),
      labelMedium: s(12, FontWeight.w600, letter: 0.3),
      labelSmall: s(11, FontWeight.w500, letter: 0.4, color: textSecondary),
    );
  }

  static const TextStyle scoreTickerStyle = TextStyle(
    fontFeatures: [FontFeature.tabularFigures()],
  );
}
