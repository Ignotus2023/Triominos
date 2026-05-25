import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:triomino_score/core/database/app_database.dart';
import 'package:triomino_score/core/game/game_enums.dart';
import 'package:triomino_score/core/game/scoring_config.dart';
import 'package:triomino_score/core/haptics/haptics_service.dart';
import 'package:triomino_score/core/localization/gen/app_localizations.dart';
import 'package:triomino_score/core/settings/settings_provider.dart';
import 'package:triomino_score/core/theme/app_colors.dart';
import 'package:triomino_score/features/game/presentation/widgets/smart_input_sheet.dart';

void main() {
  testWidgets('Smart Input liczy 5-5-5 jako triplet = 25 (bez startu)',
      (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    final now = DateTime.now();
    await db.gamesDao.createGame(
      game: GamesCompanion.insert(
        id: 'g1',
        endMode: EndMode.freeform,
        status: GameStatus.inProgress,
        startedAt: now,
      ),
      seats: const [],
      firstRound: RoundsCompanion.insert(
        id: 'r1',
        gameId: 'g1',
        roundNumber: 1,
        starterPlayerId: 'p1',
        startedAt: now,
      ),
    );
    final game = (await db.gamesDao.getGame('g1'))!;
    final round = (await db.gamesDao.getCurrentRound('g1'))!;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          hapticsProvider.overrideWithValue(const HapticsService(false)),
          scoringConfigProvider.overrideWithValue(ScoringConfig.standard),
        ],
        child: MaterialApp(
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            useMaterial3: true,
            extensions: const [GlassColors.light],
          ),
          home: Scaffold(
            body: SmartInputSheet(
              game: game,
              round: round,
              playerId: 'p1',
              playerName: 'Anna',
              moveNumber: 1,
              isStarterMove: false,
              opponentsCount: 1,
            ),
          ),
        ),
      ),
    );

    // Trzy rzędy narożników, w każdym wybieramy "5".
    final fives = find.widgetWithText(ChoiceChip, '5');
    expect(fives, findsNWidgets(3));
    for (var i = 0; i < 3; i++) {
      await tester.tap(fives.at(i));
      await tester.pump();
    }

    // 5+5+5 = 15 bazy + 10 za triplet = 25 (bez bonusu startowego).
    expect(find.text('25'), findsOneWidget);
  });
}
