import 'dart:ui';

Color colorFromHex(String hex) {
  final cleaned = hex.replaceFirst('#', '').trim();
  final value = int.tryParse(cleaned, radix: 16) ?? 0xFF6366F1;
  if (cleaned.length <= 6) {
    return Color(0xFF000000 | value);
  }
  return Color(value);
}

String hexFromColor(Color color) {
  final argb = color.toARGB32();
  final rgb = argb & 0x00FFFFFF;
  return '#${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}';
}
