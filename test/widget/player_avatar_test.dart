import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:triomino_score/shared/widgets/player_avatar.dart';

void main() {
  testWidgets('PlayerAvatar pokazuje inicjały', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PlayerAvatar(initials: 'AN', colorHex: '#6366F1'),
        ),
      ),
    );
    expect(find.text('AN'), findsOneWidget);
  });
}
