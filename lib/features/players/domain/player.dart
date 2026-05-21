import '../../../core/constants.dart';
import '../../../core/utils/id.dart';

class Player {
  const Player({
    required this.id,
    required this.name,
    required this.initials,
    required this.avatarColor,
    required this.isGuest,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Player.draft({
    required String name,
    required String initials,
    required String avatarColor,
    bool isGuest = true,
  }) {
    final now = DateTime.now();
    return Player(
      id: newId(),
      name: name,
      initials: initials,
      avatarColor: avatarColor,
      isGuest: isGuest,
      createdAt: now,
      updatedAt: now,
    );
  }

  final String id;
  final String name;
  final String initials;
  final String avatarColor;
  final bool isGuest;
  final DateTime createdAt;
  final DateTime updatedAt;

  Player copyWith({
    String? name,
    String? initials,
    String? avatarColor,
    bool? isGuest,
    DateTime? updatedAt,
  }) {
    return Player(
      id: id,
      name: name ?? this.name,
      initials: initials ?? this.initials,
      avatarColor: avatarColor ?? this.avatarColor,
      isGuest: isGuest ?? this.isGuest,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Player &&
          other.id == id &&
          other.name == name &&
          other.initials == initials &&
          other.avatarColor == avatarColor &&
          other.isGuest == isGuest;

  @override
  int get hashCode => Object.hash(id, name, initials, avatarColor, isGuest);
}

class PlayerValidationError implements Exception {
  const PlayerValidationError(this.field, this.code);
  final String field;
  final String code;
}

abstract class PlayerValidator {
  PlayerValidator._();

  static String? validateName(String? raw) {
    final value = raw?.trim() ?? '';
    if (value.isEmpty) return 'required';
    if (value.length > AppConstants.playerNameMaxLength) return 'tooLong';
    return null;
  }

  static String initialsFromName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.length == 1) {
      return parts.first.substring(0, parts.first.length >= 2 ? 2 : 1).toUpperCase();
    }
    final first = parts.first.substring(0, 1);
    final last = parts.last.substring(0, 1);
    return (first + last).toUpperCase();
  }
}
