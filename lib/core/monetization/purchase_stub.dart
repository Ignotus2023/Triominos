// Domyślna (web) implementacja zakupów — niedostępna.
//
// Na web Premium odblokowujemy przełącznikiem w ustawieniach (do testów).
class PurchaseService {
  PurchaseService({required this.onPremiumUnlocked});

  final void Function() onPremiumUnlocked;

  bool get available => false;

  Future<void> init() async {}

  Future<void> buy() async {}

  Future<void> restore() async {}

  void dispose() {}
}
