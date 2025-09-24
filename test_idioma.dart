import 'dart:io';
import 'lib/app_text.dart';

void main() {
  print('=== TEST DE DETECCIÓN DE IDIOMA ===\n');

  // Verificar idioma actual del sistema
  print('🌍 Idioma del sistema: ${Platform.localeName}');

  // Mostrar qué idioma detecta AppText
  print('🤖 AppText detecta español: ${AppText.isSpanish}');

  print('\n📱 TRADUCCIONES ACTUALES:');
  print('• Juego: "${AppText.mathGame}"');
  print('• Pregunta: "${AppText.whatsTheResult}"');
  print('• Respuesta: "${AppText.yourAnswer}"');
  print('• Verificar: "${AppText.verify}"');
  print('• Premium: "${AppText.premiumFeature}"');
  print('• Ver Anuncio: "${AppText.watchAd}"');

  print('\n✅ RESULTADO:');
  if (AppText.isSpanish) {
    print('👉 Sistema configurado en ESPAÑOL');
    print('📱 La app muestra textos en español');
  } else {
    print('👉 Sistema configurado en INGLÉS');
    print('📱 La app muestra textos en inglés');
  }

  print('\n🔄 PARA CAMBIAR IDIOMA:');
  print('1. Ve a Configuración del dispositivo');
  print('2. Cambia el idioma');
  print('3. Reinicia la calculadora');
  print('4. Los textos cambiarán automáticamente');
}
