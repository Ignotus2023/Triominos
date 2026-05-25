import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../settings/settings_provider.dart';
import 'purchase.dart';

/// Serwis zakupów Premium. Po udanym zakupie/przywróceniu ustawia Premium.
final purchaseServiceProvider = Provider<PurchaseService>((ref) {
  final service = PurchaseService(
    onPremiumUnlocked: () => ref.read(settingsProvider.notifier).setPremium(true),
  );
  service.init();
  ref.onDispose(service.dispose);
  return service;
});
