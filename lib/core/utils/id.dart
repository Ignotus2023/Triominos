import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Generuje nowy identyfikator UUID v4 dla encji.
String newId() => _uuid.v4();
