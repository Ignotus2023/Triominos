import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

class GlassContainer extends StatelessWidget {
  const GlassContainer({
    required this.child,
    this.blur = 24,
    this.borderRadius,
    this.padding,
    this.elevation = false,
    this.tintColor,
    this.borderColor,
    super.key,
  });

  final Widget child;
  final double blur;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool elevation;
  final Color? tintColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = borderRadius ?? BorderRadius.circular(AppSpacing.radiusLg);
    final fill = tintColor ?? (isDark ? AppColors.darkGlassFill : AppColors.lightGlassFill);
    final border = borderColor ?? (isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder);

    final content = DecoratedBox(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: radius,
        border: Border.all(color: border, width: 1),
      ),
      child: Padding(
        padding: padding ?? AppSpacing.cardPadding,
        child: child,
      ),
    );

    final clipped = ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: content,
      ),
    );

    if (!elevation) return clipped;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.darkShadow : AppColors.lightShadow,
            blurRadius: 24,
            spreadRadius: -4,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: clipped,
    );
  }
}
