import 'dart:typed_data';

import 'package:flutter/material.dart';

/// Kółko z inicjałami gracza w jego kolorze, albo zdjęciem profilowym (§ shared).
class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar({
    required this.initials,
    required this.colorHex,
    this.image,
    this.size = 40,
    this.active = false,
    super.key,
  });

  final String initials;
  final String colorHex;

  /// Opcjonalne zdjęcie profilowe (bajty). Gdy ustawione, zastępuje inicjały.
  final Uint8List? image;
  final double size;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = _parseHex(colorHex);
    final hasImage = image != null && image!.isNotEmpty;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: hasImage
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color, color.withValues(alpha: 0.7)],
              ),
        border: active
            ? Border.all(color: Colors.white.withValues(alpha: 0.9), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: active ? 16 : 6,
          ),
        ],
      ),
      alignment: Alignment.center,
      clipBehavior: hasImage ? Clip.antiAlias : Clip.none,
      child: hasImage
          ? Image.memory(image!, fit: BoxFit.cover, width: size, height: size)
          : Text(
              initials,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: size * 0.38,
              ),
            ),
    );
  }

  static Color _parseHex(String hex) {
    final value = hex.replaceFirst('#', '');
    final intValue = int.tryParse('FF$value', radix: 16) ?? 0xFF6366F1;
    return Color(intValue);
  }
}
