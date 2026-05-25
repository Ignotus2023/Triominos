// Fasada reklam — wybiera implementację zależnie od platformy.
// Web/desktop → ads_stub (placeholder), mobile → ads_io (google_mobile_ads).
export 'ads_stub.dart' if (dart.library.io) 'ads_io.dart';
