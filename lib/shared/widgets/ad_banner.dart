import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../extensions/build_context.dart';

/// Placeholder banera reklamowego dla wersji darmowej.
///
/// Rezerwuje miejsce na realną reklamę (np. AdMob) wdrażaną na platformach
/// mobilnych w kolejnych wersjach. Na podglądzie web pokazuje neutralny slot.
class AdBanner extends StatelessWidget {
  const AdBanner({this.height = 56, super.key});

  final double height;

  @override
  Widget build(BuildContext context) {
    final muted = context.colors.onSurface.withValues(alpha: 0.45);
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.x8),
      decoration: BoxDecoration(
        color: context.colors.onSurface.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(AppRadii.sm),
        border: Border.all(
          color: context.colors.onSurface.withValues(alpha: 0.12),
        ),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.campaign_outlined, size: 18, color: muted),
          const SizedBox(width: AppSpacing.x8),
          Text(
            context.l10n.adPlaceholder,
            style: context.text.labelSmall?.copyWith(
              color: muted,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
