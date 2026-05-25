// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'TriominoScore';

  @override
  String get scoreSuffix => 'pti';

  @override
  String get adPlaceholder => 'Pubblicità';

  @override
  String get commonCancel => 'Annulla';

  @override
  String get commonSave => 'Salva';

  @override
  String get commonDelete => 'Elimina';

  @override
  String get commonConfirm => 'Conferma';

  @override
  String get commonClose => 'Chiudi';

  @override
  String get commonStart => 'Inizia';

  @override
  String get commonAdd => 'Aggiungi';

  @override
  String get commonBack => 'Indietro';

  @override
  String get commonNext => 'Avanti';

  @override
  String scoreUnit(int count) {
    return '$count pti';
  }

  @override
  String get homeSubtitle => 'Il tuo segnapunti professionale per Triominos';

  @override
  String get homeNewGame => 'Nuova partita';

  @override
  String get homeResumeGame => 'Riprendi partita';

  @override
  String get homePlayers => 'Giocatori';

  @override
  String get homeHistory => 'Cronologia';

  @override
  String get homeStatistics => 'Statistiche';

  @override
  String get homeRules => 'Regole';

  @override
  String get homeSettings => 'Impostazioni';

  @override
  String get playersTitle => 'Giocatori';

  @override
  String get playersAdd => 'Aggiungi giocatore';

  @override
  String get playersEmpty => 'Ancora nessun giocatore. Aggiungi il primo!';

  @override
  String get playerName => 'Nome';

  @override
  String get playerNameHint => 'es. Anna';

  @override
  String get playerNew => 'Nuovo giocatore';

  @override
  String get playerEdit => 'Modifica giocatore';

  @override
  String get playerColor => 'Colore';

  @override
  String get playerPhoto => 'Foto';

  @override
  String get premiumPhotoHint => 'Le foto profilo sono una funzione Premium';

  @override
  String get playerDeleteConfirm =>
      'Eliminare questo giocatore? La cronologia delle partite resta intatta.';

  @override
  String get playerErrorNameEmpty => 'Inserisci un nome';

  @override
  String get playerErrorNameTooLong =>
      'Il nome è troppo lungo (max 32 caratteri)';

  @override
  String get setupTitle => 'Nuova partita';

  @override
  String get setupSelectPlayers => 'Seleziona i giocatori';

  @override
  String get setupOrder => 'Ordine dei turni (trascina per riordinare)';

  @override
  String setupPlayersRange(int min, int max) {
    return 'Scegli da $min a $max giocatori';
  }

  @override
  String get setupEndMode => 'Condizione di fine';

  @override
  String get setupEndModeScoreLimit => 'Limite di punti';

  @override
  String get setupEndModeRounds => 'Numero di round';

  @override
  String get setupEndModeFreeform => 'Gioco libero';

  @override
  String get setupEndModeScoreLimitDesc =>
      'Vince il primo che raggiunge la soglia di punti';

  @override
  String get setupEndModeRoundsDesc => 'Gioca un numero fisso di round';

  @override
  String get setupEndModeFreeformDesc =>
      'Termina la partita manualmente quando vuoi';

  @override
  String get setupScoreLimit => 'Soglia di punti';

  @override
  String get setupRounds => 'Round';

  @override
  String get setupStartGame => 'Inizia partita';

  @override
  String setupNeedMorePlayers(int min) {
    return 'Seleziona almeno $min giocatori';
  }

  @override
  String gameRound(int number) {
    return 'Round $number';
  }

  @override
  String get gameYourTurn => 'TOCCA A TE';

  @override
  String get gameAddMove => 'Aggiungi mossa';

  @override
  String get gamePass => 'Passa';

  @override
  String get gameEndHand => 'Mano finita';

  @override
  String get gameRoundHistory => 'Questo round';

  @override
  String get gameNoMoves => 'Ancora nessuna mossa';

  @override
  String get gameUndoLast => 'Annulla ultima mossa';

  @override
  String gameLastMove(String points) {
    return 'ultima: $points';
  }

  @override
  String get gameFinish => 'Termina partita';

  @override
  String gameThresholdReached(String name) {
    return 'Soglia raggiunta: $name';
  }

  @override
  String get gameNextRound => 'Round successivo';

  @override
  String inputTitle(String player) {
    return 'Mossa di $player';
  }

  @override
  String inputContext(int round, int move) {
    return 'Round $round · mossa n. $move';
  }

  @override
  String get inputCorners => 'Valori degli angoli della tessera';

  @override
  String get inputBonuses => 'Bonus (tocca per aggiungere)';

  @override
  String get inputBonusTriplet => 'Triplet';

  @override
  String get inputBonusBridge => 'Ponte';

  @override
  String get inputBonusHexagon => 'Esagono';

  @override
  String get inputBonusDoubleHexagon => 'Doppio esa';

  @override
  String get bonusInfoTitle => 'Cosa significano i bonus?';

  @override
  String get bonusTripletDesc =>
      'Una tessera con tre cifre uguali (es. 4-4-4). +10, o +30 per 0-0-0.';

  @override
  String get bonusBridgeDesc =>
      'Collega due regioni separate tramite un angolo. +40.';

  @override
  String get bonusHexagonDesc => 'Completa un esagono di 6 triangoli. +50.';

  @override
  String get bonusDoubleHexagonDesc =>
      'Una tessera completa due esagoni insieme. +110 in totale.';

  @override
  String get inputTripletDetected => 'Triplet rilevato';

  @override
  String get inputSummary => 'Riepilogo';

  @override
  String get inputBase => 'Base';

  @override
  String get inputBonusLine => 'Bonus';

  @override
  String get inputTotal => 'Totale';

  @override
  String get inputConfirm => 'Conferma';

  @override
  String get inputOtherActions => 'Altre azioni';

  @override
  String inputDrawPile(int penalty) {
    return 'Pesca dal mazzo ($penalty)';
  }

  @override
  String inputPassPenalty(int penalty) {
    return 'Passa ($penalty)';
  }

  @override
  String get moveDraw => 'Pesca';

  @override
  String get inputEndHand => 'Mano finita (fine round)';

  @override
  String get inputOpponentsHandSum => 'Somma delle mani avversarie';

  @override
  String get inputOpponentsHandSumHint =>
      'Totale delle cifre rimaste nelle mani degli avversari';

  @override
  String get summaryTitle => 'Partita finita';

  @override
  String summaryWinner(String name) {
    return 'Vince $name!';
  }

  @override
  String get summaryScoreboard => 'Classifica finale';

  @override
  String get summaryRematch => 'Rivincita';

  @override
  String get summaryHome => 'Home';

  @override
  String get summaryRoundsPlayed => 'Round giocati';

  @override
  String get summaryDuration => 'Durata';

  @override
  String get historyTitle => 'Cronologia';

  @override
  String get historyEmpty => 'Ancora nessuna partita conclusa';

  @override
  String historyWinner(String name) {
    return 'Vincitore: $name';
  }

  @override
  String get statsTitle => 'Statistiche';

  @override
  String get statsEmpty => 'Gioca qualche partita per vedere le statistiche';

  @override
  String get statsTotalGames => 'Partite giocate';

  @override
  String get statsBestScore => 'Miglior punteggio';

  @override
  String get statsMostHexagons => 'Più esagoni in una partita';

  @override
  String get rulesTitle => 'Regole';

  @override
  String get onboardingSkip => 'Salta';

  @override
  String get onboardingStart => 'Si parte';

  @override
  String get onb1Title => 'Benvenuto in TriominoScore';

  @override
  String get onb1Body =>
      'Il tuo segnapunti professionale per il gioco da tavolo Triominos.';

  @override
  String get onb2Title => 'Smart Input';

  @override
  String get onb2Body =>
      'Inserisci le tre cifre degli angoli e tocca un bonus — fatto.';

  @override
  String get onb3Title => 'Bonus automatici';

  @override
  String get onb3Body =>
      'L\'app calcola per te i bonus triplet, ponte ed esagono.';

  @override
  String get onb4Title => 'Pronto a giocare';

  @override
  String get onb4Body => 'Aggiungi giocatori e inizia la tua prima partita.';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsLanguage => 'Lingua';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSystem => 'Sistema';

  @override
  String get settingsThemeLight => 'Chiaro';

  @override
  String get settingsThemeDark => 'Scuro';

  @override
  String get settingsSounds => 'Effetti sonori';

  @override
  String get settingsHaptics => 'Vibrazione';

  @override
  String get settingsPremium => 'Premium';

  @override
  String get settingsPremiumDesc =>
      'Sblocca la modifica di qualsiasi mossa e rimuovi gli annunci';

  @override
  String get premiumEditHint =>
      'Modificare qualsiasi mossa è una funzione Premium';

  @override
  String get settingsDefaultScoreLimit => 'Soglia di punti predefinita';

  @override
  String get settingsAbout => 'Informazioni';

  @override
  String get settingsResetData => 'Reimposta tutti i dati';

  @override
  String get settingsResetConfirm =>
      'Eliminare tutte le partite e i giocatori? Operazione irreversibile.';

  @override
  String settingsVersion(String version) {
    return 'Versione $version';
  }

  @override
  String get languagePolish => 'Polski';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageItalian => 'Italiano';
}
