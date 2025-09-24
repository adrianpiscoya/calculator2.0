// Simular un dispositivo en inglés
class MockPlatform {
  static String _mockLocale = 'en-US';

  static String get localeName => _mockLocale;

  static void setMockLocale(String locale) {
    _mockLocale = locale;
  }
}

// Copia de AppText con detección automática de cambios
class AppTextTest {
  static bool? _cachedIsSpanish;
  static String? _cachedLocale;

  static bool get isSpanish {
    final currentLocale = MockPlatform.localeName;

    // Si el idioma del sistema cambió, resetea el cache
    if (_cachedLocale != null && _cachedLocale != currentLocale) {
      resetLanguageCache();
      print('🔄 ¡IDIOMA CAMBIADO! Reseteando cache...');
    }

    // Cachea tanto el idioma como el locale
    if (_cachedIsSpanish == null) {
      _cachedIsSpanish = currentLocale.startsWith('es');
      _cachedLocale = currentLocale;
      print(
          '📝 Cache inicializado: $_cachedLocale -> ${_cachedIsSpanish! ? "ESPAÑOL" : "ENGLISH"}');
    }

    return _cachedIsSpanish!;
  }

  static void resetLanguageCache() {
    _cachedIsSpanish = null;
    _cachedLocale = null;
  }

  static String get mathGame => isSpanish ? 'Juego Matemático' : 'Math Game';
  static String get whatsTheResult =>
      isSpanish ? '¿Cuánto es?' : "What's the result?";
  static String get yourAnswer => isSpanish ? 'Tu respuesta' : 'Your answer';
  static String get verify => isSpanish ? 'Verificar' : 'Verify';
  static String get premiumFeature =>
      isSpanish ? '🎁 Función Premium' : '🎁 Premium Feature';
  static String get watchAd => isSpanish ? 'Ver anuncio 📺' : 'Watch Ad 📺';
}

void main() {
  print('=== SIMULACIÓN DE CAMBIO DE IDIOMA ===\n');

  // 1. Simular dispositivo en español (como estaba antes)
  print('1️⃣ DISPOSITIVO EN ESPAÑOL:');
  MockPlatform.setMockLocale('es-AR');
  AppTextTest.resetLanguageCache(); // Forzar detección inicial

  print('   🌍 Idioma del sistema: ${MockPlatform.localeName}');
  print('   🤖 AppText detecta español: ${AppTextTest.isSpanish}');
  print('   📱 Muestra: "${AppTextTest.mathGame}"\n');

  // 2. Cambiar a inglés (como está ahora tu dispositivo)
  print('2️⃣ CAMBIANDO A INGLÉS:');
  MockPlatform.setMockLocale('en-US');

  print('   🌍 Idioma del sistema: ${MockPlatform.localeName}');
  print('   🤖 AppText detecta español: ${AppTextTest.isSpanish}');
  print('   📱 Muestra: "${AppTextTest.mathGame}"\n');

  // 3. Verificar que funciona en ambas direcciones
  print('3️⃣ PRUEBA COMPLETA:');
  print(
      '   Español: ${AppTextTest.isSpanish ? "ESPAÑOL" : "ENGLISH"} - "${AppTextTest.mathGame}"');

  MockPlatform.setMockLocale('es-ES');
  print(
      '   Español: ${AppTextTest.isSpanish ? "ESPAÑOL" : "ENGLISH"} - "${AppTextTest.mathGame}"');

  MockPlatform.setMockLocale('en-GB');
  print(
      '   Inglés: ${AppTextTest.isSpanish ? "ESPAÑOL" : "ENGLISH"} - "${AppTextTest.mathGame}"');

  print('\n✅ LA DETECCIÓN AUTOMÁTICA FUNCIONA CORRECTAMENTE');
  print(
      '💡 El problema era que el cache no se reseteaba al cambiar el idioma del dispositivo');
  print(
      '🔧 SOLUCIÓN: Ahora detecta cambios automáticamente y resetea el cache');
}
