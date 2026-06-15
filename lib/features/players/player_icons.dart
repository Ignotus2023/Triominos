import 'package:flutter/material.dart';

/// Stały katalog ikon awatarów: klucz (zapisywany w bazie) → [IconData].
///
/// Klucze są stabilne i niezależne od wersji Fluttera. Wartości to `const`
/// `IconData`, dzięki czemu działa `--tree-shake-icons` (brak dynamicznego
/// tworzenia `IconData` z codepointu).
const playerIconCatalog = <String, IconData>{
  'person': Icons.person,
  'face': Icons.face,
  'pets': Icons.pets,
  'star': Icons.star,
  'bolt': Icons.bolt,
  'favorite': Icons.favorite,
  'rocket': Icons.rocket_launch,
  'games': Icons.sports_esports,
  'soccer': Icons.sports_soccer,
  'music': Icons.music_note,
  'nature': Icons.emoji_nature,
  'diamond': Icons.diamond,
};

/// Zwraca [IconData] dla zapisanego klucza lub `null`, gdy gracz nie ma ikony
/// (wtedy awatar pokazuje inicjały).
IconData? playerIconFor(String? key) =>
    key == null ? null : playerIconCatalog[key];
