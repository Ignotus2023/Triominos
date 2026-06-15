import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/extensions/build_context.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/glass_container.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppScaffold(
      title: l10n.privacyTitle,
      body: ListView(
        children: [
          GlassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lock_outline,
                  color: context.colors.primary,
                  size: 32,
                ),
                const SizedBox(height: AppSpacing.x16),
                Text(l10n.privacyBody, style: context.text.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
