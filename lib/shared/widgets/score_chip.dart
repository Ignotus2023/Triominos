import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

enum ScoreChipVariant { positive, negative, neutral }

class ScoreChip extends StatelessWidget {
  const ScoreChip({
    required this.value,
    this.label,
    this.variant,
    this.compact = false,
    super.key,
  });

  final int value;
  final String? label;
  final ScoreChipVariant? variant;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final resolvedVariant = variant ??
        (value > 0
            ? ScoreChipVariant.positive
            : value < 0
                ? ScoreChipVariant.negative
                : ScoreChipVariant.neutral);

    final (background, foreground) = switch (resolvedVariant) {
      ScoreChipVariant.positive => (
          AppColors.success.withValues(alpha: 0.15),
          AppColors.success,
        ),
      ScoreChipVariant.negative => (
          AppColors.error.withValues(alpha: 0.15),
          AppColors.error,
        ),
      ScoreChipVariant.neutral => (
          scheme.surfaceContainerHighest,
          scheme.onSurfaceVariant,
        ),
    };

    final text = '${value >= 0 ? '+' : ''}$value';
    final padding = compact
        ? const EdgeInsets.symmetric(horizontal: AppSpacing.x8, vertical: AppSpacing.x4)
        : const EdgeInsets.symmetric(horizontal: AppSpacing.x12, vertical: AppSpacing.x8);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: (compact ? theme.textTheme.labelMedium : theme.textTheme.labelLarge)?.copyWith(
                color: foreground,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            if (label != null) ...[
              AppSpacing.w4,
              Text(
                label!,
                style: theme.textTheme.labelSmall?.copyWith(color: foreground),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
