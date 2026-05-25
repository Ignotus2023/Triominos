import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pl'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'TriominoScore'**
  String get appTitle;

  /// No description provided for @scoreSuffix.
  ///
  /// In en, this message translates to:
  /// **'pts'**
  String get scoreSuffix;

  /// No description provided for @adPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Advertisement'**
  String get adPlaceholder;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get commonStart;

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @scoreUnit.
  ///
  /// In en, this message translates to:
  /// **'{count} pts'**
  String scoreUnit(int count);

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your professional Triominos scorekeeper'**
  String get homeSubtitle;

  /// No description provided for @homeNewGame.
  ///
  /// In en, this message translates to:
  /// **'New game'**
  String get homeNewGame;

  /// No description provided for @homeResumeGame.
  ///
  /// In en, this message translates to:
  /// **'Resume game'**
  String get homeResumeGame;

  /// No description provided for @homePlayers.
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get homePlayers;

  /// No description provided for @homeHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get homeHistory;

  /// No description provided for @homeStatistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get homeStatistics;

  /// No description provided for @homeRules.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get homeRules;

  /// No description provided for @homeSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get homeSettings;

  /// No description provided for @playersTitle.
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get playersTitle;

  /// No description provided for @playersAdd.
  ///
  /// In en, this message translates to:
  /// **'Add player'**
  String get playersAdd;

  /// No description provided for @playersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No players yet. Add the first one!'**
  String get playersEmpty;

  /// No description provided for @playerName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get playerName;

  /// No description provided for @playerNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Anna'**
  String get playerNameHint;

  /// No description provided for @playerNew.
  ///
  /// In en, this message translates to:
  /// **'New player'**
  String get playerNew;

  /// No description provided for @playerEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit player'**
  String get playerEdit;

  /// No description provided for @playerColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get playerColor;

  /// No description provided for @playerPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get playerPhoto;

  /// No description provided for @premiumPhotoHint.
  ///
  /// In en, this message translates to:
  /// **'Profile photos are a Premium feature'**
  String get premiumPhotoHint;

  /// No description provided for @playerDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this player? Their game history stays intact.'**
  String get playerDeleteConfirm;

  /// No description provided for @playerErrorNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get playerErrorNameEmpty;

  /// No description provided for @playerErrorNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Name is too long (max 32 characters)'**
  String get playerErrorNameTooLong;

  /// No description provided for @setupTitle.
  ///
  /// In en, this message translates to:
  /// **'New game'**
  String get setupTitle;

  /// No description provided for @setupSelectPlayers.
  ///
  /// In en, this message translates to:
  /// **'Select players'**
  String get setupSelectPlayers;

  /// No description provided for @setupOrder.
  ///
  /// In en, this message translates to:
  /// **'Turn order (drag to reorder)'**
  String get setupOrder;

  /// No description provided for @setupPlayersRange.
  ///
  /// In en, this message translates to:
  /// **'Pick {min}–{max} players'**
  String setupPlayersRange(int min, int max);

  /// No description provided for @setupEndMode.
  ///
  /// In en, this message translates to:
  /// **'End condition'**
  String get setupEndMode;

  /// No description provided for @setupEndModeScoreLimit.
  ///
  /// In en, this message translates to:
  /// **'Score limit'**
  String get setupEndModeScoreLimit;

  /// No description provided for @setupEndModeRounds.
  ///
  /// In en, this message translates to:
  /// **'Number of rounds'**
  String get setupEndModeRounds;

  /// No description provided for @setupEndModeFreeform.
  ///
  /// In en, this message translates to:
  /// **'Free play'**
  String get setupEndModeFreeform;

  /// No description provided for @setupEndModeScoreLimitDesc.
  ///
  /// In en, this message translates to:
  /// **'First to reach the points threshold wins'**
  String get setupEndModeScoreLimitDesc;

  /// No description provided for @setupEndModeRoundsDesc.
  ///
  /// In en, this message translates to:
  /// **'Play a fixed number of rounds'**
  String get setupEndModeRoundsDesc;

  /// No description provided for @setupEndModeFreeformDesc.
  ///
  /// In en, this message translates to:
  /// **'End the game manually anytime'**
  String get setupEndModeFreeformDesc;

  /// No description provided for @setupScoreLimit.
  ///
  /// In en, this message translates to:
  /// **'Score threshold'**
  String get setupScoreLimit;

  /// No description provided for @setupRounds.
  ///
  /// In en, this message translates to:
  /// **'Rounds'**
  String get setupRounds;

  /// No description provided for @setupStartGame.
  ///
  /// In en, this message translates to:
  /// **'Start game'**
  String get setupStartGame;

  /// No description provided for @setupNeedMorePlayers.
  ///
  /// In en, this message translates to:
  /// **'Select at least {min} players'**
  String setupNeedMorePlayers(int min);

  /// No description provided for @gameRound.
  ///
  /// In en, this message translates to:
  /// **'Round {number}'**
  String gameRound(int number);

  /// No description provided for @gameYourTurn.
  ///
  /// In en, this message translates to:
  /// **'YOUR TURN'**
  String get gameYourTurn;

  /// No description provided for @gameAddMove.
  ///
  /// In en, this message translates to:
  /// **'Add move'**
  String get gameAddMove;

  /// No description provided for @gamePass.
  ///
  /// In en, this message translates to:
  /// **'Pass'**
  String get gamePass;

  /// No description provided for @gameEndHand.
  ///
  /// In en, this message translates to:
  /// **'Hand out'**
  String get gameEndHand;

  /// No description provided for @gameRoundHistory.
  ///
  /// In en, this message translates to:
  /// **'This round'**
  String get gameRoundHistory;

  /// No description provided for @gameNoMoves.
  ///
  /// In en, this message translates to:
  /// **'No moves yet'**
  String get gameNoMoves;

  /// No description provided for @gameUndoLast.
  ///
  /// In en, this message translates to:
  /// **'Undo last move'**
  String get gameUndoLast;

  /// No description provided for @gameLastMove.
  ///
  /// In en, this message translates to:
  /// **'last: {points}'**
  String gameLastMove(String points);

  /// No description provided for @gameFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish game'**
  String get gameFinish;

  /// No description provided for @gameThresholdReached.
  ///
  /// In en, this message translates to:
  /// **'Threshold reached: {name}'**
  String gameThresholdReached(String name);

  /// No description provided for @gameNextRound.
  ///
  /// In en, this message translates to:
  /// **'Next round'**
  String get gameNextRound;

  /// No description provided for @inputTitle.
  ///
  /// In en, this message translates to:
  /// **'{player}\'s move'**
  String inputTitle(String player);

  /// No description provided for @inputContext.
  ///
  /// In en, this message translates to:
  /// **'Round {round} · move #{move}'**
  String inputContext(int round, int move);

  /// No description provided for @inputCorners.
  ///
  /// In en, this message translates to:
  /// **'Tile corner values'**
  String get inputCorners;

  /// No description provided for @inputBonuses.
  ///
  /// In en, this message translates to:
  /// **'Bonuses (tap to add)'**
  String get inputBonuses;

  /// No description provided for @inputBonusTriplet.
  ///
  /// In en, this message translates to:
  /// **'Triplet'**
  String get inputBonusTriplet;

  /// No description provided for @inputBonusBridge.
  ///
  /// In en, this message translates to:
  /// **'Bridge'**
  String get inputBonusBridge;

  /// No description provided for @inputBonusHexagon.
  ///
  /// In en, this message translates to:
  /// **'Hexagon'**
  String get inputBonusHexagon;

  /// No description provided for @inputBonusDoubleHexagon.
  ///
  /// In en, this message translates to:
  /// **'Double hex'**
  String get inputBonusDoubleHexagon;

  /// No description provided for @bonusInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'What do the bonuses mean?'**
  String get bonusInfoTitle;

  /// No description provided for @bonusTripletDesc.
  ///
  /// In en, this message translates to:
  /// **'A tile with three identical digits (e.g. 4-4-4). +10, or +30 for 0-0-0.'**
  String get bonusTripletDesc;

  /// No description provided for @bonusBridgeDesc.
  ///
  /// In en, this message translates to:
  /// **'Connects two previously separate regions at a single corner. +40.'**
  String get bonusBridgeDesc;

  /// No description provided for @bonusHexagonDesc.
  ///
  /// In en, this message translates to:
  /// **'Completes a hexagon made of 6 triangles. +50.'**
  String get bonusHexagonDesc;

  /// No description provided for @bonusDoubleHexagonDesc.
  ///
  /// In en, this message translates to:
  /// **'One tile completes two hexagons at once. +110 in total.'**
  String get bonusDoubleHexagonDesc;

  /// No description provided for @inputTripletDetected.
  ///
  /// In en, this message translates to:
  /// **'Triplet detected'**
  String get inputTripletDetected;

  /// No description provided for @inputSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get inputSummary;

  /// No description provided for @inputBase.
  ///
  /// In en, this message translates to:
  /// **'Base'**
  String get inputBase;

  /// No description provided for @inputBonusLine.
  ///
  /// In en, this message translates to:
  /// **'Bonus'**
  String get inputBonusLine;

  /// No description provided for @inputTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get inputTotal;

  /// No description provided for @inputConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get inputConfirm;

  /// No description provided for @inputOtherActions.
  ///
  /// In en, this message translates to:
  /// **'Other actions'**
  String get inputOtherActions;

  /// No description provided for @inputDrawPile.
  ///
  /// In en, this message translates to:
  /// **'Draw from pile ({penalty})'**
  String inputDrawPile(int penalty);

  /// No description provided for @inputPassPenalty.
  ///
  /// In en, this message translates to:
  /// **'Pass ({penalty})'**
  String inputPassPenalty(int penalty);

  /// No description provided for @moveDraw.
  ///
  /// In en, this message translates to:
  /// **'Draw'**
  String get moveDraw;

  /// No description provided for @inputEndHand.
  ///
  /// In en, this message translates to:
  /// **'Hand out (round end)'**
  String get inputEndHand;

  /// No description provided for @inputOpponentsHandSum.
  ///
  /// In en, this message translates to:
  /// **'Sum of opponents\' hands'**
  String get inputOpponentsHandSum;

  /// No description provided for @inputOpponentsHandSumHint.
  ///
  /// In en, this message translates to:
  /// **'Total of corner digits left in opponents\' hands'**
  String get inputOpponentsHandSumHint;

  /// No description provided for @summaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Game over'**
  String get summaryTitle;

  /// No description provided for @summaryWinner.
  ///
  /// In en, this message translates to:
  /// **'{name} wins!'**
  String summaryWinner(String name);

  /// No description provided for @summaryScoreboard.
  ///
  /// In en, this message translates to:
  /// **'Final scoreboard'**
  String get summaryScoreboard;

  /// No description provided for @summaryRematch.
  ///
  /// In en, this message translates to:
  /// **'Rematch'**
  String get summaryRematch;

  /// No description provided for @summaryHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get summaryHome;

  /// No description provided for @summaryRoundsPlayed.
  ///
  /// In en, this message translates to:
  /// **'Rounds played'**
  String get summaryRoundsPlayed;

  /// No description provided for @summaryDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get summaryDuration;

  /// No description provided for @summaryShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get summaryShare;

  /// No description provided for @homeQuickRematch.
  ///
  /// In en, this message translates to:
  /// **'Quick rematch'**
  String get homeQuickRematch;

  /// No description provided for @achievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementsTitle;

  /// No description provided for @achFirstGame.
  ///
  /// In en, this message translates to:
  /// **'First game'**
  String get achFirstGame;

  /// No description provided for @achFirstHexagon.
  ///
  /// In en, this message translates to:
  /// **'First hexagon'**
  String get achFirstHexagon;

  /// No description provided for @achFirstBridge.
  ///
  /// In en, this message translates to:
  /// **'First bridge'**
  String get achFirstBridge;

  /// No description provided for @achBigMove.
  ///
  /// In en, this message translates to:
  /// **'Big move (40+)'**
  String get achBigMove;

  /// No description provided for @achGames10.
  ///
  /// In en, this message translates to:
  /// **'10 games played'**
  String get achGames10;

  /// No description provided for @achHatTrick.
  ///
  /// In en, this message translates to:
  /// **'3 wins in a row'**
  String get achHatTrick;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No finished games yet'**
  String get historyEmpty;

  /// No description provided for @historyWinner.
  ///
  /// In en, this message translates to:
  /// **'Winner: {name}'**
  String historyWinner(String name);

  /// No description provided for @statsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statsTitle;

  /// No description provided for @statsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Play a few games to see statistics'**
  String get statsEmpty;

  /// No description provided for @statsTotalGames.
  ///
  /// In en, this message translates to:
  /// **'Games played'**
  String get statsTotalGames;

  /// No description provided for @statsBestScore.
  ///
  /// In en, this message translates to:
  /// **'Best score'**
  String get statsBestScore;

  /// No description provided for @statsMostHexagons.
  ///
  /// In en, this message translates to:
  /// **'Most hexagons in a game'**
  String get statsMostHexagons;

  /// No description provided for @rulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get rulesTitle;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go'**
  String get onboardingStart;

  /// No description provided for @onb1Title.
  ///
  /// In en, this message translates to:
  /// **'Welcome to TriominoScore'**
  String get onb1Title;

  /// No description provided for @onb1Body.
  ///
  /// In en, this message translates to:
  /// **'Your professional scorekeeper for the Triominos board game.'**
  String get onb1Body;

  /// No description provided for @onb2Title.
  ///
  /// In en, this message translates to:
  /// **'Smart Input'**
  String get onb2Title;

  /// No description provided for @onb2Body.
  ///
  /// In en, this message translates to:
  /// **'Enter the three corner digits and tap a bonus — done.'**
  String get onb2Body;

  /// No description provided for @onb3Title.
  ///
  /// In en, this message translates to:
  /// **'Auto bonuses'**
  String get onb3Title;

  /// No description provided for @onb3Body.
  ///
  /// In en, this message translates to:
  /// **'The app counts triplet, bridge and hexagon bonuses for you.'**
  String get onb3Body;

  /// No description provided for @onb4Title.
  ///
  /// In en, this message translates to:
  /// **'Ready to play'**
  String get onb4Title;

  /// No description provided for @onb4Body.
  ///
  /// In en, this message translates to:
  /// **'Add players and start your first game.'**
  String get onb4Body;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsSounds.
  ///
  /// In en, this message translates to:
  /// **'Sound effects'**
  String get settingsSounds;

  /// No description provided for @settingsHaptics.
  ///
  /// In en, this message translates to:
  /// **'Haptics'**
  String get settingsHaptics;

  /// No description provided for @settingsPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get settingsPremium;

  /// No description provided for @settingsPremiumDesc.
  ///
  /// In en, this message translates to:
  /// **'Unlock editing any move and remove ads'**
  String get settingsPremiumDesc;

  /// No description provided for @premiumEditHint.
  ///
  /// In en, this message translates to:
  /// **'Editing any move is a Premium feature'**
  String get premiumEditHint;

  /// No description provided for @premiumBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy Premium'**
  String get premiumBuy;

  /// No description provided for @premiumRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get premiumRestore;

  /// No description provided for @settingsDefaultScoreLimit.
  ///
  /// In en, this message translates to:
  /// **'Default score threshold'**
  String get settingsDefaultScoreLimit;

  /// No description provided for @settingsHouseRules.
  ///
  /// In en, this message translates to:
  /// **'House rules'**
  String get settingsHouseRules;

  /// No description provided for @rulesStarterBonus.
  ///
  /// In en, this message translates to:
  /// **'Starter bonus'**
  String get rulesStarterBonus;

  /// No description provided for @rulesEndOfHand.
  ///
  /// In en, this message translates to:
  /// **'Hand-out bonus'**
  String get rulesEndOfHand;

  /// No description provided for @rulesReset.
  ///
  /// In en, this message translates to:
  /// **'Reset to defaults'**
  String get rulesReset;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsResetData.
  ///
  /// In en, this message translates to:
  /// **'Reset all data'**
  String get settingsResetData;

  /// No description provided for @settingsResetConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete all games and players? This cannot be undone.'**
  String get settingsResetConfirm;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String settingsVersion(String version);

  /// No description provided for @languagePolish.
  ///
  /// In en, this message translates to:
  /// **'Polski'**
  String get languagePolish;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageGerman.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @languageItalian.
  ///
  /// In en, this message translates to:
  /// **'Italiano'**
  String get languageItalian;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'pl',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
