// Zakupy w aplikacji dla platform mobilnych (in_app_purchase).
//
// Wymaga skonfigurowania produktu o ID [_premiumProductId] w App Store Connect
// i Google Play Console przed publikacją.
import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

const _premiumProductId = 'premium_unlock';

class PurchaseService {
  PurchaseService({required this.onPremiumUnlocked});

  final void Function() onPremiumUnlocked;

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _sub;
  bool _available = false;

  bool get available => _available;

  Future<void> init() async {
    _available = await _iap.isAvailable();
    _sub = _iap.purchaseStream.listen(_onPurchases, onError: (_) {});
  }

  void _onPurchases(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.productID != _premiumProductId) continue;
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        onPremiumUnlocked();
      }
      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
      }
    }
  }

  Future<void> buy() async {
    if (!_available) return;
    final response = await _iap.queryProductDetails({_premiumProductId});
    if (response.productDetails.isEmpty) return;
    await _iap.buyNonConsumable(
      purchaseParam:
          PurchaseParam(productDetails: response.productDetails.first),
    );
  }

  Future<void> restore() async {
    if (!_available) return;
    await _iap.restorePurchases();
  }

  void dispose() {
    _sub?.cancel();
  }
}
