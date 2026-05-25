import 'dart:convert';

import 'scoring_rules.dart';

/// Konfigurowalne wartości punktacji (Premium „zasady domowe").
///
/// Domyślne wartości pochodzą z [ScoringRules]. Obiekt jest niemutowalny i
/// serializowalny do JSON (przechowywany w ustawieniach).
class ScoringConfig {
  const ScoringConfig({
    this.tripletBonus = ScoringRules.tripletBonus,
    this.zeroTripletBonus = ScoringRules.zeroTripletBonus,
    this.bridgeBonus = ScoringRules.bridgeBonus,
    this.hexagonBonus = ScoringRules.hexagonBonus,
    this.doubleHexagonBonus = ScoringRules.doubleHexagonBonus,
    this.starterBonus = ScoringRules.starterBonus,
    this.endOfHandBonus = ScoringRules.endOfHandBonus,
    this.drawPenalty = ScoringRules.drawPenalty,
    this.passPenalty = ScoringRules.passPenalty,
  });

  static const standard = ScoringConfig();

  final int tripletBonus;
  final int zeroTripletBonus;
  final int bridgeBonus;
  final int hexagonBonus;
  final int doubleHexagonBonus;
  final int starterBonus;
  final int endOfHandBonus;
  final int drawPenalty;
  final int passPenalty;

  ScoringConfig copyWith({
    int? tripletBonus,
    int? zeroTripletBonus,
    int? bridgeBonus,
    int? hexagonBonus,
    int? doubleHexagonBonus,
    int? starterBonus,
    int? endOfHandBonus,
    int? drawPenalty,
    int? passPenalty,
  }) {
    return ScoringConfig(
      tripletBonus: tripletBonus ?? this.tripletBonus,
      zeroTripletBonus: zeroTripletBonus ?? this.zeroTripletBonus,
      bridgeBonus: bridgeBonus ?? this.bridgeBonus,
      hexagonBonus: hexagonBonus ?? this.hexagonBonus,
      doubleHexagonBonus: doubleHexagonBonus ?? this.doubleHexagonBonus,
      starterBonus: starterBonus ?? this.starterBonus,
      endOfHandBonus: endOfHandBonus ?? this.endOfHandBonus,
      drawPenalty: drawPenalty ?? this.drawPenalty,
      passPenalty: passPenalty ?? this.passPenalty,
    );
  }

  Map<String, dynamic> toMap() => {
        'tripletBonus': tripletBonus,
        'zeroTripletBonus': zeroTripletBonus,
        'bridgeBonus': bridgeBonus,
        'hexagonBonus': hexagonBonus,
        'doubleHexagonBonus': doubleHexagonBonus,
        'starterBonus': starterBonus,
        'endOfHandBonus': endOfHandBonus,
        'drawPenalty': drawPenalty,
        'passPenalty': passPenalty,
      };

  factory ScoringConfig.fromMap(Map<String, dynamic> map) {
    int v(String key, int fallback) =>
        (map[key] is num) ? (map[key] as num).toInt() : fallback;
    return ScoringConfig(
      tripletBonus: v('tripletBonus', ScoringRules.tripletBonus),
      zeroTripletBonus: v('zeroTripletBonus', ScoringRules.zeroTripletBonus),
      bridgeBonus: v('bridgeBonus', ScoringRules.bridgeBonus),
      hexagonBonus: v('hexagonBonus', ScoringRules.hexagonBonus),
      doubleHexagonBonus: v('doubleHexagonBonus', ScoringRules.doubleHexagonBonus),
      starterBonus: v('starterBonus', ScoringRules.starterBonus),
      endOfHandBonus: v('endOfHandBonus', ScoringRules.endOfHandBonus),
      drawPenalty: v('drawPenalty', ScoringRules.drawPenalty),
      passPenalty: v('passPenalty', ScoringRules.passPenalty),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory ScoringConfig.fromJson(String source) =>
      ScoringConfig.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
