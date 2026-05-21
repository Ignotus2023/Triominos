import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.expand = true,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          color: scheme.onPrimary,
        );

    Widget child = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading)
          SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(scheme.onPrimary),
            ),
          )
        else if (icon != null) ...[
          Icon(icon, size: 20, color: scheme.onPrimary),
          AppSpacing.w8,
        ],
        if (!loading) Text(label, style: textStyle),
      ],
    );

    final disabled = onPressed == null || loading;

    return SizedBox(
      height: 56,
      width: expand ? double.infinity : null,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            gradient: disabled ? null : AppColors.primaryGradient,
            color: disabled ? scheme.outlineVariant : null,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            boxShadow: disabled
                ? null
                : [
                    BoxShadow(
                      color: AppColors.indigo500.withValues(alpha: 0.4),
                      blurRadius: 24,
                      spreadRadius: -4,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: InkWell(
            onTap: disabled ? null : onPressed,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x24),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
