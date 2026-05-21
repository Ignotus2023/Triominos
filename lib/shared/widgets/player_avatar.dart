import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';

class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar({
    required this.initials,
    required this.color,
    this.size = 44,
    this.isActive = false,
    super.key,
  });

  final String initials;
  final Color color;
  final double size;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Colors.white,
          fontSize: size * 0.4,
        );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: isActive
            ? Border.all(color: Colors.white.withValues(alpha: 0.9), width: 2)
            : null,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: FittedBox(
          child: Text(initials.toUpperCase(), style: textStyle),
        ),
      ),
    );
  }
}
