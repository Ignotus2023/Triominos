import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../settings/settings_provider.dart';

enum HapticPattern {
  selection,
  light,
  medium,
  heavy,
  success,
  error,
}

class HapticsService {
  const HapticsService({required this.enabled});
  final bool enabled;

  Future<void> trigger(HapticPattern pattern) async {
    if (!enabled) return;
    switch (pattern) {
      case HapticPattern.selection:
        await HapticFeedback.selectionClick();
      case HapticPattern.light:
        await HapticFeedback.lightImpact();
      case HapticPattern.medium:
        await HapticFeedback.mediumImpact();
      case HapticPattern.heavy:
        await HapticFeedback.heavyImpact();
      case HapticPattern.success:
        await HapticFeedback.mediumImpact();
        await Future<void>.delayed(const Duration(milliseconds: 80));
        await HapticFeedback.mediumImpact();
      case HapticPattern.error:
        await HapticFeedback.vibrate();
    }
  }
}

final hapticsServiceProvider = Provider<HapticsService>((ref) {
  final enabled = ref.watch(
    settingsControllerProvider.select((s) => s.hapticsEnabled),
  );
  return HapticsService(enabled: enabled);
});
