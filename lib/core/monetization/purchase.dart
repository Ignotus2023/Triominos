// Fasada zakupów Premium — implementacja zależna od platformy.
// Web/desktop → purchase_stub (niedostępne), mobile → purchase_io (in_app_purchase).
export 'purchase_stub.dart' if (dart.library.io) 'purchase_io.dart';
