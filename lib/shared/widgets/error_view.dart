import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../extensions/build_context.dart';

/// Przyjazny stan błędu dla ekranów opartych na [AsyncValue]. Zastępuje surowy
/// `Text('$error')` zlokalizowanym komunikatem (raw błąd tylko w debug).
class ErrorView extends StatelessWidget {
  const ErrorView({this.error, super.key});

  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 40, color: context.colors.error),
            const SizedBox(height: AppSpacing.x12),
            Text(
              context.l10n.commonError,
              style: context.text.titleLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
