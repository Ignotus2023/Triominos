import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'glass_container.dart';

class SelectableCard extends StatelessWidget {
  const SelectableCard({
    required this.selected,
    required this.onTap,
    required this.child,
    this.padding,
    super.key,
  });

  final bool selected;
  final VoidCallback onTap;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: selected ? scheme.primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.indigo500.withValues(alpha: 0.25),
                    blurRadius: 16,
                    spreadRadius: -2,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: GlassContainer(
          padding: padding ?? AppSpacing.cardPadding,
          tintColor: selected ? scheme.primary.withValues(alpha: 0.10) : null,
          child: child,
        ),
      ),
    );
  }
}
