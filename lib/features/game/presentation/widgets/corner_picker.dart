import 'package:flutter/material.dart';

import '../../../../core/constants.dart';
import '../../../../core/haptics/haptics_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/extensions/build_context.dart';

class CornerPicker extends StatelessWidget {
  const CornerPicker({
    required this.value,
    required this.onChanged,
    this.haptics,
    super.key,
  });

  final int? value;
  final ValueChanged<int> onChanged;
  final HapticsService? haptics;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final hasValue = value != null;

    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(scheme.surface),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
        ),
        padding: const WidgetStatePropertyAll(EdgeInsets.all(AppSpacing.x8)),
      ),
      builder: (context, controller, _) {
        return GestureDetector(
          onTap: () {
            haptics?.trigger(HapticPattern.selection);
            controller.isOpen ? controller.close() : controller.open();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: hasValue ? AppColors.primaryGradient : null,
              color: hasValue ? null : scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(
                color: hasValue ? Colors.transparent : scheme.outline,
                width: 1.5,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              hasValue ? '$value' : '–',
              style: context.textStyles.displaySmall?.copyWith(
                color: hasValue ? Colors.white : scheme.onSurfaceVariant,
              ),
            ),
          ),
        );
      },
      menuChildren: [
        SizedBox(
          width: 168,
          child: Wrap(
            spacing: AppSpacing.x8,
            runSpacing: AppSpacing.x8,
            children: [
              for (var n = AppConstants.cornerMin; n <= AppConstants.cornerMax; n++)
                _ValueCell(
                  value: n,
                  selected: n == value,
                  onTap: () {
                    haptics?.trigger(HapticPattern.selection);
                    onChanged(n);
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ValueCell extends StatelessWidget {
  const _ValueCell({
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final int value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    return SizedBox(
      width: 48,
      height: 48,
      child: Material(
        color: selected ? scheme.primary : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          onTap: onTap,
          child: Center(
            child: Text(
              '$value',
              style: context.textStyles.titleLarge?.copyWith(
                color: selected ? scheme.onPrimary : scheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
