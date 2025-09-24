import 'dart:io';

// 🌍 SISTEMA DE TRADUCCIÓN ULTRA OPTIMIZADO - ACCESO EFICIENTE
class AppText {
  // Cache estático para máxima eficiencia
  static bool? _cachedIsSpanish;

  static bool get isSpanish {
    // Solo acceder a Platform.localeName si no está cacheado
    if (_cachedIsSpanish == null) {
      _cachedIsSpanish = Platform.localeName.startsWith('es');
    }
    return _cachedIsSpanish!;
  }

  // Método para forzar recarga del idioma (usar solo cuando cambie el idioma del sistema)
  static void resetLanguageCache() {
    _cachedIsSpanish = null;
  }

  static String get whatsTheResult =>
      isSpanish ? '¿Cuánto es?' : "What's the result?";

  static String get yourAnswer => isSpanish ? 'Tu respuesta' : 'Your answer';

  static String get verify => isSpanish ? 'Verificar' : 'Verify';

  static String get introduceAnswer =>
      isSpanish ? 'Introduce una respuesta' : 'Enter an answer';

  static String get invalidAnswer =>
      isSpanish ? 'Respuesta inválida' : 'Invalid answer';

  static String get mathGame => isSpanish ? 'Juego Matemático' : 'Math Game';

  static String get statistics => isSpanish ? 'Estadísticas' : 'Statistics';

  static String get noDataToSave =>
      isSpanish ? 'No hay datos para guardar' : 'No data to save';

  static String get datasetSaved =>
      isSpanish ? 'Dataset guardado' : 'Dataset saved';

  static String get couldNotSave =>
      isSpanish ? 'No se pudo guardar' : 'Could not save';

  static String get close => isSpanish ? 'Cerrar' : 'Close';

  static String get historyDeleted =>
      isSpanish ? 'Historial eliminado' : 'History deleted';

  static String get deleteAll => isSpanish ? 'Borrar todo' : 'Delete all';

  static String get gameOver => isSpanish ? 'Juego Terminado' : 'Game Over';

  static String get score => isSpanish ? 'Puntaje' : 'Score';

  static String get restart => isSpanish ? 'Reiniciar' : 'Restart';

  static String get exit => isSpanish ? 'Salir' : 'Exit';

  static String get cancel => isSpanish ? 'Cancelar' : 'Cancel';

  static String get watchAd => isSpanish ? 'Ver anuncio 📺' : 'Watch ad 📺';

  static String get premiumFeature =>
      isSpanish ? '🎁 Función Premium' : '🎁 Premium Feature';

  static String get watchAdMessage => isSpanish
      ? 'Para acceder a esta función avanzada, mira un breve anuncio de recompensa.\n\n¡Es gratis y nos ayuda a mantener la app!'
      : 'To access this advanced feature, watch a short reward ad.\n\nIt\'s free and helps us maintain the app!';

  static String get helpAndSupport =>
      isSpanish ? 'Ayuda y Soporte' : 'Help and Support';

  static String get sendSuggestions =>
      isSpanish ? 'Enviar Sugerencias' : 'Send Suggestions';

  static String get reportProblem =>
      isSpanish ? 'Reportar Problema' : 'Report Problem';

  static String get rateApp => isSpanish ? 'Calificar App' : 'Rate App';

  static String get history => isSpanish ? 'Historial' : 'History';

  static String get clearAll => isSpanish ? 'Limpiar Todo' : 'Clear All';

  static String get clearExpressionAndHistory => isSpanish
      ? 'Borrar expresión e historial'
      : 'Clear expression and history';

  static String get about => isSpanish ? 'Acerca de' : 'About';

  static String get advancedCalculator =>
      isSpanish ? 'Calculadora Avanzada' : 'Advanced Calculator';

  static String get scientificCalculator => isSpanish
      ? 'Calculadora Científica Avanzada'
      : 'Advanced Scientific Calculator';

  static String get version => isSpanish ? 'Versión' : 'Version';

  static String get features => isSpanish ? 'Características' : 'Features';

  static String get basicOperations => isSpanish
      ? '• Operaciones básicas y científicas'
      : '• Basic and scientific operations';

  static String get fractionHandling =>
      isSpanish ? '• Manejo de fracciones' : '• Fraction handling';

  static String get mathConstants =>
      isSpanish ? '• Constantes matemáticas' : '• Mathematical constants';

  static String get trigFunctions =>
      isSpanish ? '• Funciones trigonométricas' : '• Trigonometric functions';

  static String get calculationHistory =>
      isSpanish ? '• Historial de cálculos' : '• Calculation history';

  static String get inputModes =>
      isSpanish ? '• Múltiples modos de entrada' : '• Multiple input modes';

  static String get calculations => isSpanish ? 'cálculos' : 'calculations';

  static String get searchInPlayStore => isSpanish
      ? '🔍 Busca "Advanced Calculator" en Play Store'
      : '🔍 Search "Advanced Calculator" in Play Store';

  static String get searchInPlayStoreToRate => isSpanish
      ? '🔍 Busca "Advanced Calculator" en Play Store para calificarnos'
      : '🔍 Search "Advanced Calculator" in Play Store to rate us';

  static String get discoverAdvancedCalculator => isSpanish
      ? '🧮 ¡Descubre Advanced Calculator!'
      : '🧮 Discover Advanced Calculator!';

  static String get mostCompleteScientificCalculator => isSpanish
      ? '✨ La calculadora científica más completa:'
      : '✨ The most complete scientific calculator:';

  static String get trigAndLogFunctions => isSpanish
      ? '• Funciones trigonométricas y logarítmicas'
      : '• Trigonometric and logarithmic functions';

  static String get functionGraphs => isSpanish
      ? '• Gráficos de funciones matemáticas'
      : '• Mathematical function graphs';

  static String get completeUnitConverter => isSpanish
      ? '• Conversor de unidades completo'
      : '• Complete unit converter';

  static String get statisticsAndDataAnalysis => isSpanish
      ? '• Estadísticas y análisis de datos'
      : '• Statistics and data analysis';

  static String get educationalMathGames => isSpanish
      ? '• Juegos matemáticos educativos'
      : '• Educational math games';

  static String get professionalAndModernInterface => isSpanish
      ? '• Interfaz profesional y moderna'
      : '• Professional and modern interface';

  static String get downloadFree =>
      isSpanish ? 'Descárgala gratis' : 'Download for free';

  static String get errorSharingApp =>
      isSpanish ? '❌ Error al compartir la app' : '❌ Error sharing the app';

  static String get basic => isSpanish ? 'Básico' : 'Basic';

  static String get trigonometric =>
      isSpanish ? 'Trigonométrico' : 'Trigonometric';

  static String get advanced => isSpanish ? 'Avanzado' : 'Advanced';

  static String get constants => isSpanish ? 'Constantes' : 'Constants';

  static String get fractions => isSpanish ? 'Fracciones' : 'Fractions';

  static String get squareRoot => isSpanish ? 'Raíz Cuadrada' : 'Square Root';

  static String get pi => isSpanish ? 'Pi (π)' : 'Pi (π)';

  static String get numberE => isSpanish ? 'Número e' : 'Number e';

  static String get decimalToFraction =>
      isSpanish ? 'Decimal ↔ Fracción' : 'Decimal ↔ Fraction';

  static String get convertBetweenFormats =>
      isSpanish ? 'Convertir entre formatos' : 'Convert between formats';

  static String get cannotConvert =>
      isSpanish ? 'No se puede convertir' : 'Cannot convert';

  static String get angleMode => isSpanish ? 'Modo Ángulo' : 'Angle Mode';

  static String get format => isSpanish ? 'Formato' : 'Format';

  static String get shareApp => isSpanish ? 'Compartir App' : 'Share App';

  static String get savedDatasets =>
      isSpanish ? 'Datasets guardados' : 'Saved datasets';

  static String get noSavedDatasets =>
      isSpanish ? 'No hay datasets guardados' : 'No saved datasets';

  static String get errorSharing =>
      isSpanish ? 'Error al compartir' : 'Error sharing';

  static String get functionGraph =>
      isSpanish ? 'Gráfico de Funciones' : 'Function Graph';

  static String get dataAnalysis =>
      isSpanish ? 'Análisis de datos' : 'Data analysis';

  static String get visualizeEquations =>
      isSpanish ? 'Visualizar ecuaciones' : 'Visualize equations';

  static String get measuresCurrenciesEtc =>
      isSpanish ? 'Medidas, monedas, etc.' : 'Measures, currencies, etc.';

  static String get currencyConversion =>
      isSpanish ? 'Conversión de monedas' : 'Currency conversion';

  static String get guessTheNumber =>
      isSpanish ? 'Adivina el número' : 'Guess the number';

  static String get solveEquations =>
      isSpanish ? 'Resuelve ecuaciones' : 'Solve equations';

  static String get howToUseCalculator =>
      isSpanish ? 'Cómo usar la calculadora' : 'How to use the calculator';

  static String get sendFeedback =>
      isSpanish ? 'Enviar comentarios' : 'Send feedback';

  static String get rateUsOnPlayStore =>
      isSpanish ? 'Valóranos en Play Store' : 'Rate us on Play Store';

  static String get recommendToFriends =>
      isSpanish ? 'Recomienda a tus amigos' : 'Recommend to friends';

  static String get allCleared => isSpanish ? 'Todo limpiado' : 'All cleared';

  static String get modes => isSpanish ? 'MODOS' : 'MODES';

  static String get pressBackAgainToExit => isSpanish
      ? 'Presiona atrás una vez más para salir'
      : 'Press back again to exit';
}
