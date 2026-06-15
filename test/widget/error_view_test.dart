import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:triomino_score/core/localization/gen/app_localizations.dart';
import 'package:triomino_score/shared/widgets/error_view.dart';

void main() {
  testWidgets(
    'ErrorView pokazuje zlokalizowany komunikat zamiast surowego błędu',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: ErrorView(error: 'boom')),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('boom'), findsNothing);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    },
  );
}
