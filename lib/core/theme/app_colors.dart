import 'package:flutter/material.dart';

/// Paleta kolorów TriominoScore (Indigo / Royal Purple) — §11.1.
abstract class AppColors {
  // Light mode
  static const Color lightPrimary = Color(0xFF6366F1);
  static const Color lightPrimaryDark = Color(0xFF4338CA);
  static const Color lightSecondary = Color(0xFFA78BFA);
  static const Color lightBackground = Color(0xFFF5F3FF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightGlass = Color(0xA6FFFFFF); // white @ 0.65
  static const Color lightGlassBorder = Color(0x66FFFFFF); // white @ 0.40
  static const Color lightText = Color(0xFF1E1B4B);
  static const Color lightTextSecondary = Color(0xFF6B7280);

  // Dark mode
  static const Color darkPrimary = Color(0xFF818CF8);
  static const Color darkPrimaryDark = Color(0xFF6366F1);
  static const Color darkSecondary = Color(0xFFC4B5FD);
  static const Color darkBackground = Color(0xFF0F0A2E);
  static const Color darkSurface = Color(0xFF1E1B4B);
  static const Color darkGlass = Color(0x14FFFFFF); // white @ 0.08
  static const Color darkGlassBorder = Color(0x1FFFFFFF); // white @ 0.12
  static const Color darkText = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);

  // Wspólne semantyczne
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
}

/// Rozszerzenie motywu niosące kolory glassmorphism, których nie ma w
/// standardowym [ColorScheme].
@immutable
class GlassColors extends ThemeExtension<GlassColors> {
  const GlassColors({
    required this.glass,
    required this.glassBorder,
    required this.gradient,
  });

  final Color glass;
  final Color glassBorder;
  final LinearGradient gradient;

  static const light = GlassColors(
    glass: AppColors.lightGlass,
    glassBorder: AppColors.lightGlassBorder,
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.lightPrimary, AppColors.lightPrimaryDark],
    ),
  );

  static const dark = GlassColors(
    glass: AppColors.darkGlass,
    glassBorder: AppColors.darkGlassBorder,
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.darkPrimaryDark, AppColors.darkBackground],
    ),
  );

  @override
  GlassColors copyWith({
    Color? glass,
    Color? glassBorder,
    LinearGradient? gradient,
  }) {
    return GlassColors(
      glass: glass ?? this.glass,
      glassBorder: glassBorder ?? this.glassBorder,
      gradient: gradient ?? this.gradient,
    );
  }

  @override
  GlassColors lerp(GlassColors? other, double t) {
    if (other == null) return this;
    return GlassColors(
      glass: Color.lerp(glass, other.glass, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      gradient: LinearGradient.lerp(gradient, other.gradient, t)!,
    );
  }
}
