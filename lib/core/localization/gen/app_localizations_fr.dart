// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'TriominoScore';

  @override
  String get scoreSuffix => 'pts';

  @override
  String get adPlaceholder => 'Publicité';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get commonConfirm => 'Confirmer';

  @override
  String get commonClose => 'Fermer';

  @override
  String get commonStart => 'Démarrer';

  @override
  String get commonAdd => 'Ajouter';

  @override
  String get commonBack => 'Retour';

  @override
  String get commonNext => 'Suivant';

  @override
  String scoreUnit(int count) {
    return '$count pts';
  }

  @override
  String get homeSubtitle => 'Votre assistant de score Triominos professionnel';

  @override
  String get homeNewGame => 'Nouvelle partie';

  @override
  String get homeResumeGame => 'Reprendre la partie';

  @override
  String get homePlayers => 'Joueurs';

  @override
  String get homeHistory => 'Historique';

  @override
  String get homeStatistics => 'Statistiques';

  @override
  String get homeRules => 'Règles';

  @override
  String get homeSettings => 'Paramètres';

  @override
  String get playersTitle => 'Joueurs';

  @override
  String get playersAdd => 'Ajouter un joueur';

  @override
  String get playersEmpty =>
      'Aucun joueur pour l\'instant. Ajoutez le premier !';

  @override
  String get playerName => 'Nom';

  @override
  String get playerNameHint => 'ex. Anna';

  @override
  String get playerNew => 'Nouveau joueur';

  @override
  String get playerEdit => 'Modifier le joueur';

  @override
  String get playerColor => 'Couleur';

  @override
  String get playerPhoto => 'Photo';

  @override
  String get premiumPhotoHint =>
      'Les photos de profil sont une fonction Premium';

  @override
  String get playerDeleteConfirm =>
      'Supprimer ce joueur ? Son historique de parties est conservé.';

  @override
  String get playerErrorNameEmpty => 'Saisissez un nom';

  @override
  String get playerErrorNameTooLong =>
      'Le nom est trop long (max. 32 caractères)';

  @override
  String get setupTitle => 'Nouvelle partie';

  @override
  String get setupSelectPlayers => 'Sélectionner les joueurs';

  @override
  String get setupOrder => 'Ordre des tours (glisser pour réordonner)';

  @override
  String setupPlayersRange(int min, int max) {
    return 'Choisissez $min à $max joueurs';
  }

  @override
  String get setupEndMode => 'Condition de fin';

  @override
  String get setupEndModeScoreLimit => 'Limite de points';

  @override
  String get setupEndModeRounds => 'Nombre de manches';

  @override
  String get setupEndModeFreeform => 'Jeu libre';

  @override
  String get setupEndModeScoreLimitDesc =>
      'Le premier à atteindre le seuil de points gagne';

  @override
  String get setupEndModeRoundsDesc => 'Jouez un nombre fixe de manches';

  @override
  String get setupEndModeFreeformDesc =>
      'Terminez la partie manuellement à tout moment';

  @override
  String get setupScoreLimit => 'Seuil de points';

  @override
  String get setupRounds => 'Manches';

  @override
  String get setupStartGame => 'Démarrer la partie';

  @override
  String setupNeedMorePlayers(int min) {
    return 'Sélectionnez au moins $min joueurs';
  }

  @override
  String gameRound(int number) {
    return 'Manche $number';
  }

  @override
  String get gameYourTurn => 'À VOUS';

  @override
  String get gameAddMove => 'Ajouter un coup';

  @override
  String get gamePass => 'Passer';

  @override
  String get gameEndHand => 'Main vide';

  @override
  String get gameRoundHistory => 'Cette manche';

  @override
  String get gameNoMoves => 'Aucun coup pour l\'instant';

  @override
  String get gameUndoLast => 'Annuler le dernier coup';

  @override
  String gameLastMove(String points) {
    return 'dernier : $points';
  }

  @override
  String get gameFinish => 'Terminer la partie';

  @override
  String gameThresholdReached(String name) {
    return 'Seuil atteint : $name';
  }

  @override
  String get gameNextRound => 'Manche suivante';

  @override
  String inputTitle(String player) {
    return 'Coup de $player';
  }

  @override
  String inputContext(int round, int move) {
    return 'Manche $round · coup n°$move';
  }

  @override
  String get inputCorners => 'Valeurs des coins de la tuile';

  @override
  String get inputBonuses => 'Bonus (touchez pour ajouter)';

  @override
  String get inputBonusTriplet => 'Triplet';

  @override
  String get inputBonusBridge => 'Pont';

  @override
  String get inputBonusHexagon => 'Hexagone';

  @override
  String get inputBonusDoubleHexagon => 'Double hex';

  @override
  String get bonusInfoTitle => 'Que signifient les bonus ?';

  @override
  String get bonusTripletDesc =>
      'Une tuile avec trois chiffres identiques (ex. 4-4-4). +10, ou +30 pour 0-0-0.';

  @override
  String get bonusBridgeDesc =>
      'Relie deux régions séparées par un seul coin. +40.';

  @override
  String get bonusHexagonDesc => 'Complète un hexagone de 6 triangles. +50.';

  @override
  String get bonusDoubleHexagonDesc =>
      'Une tuile complète deux hexagones à la fois. +110 au total.';

  @override
  String get inputTripletDetected => 'Triplet détecté';

  @override
  String get inputSummary => 'Récapitulatif';

  @override
  String get inputBase => 'Base';

  @override
  String get inputBonusLine => 'Bonus';

  @override
  String get inputTotal => 'Total';

  @override
  String get inputConfirm => 'Confirmer';

  @override
  String get inputOtherActions => 'Autres actions';

  @override
  String inputDrawPile(int penalty) {
    return 'Piocher ($penalty)';
  }

  @override
  String inputPassPenalty(int penalty) {
    return 'Passer ($penalty)';
  }

  @override
  String get moveDraw => 'Pioche';

  @override
  String get inputEndHand => 'Main vide (fin de manche)';

  @override
  String get inputOpponentsHandSum => 'Somme des mains adverses';

  @override
  String get inputOpponentsHandSumHint =>
      'Total des chiffres restants dans les mains des adversaires';

  @override
  String get summaryTitle => 'Partie terminée';

  @override
  String summaryWinner(String name) {
    return '$name gagne !';
  }

  @override
  String get summaryScoreboard => 'Classement final';

  @override
  String get summaryRematch => 'Revanche';

  @override
  String get summaryHome => 'Accueil';

  @override
  String get summaryRoundsPlayed => 'Manches jouées';

  @override
  String get summaryDuration => 'Durée';

  @override
  String get historyTitle => 'Historique';

  @override
  String get historyEmpty => 'Aucune partie terminée';

  @override
  String historyWinner(String name) {
    return 'Gagnant : $name';
  }

  @override
  String get statsTitle => 'Statistiques';

  @override
  String get statsEmpty => 'Jouez quelques parties pour voir les statistiques';

  @override
  String get statsTotalGames => 'Parties jouées';

  @override
  String get statsBestScore => 'Meilleur score';

  @override
  String get statsMostHexagons => 'Plus d\'hexagones en une partie';

  @override
  String get rulesTitle => 'Règles';

  @override
  String get onboardingSkip => 'Passer';

  @override
  String get onboardingStart => 'C\'est parti';

  @override
  String get onb1Title => 'Bienvenue dans TriominoScore';

  @override
  String get onb1Body =>
      'Votre assistant de score professionnel pour le jeu Triominos.';

  @override
  String get onb2Title => 'Smart Input';

  @override
  String get onb2Body =>
      'Saisissez les trois chiffres des coins et touchez un bonus — c\'est tout.';

  @override
  String get onb3Title => 'Bonus automatiques';

  @override
  String get onb3Body =>
      'L\'app calcule pour vous les bonus triplet, pont et hexagone.';

  @override
  String get onb4Title => 'Prêt à jouer';

  @override
  String get onb4Body => 'Ajoutez des joueurs et lancez votre première partie.';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsThemeSystem => 'Système';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsSounds => 'Effets sonores';

  @override
  String get settingsHaptics => 'Retour haptique';

  @override
  String get settingsPremium => 'Premium';

  @override
  String get settingsPremiumDesc =>
      'Débloquez la modification de tout coup et supprimez les pubs';

  @override
  String get premiumEditHint =>
      'Modifier un coup quelconque est une fonction Premium';

  @override
  String get settingsDefaultScoreLimit => 'Seuil de points par défaut';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get settingsResetData => 'Réinitialiser toutes les données';

  @override
  String get settingsResetConfirm =>
      'Supprimer toutes les parties et tous les joueurs ? Action irréversible.';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
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
