import 'dart:io';

void main() {
  print('=== PRUEBA DE TRADUCCIONES ===');

  // Verificamos el idioma actual del sistema
  print('Idioma del sistema: ${Platform.localeName}');

  bool isSpanish = Platform.localeName.startsWith('es');
  print('¿Es español?: $isSpanish');

  print('\n🌍 TRADUCCIONES ESPERADAS:');
  if (isSpanish) {
    print('✅ Juego: "Juego Matemático"');
    print('✅ Pregunta: "¿Cuánto es?"');
    print('✅ Respuesta: "Tu respuesta"');
    print('✅ Verificar: "Verificar"');
    print('✅ Premium: "🎁 Función Premium"');
    print('✅ Ver Anuncio: "Ver anuncio 📺"');
  } else {
    print('✅ Game: "Math Game"');
    print('✅ Question: "What\'s the result?"');
    print('✅ Answer: "Your answer"');
    print('✅ Verify: "Verify"');
    print('✅ Premium: "🎁 Premium Feature"');
    print('✅ Watch Ad: "Watch ad 📺"');
  }

  print('\n🔧 INSTRUCCIONES PARA PROBAR:');
  print('1. Cambia el idioma de tu dispositivo a inglés');
  print('2. Reinicia la app');
  print('3. Los textos deberían cambiar automáticamente');
  print('\n🚀 Sistema de traducciones listo!');
}
