// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'TriominoScore';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonSave => 'Guardar';

  @override
  String get commonDelete => 'Eliminar';

  @override
  String get commonConfirm => 'Confirmar';

  @override
  String get commonClose => 'Cerrar';

  @override
  String get commonStart => 'Empezar';

  @override
  String get commonAdd => 'Añadir';

  @override
  String get commonBack => 'Atrás';

  @override
  String get commonNext => 'Siguiente';

  @override
  String scoreUnit(int count) {
    return '$count pts';
  }

  @override
  String get homeSubtitle =>
      'Tu asistente profesional de puntuación de Triominos';

  @override
  String get homeNewGame => 'Nueva partida';

  @override
  String get homeResumeGame => 'Reanudar partida';

  @override
  String get homePlayers => 'Jugadores';

  @override
  String get homeHistory => 'Historial';

  @override
  String get homeStatistics => 'Estadísticas';

  @override
  String get homeRules => 'Reglas';

  @override
  String get homeSettings => 'Ajustes';

  @override
  String get playersTitle => 'Jugadores';

  @override
  String get playersAdd => 'Añadir jugador';

  @override
  String get playersEmpty => 'Aún no hay jugadores. ¡Añade el primero!';

  @override
  String get playerName => 'Nombre';

  @override
  String get playerNameHint => 'p. ej. Anna';

  @override
  String get playerNew => 'Nuevo jugador';

  @override
  String get playerEdit => 'Editar jugador';

  @override
  String get playerColor => 'Color';

  @override
  String get playerDeleteConfirm =>
      '¿Eliminar este jugador? Su historial de partidas se conserva.';

  @override
  String get playerErrorNameEmpty => 'Introduce un nombre';

  @override
  String get playerErrorNameTooLong =>
      'El nombre es demasiado largo (máx. 32 caracteres)';

  @override
  String get setupTitle => 'Nueva partida';

  @override
  String get setupSelectPlayers => 'Selecciona jugadores';

  @override
  String setupPlayersRange(int min, int max) {
    return 'Elige de $min a $max jugadores';
  }

  @override
  String get setupEndMode => 'Condición de fin';

  @override
  String get setupEndModeScoreLimit => 'Límite de puntos';

  @override
  String get setupEndModeRounds => 'Número de rondas';

  @override
  String get setupEndModeFreeform => 'Juego libre';

  @override
  String get setupEndModeScoreLimitDesc =>
      'Gana el primero que alcance el umbral de puntos';

  @override
  String get setupEndModeRoundsDesc => 'Juega un número fijo de rondas';

  @override
  String get setupEndModeFreeformDesc =>
      'Termina la partida manualmente cuando quieras';

  @override
  String get setupScoreLimit => 'Umbral de puntos';

  @override
  String get setupRounds => 'Rondas';

  @override
  String get setupStartGame => 'Empezar partida';

  @override
  String setupNeedMorePlayers(int min) {
    return 'Selecciona al menos $min jugadores';
  }

  @override
  String gameRound(int number) {
    return 'Ronda $number';
  }

  @override
  String get gameYourTurn => 'TU TURNO';

  @override
  String get gameAddMove => 'Añadir jugada';

  @override
  String get gamePass => 'Pasar';

  @override
  String get gameEndHand => 'Mano vacía';

  @override
  String get gameRoundHistory => 'Esta ronda';

  @override
  String get gameNoMoves => 'Aún no hay jugadas';

  @override
  String get gameUndoLast => 'Deshacer última jugada';

  @override
  String gameLastMove(String points) {
    return 'última: $points';
  }

  @override
  String get gameFinish => 'Terminar partida';

  @override
  String get gameNextRound => 'Siguiente ronda';

  @override
  String inputTitle(String player) {
    return 'Jugada de $player';
  }

  @override
  String inputContext(int round, int move) {
    return 'Ronda $round · jugada n.º $move';
  }

  @override
  String get inputCorners => 'Valores de las esquinas de la ficha';

  @override
  String get inputBonuses => 'Bonificaciones (toca para añadir)';

  @override
  String get inputBonusTriplet => 'Triplete';

  @override
  String get inputBonusBridge => 'Puente';

  @override
  String get inputBonusHexagon => 'Hexágono';

  @override
  String get inputBonusDoubleHexagon => 'Hex doble';

  @override
  String get inputTripletDetected => 'Triplete detectado';

  @override
  String get inputSummary => 'Resumen';

  @override
  String get inputBase => 'Base';

  @override
  String get inputBonusLine => 'Bonificación';

  @override
  String get inputTotal => 'Total';

  @override
  String get inputConfirm => 'Confirmar';

  @override
  String get inputOtherActions => 'Otras acciones';

  @override
  String inputDrawPile(int penalty) {
    return 'Robar del montón ($penalty)';
  }

  @override
  String inputPassPenalty(int penalty) {
    return 'Pasar ($penalty)';
  }

  @override
  String get moveDraw => 'Robar';

  @override
  String get inputEndHand => 'Mano vacía (fin de ronda)';

  @override
  String get inputOpponentsHandSum => 'Suma de las manos rivales';

  @override
  String get inputOpponentsHandSumHint =>
      'Total de los dígitos en las manos de los rivales';

  @override
  String get summaryTitle => 'Fin de la partida';

  @override
  String summaryWinner(String name) {
    return '¡Gana $name!';
  }

  @override
  String get summaryScoreboard => 'Clasificación final';

  @override
  String get summaryRematch => 'Revancha';

  @override
  String get summaryHome => 'Inicio';

  @override
  String get summaryRoundsPlayed => 'Rondas jugadas';

  @override
  String get summaryDuration => 'Duración';

  @override
  String get historyTitle => 'Historial';

  @override
  String get historyEmpty => 'Aún no hay partidas terminadas';

  @override
  String historyWinner(String name) {
    return 'Ganador: $name';
  }

  @override
  String get statsTitle => 'Estadísticas';

  @override
  String get statsEmpty => 'Juega algunas partidas para ver estadísticas';

  @override
  String get statsTotalGames => 'Partidas jugadas';

  @override
  String get statsBestScore => 'Mejor puntuación';

  @override
  String get statsMostHexagons => 'Más hexágonos en una partida';

  @override
  String get rulesTitle => 'Reglas';

  @override
  String get onboardingSkip => 'Saltar';

  @override
  String get onboardingStart => 'Vamos';

  @override
  String get onb1Title => 'Bienvenido a TriominoScore';

  @override
  String get onb1Body =>
      'Tu asistente de puntuación profesional para el juego Triominos.';

  @override
  String get onb2Title => 'Smart Input';

  @override
  String get onb2Body =>
      'Introduce los tres dígitos de las esquinas y toca un bonus — listo.';

  @override
  String get onb3Title => 'Bonificaciones automáticas';

  @override
  String get onb3Body =>
      'La app calcula por ti los bonus de triplete, puente y hexágono.';

  @override
  String get onb4Title => 'Listo para jugar';

  @override
  String get onb4Body => 'Añade jugadores y empieza tu primera partida.';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSystem => 'Sistema';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Oscuro';

  @override
  String get settingsSounds => 'Efectos de sonido';

  @override
  String get settingsHaptics => 'Vibración';

  @override
  String get settingsDefaultScoreLimit => 'Umbral de puntos predeterminado';

  @override
  String get settingsAbout => 'Acerca de';

  @override
  String get settingsResetData => 'Restablecer todos los datos';

  @override
  String get settingsResetConfirm =>
      '¿Eliminar todas las partidas y jugadores? No se puede deshacer.';

  @override
  String settingsVersion(String version) {
    return 'Versión $version';
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
