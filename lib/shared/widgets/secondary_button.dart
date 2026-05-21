import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = true,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final child = OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: scheme.outline),
        foregroundColor: scheme.onSurface,
        minimumSize: const Size.fromHeight(56),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x24),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20),
            AppSpacing.w8,
          ],
          Text(label),
        ],
      ),
    );
    return SizedBox(width: expand ? double.infinity : null, child: child);
  }
}
