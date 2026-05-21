import 'package:flutter/material.dart';

import '../../../../core/haptics/haptics_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class AvatarColorPicker extends StatelessWidget {
  const AvatarColorPicker({
    required this.selected,
    required this.onChanged,
    this.haptics,
    super.key,
  });

  final Color selected;
  final ValueChanged<Color> onChanged;
  final HapticsService? haptics;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.x12,
      runSpacing: AppSpacing.x12,
      children: AppColors.avatarPalette.map((color) {
        final isSelected = color == selected;
        return GestureDetector(
          onTap: () {
            haptics?.trigger(HapticPattern.selection);
            onChanged(color);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: Border.all(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 3,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.6),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 22)
                : null,
          ),
        );
      }).toList(growable: false),
    );
  }
}
