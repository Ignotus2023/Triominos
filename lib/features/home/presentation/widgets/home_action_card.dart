import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/extensions/build_context.dart';
import '../../../../shared/widgets/glass_container.dart';

class HomeActionCard extends StatelessWidget {
  const HomeActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.x24,
        horizontal: AppSpacing.x16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: context.colors.primary, size: 28),
          const SizedBox(height: AppSpacing.x12),
          Text(label, style: context.text.titleLarge),
        ],
      ),
    );
  }
}
