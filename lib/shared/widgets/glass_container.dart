import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Rdzeń systemu glassmorphism — rozmyte, półprzezroczyste tło z subtelną
/// ramką (§11.2). Używaj zamiast surowego [Container] dla powierzchni szkła.
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    required this.child,
    this.blur = 24,
    this.radius,
    this.padding = const EdgeInsets.all(AppSpacing.x16),
    this.margin,
    this.onTap,
    this.glow = false,
    this.width,
    this.height,
    super.key,
  });

  final Widget child;
  final double blur;
  final BorderRadius? radius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  /// Świecąca obwódka (np. dla aktywnego gracza).
  final bool glow;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final glass = Theme.of(context).extension<GlassColors>()!;
    final borderRadius = radius ?? BorderRadius.circular(AppRadii.lg);
    final scheme = Theme.of(context).colorScheme;

    Widget content = ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: glass.glass,
            borderRadius: borderRadius,
            border: Border.all(
              color: glow ? scheme.primary : glass.glassBorder,
              width: glow ? 1.5 : 1,
            ),
            boxShadow: glow
                ? [
                    BoxShadow(
                      color: scheme.primary.withValues(alpha: 0.35),
                      blurRadius: 24,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(onTap: onTap, child: content),
      );
    }

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: content,
    );
  }
}
