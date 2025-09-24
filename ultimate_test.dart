import 'lib/expression_evaluator.dart';

void main() {
  final calculator = ExpressionEvaluator();

  print('🏆 DESAFÍO FINAL - CALCULATOR 2.0 ULTIMATE TEST');
  print('=' * 65);
  print('🎯 El test más completo y desafiante');
  print('📅 ${DateTime.now().toString().split('.')[0]}');
  print('=' * 65);

  int totalTests = 0;
  int passedTests = 0;

  void runTest(
      String category, String testName, String expression, double expected,
      {double tolerance = 0.01}) {
    totalTests++;
    print('\n[$category] $testName');
    print('   🧮 Expresión: $expression');

    final stopwatch = Stopwatch()..start();
    String result = calculator.evaluate(expression);
    stopwatch.stop();

    print('   📊 Resultado: $result');
    print('   🎯 Esperado: ${expected.toStringAsFixed(6)}');
    print('   ⚡ Tiempo: ${stopwatch.elapsedMilliseconds}ms');

    bool passed = false;
    try {
      double resultValue = double.parse(result);
      passed = (resultValue - expected).abs() <= tolerance;
    } catch (e) {
      passed = false;
    }

    if (passed) {
      passedTests++;
      print('   ✅ PERFECTO');
    } else {
      print('   ❌ ERROR');
    }
  }

  // ==================== NIVEL 1: MAESTRÍA EXPONENCIAL ====================
  print('\n🚀 NIVEL 1: MAESTRÍA EXPONENCIAL');
  print('-' * 45);

  runTest('EXP', 'Exponencial clásica', 'exp(2)', 7.3891);
  runTest('EXP', 'Exponencial con fracción', 'exp(3/2)', 4.4817);
  runTest('EXP', 'Exponencial negativa', 'exp(-1)', 0.3679);
  runTest('EXP', 'Exponencial con pi', 'exp(pi/4)', 2.1933);
  runTest('EXP', 'Exponencial compuesta', 'exp(1) + exp(0)', 3.7183);

  // ==================== NIVEL 2: DOMINIO LOGARÍTMICO ====================
  print('\n📊 NIVEL 2: DOMINIO LOGARÍTMICO');
  print('-' * 45);

  runTest('LOG', 'Log natural de e', 'log(e)', 1.0);
  runTest('LOG', 'Log base 10 clásico', 'log10(1000)', 3.0);
  runTest('LOG', 'Log de fracción', 'log(1/e^2)', -2.0);
  runTest('LOG', 'Log base 10 con decimales', 'log10(3.16)', 0.5,
      tolerance: 0.05);
  runTest('LOG', 'Cambio de base', 'log10(e^3)', 1.3026);

  // ==================== NIVEL 3: CONSTANTES SUPREMAS ====================
  print('\n🌟 NIVEL 3: CONSTANTES SUPREMAS');
  print('-' * 45);

  runTest('CONST', 'Euler solo', 'e', 2.7183);
  runTest('CONST', 'Pi solo', 'pi', 3.1416);
  runTest('CONST', 'e × pi', 'e * pi', 8.5397);
  runTest('CONST', 'e^pi (Gelfond)', 'e^pi', 23.1407, tolerance: 0.1);
  runTest('CONST', 'pi^e (Gelfond)', 'pi^e', 22.4592, tolerance: 0.1);

  // ==================== NIVEL 4: TRIGONOMETRÍA ÉPICA ====================
  print('\n📐 NIVEL 4: TRIGONOMETRÍA ÉPICA');
  print('-' * 45);

  runTest('TRIG', 'Identidad de Euler', 'sin(pi/6)^2 + cos(pi/6)^2', 1.0);
  runTest('TRIG', 'Tangente extrema', 'tan(pi/3)', 1.7321);
  runTest('TRIG', 'Seno de pi/2', 'sin(pi/2)', 1.0);
  runTest('TRIG', 'Coseno de pi', 'cos(pi)', -1.0);
  runTest('TRIG', 'Fórmula del ángulo doble', '2*sin(pi/8)*cos(pi/8)', 0.7071);

  // ==================== NIVEL 5: FRACCIONES INFERNALES ====================
  print('\n🔥 NIVEL 5: FRACCIONES INFERNALES');
  print('-' * 45);

  runTest('FRAC', 'Fracción gigante', '(1000/7) / (13/11)', 122.3776);
  runTest('FRAC', 'Fracción con raíz', 'sqrt(169/144)', 1.0833);
  runTest('FRAC', 'Fracción exponencial', '(3/4)^5', 0.2373);
  runTest('FRAC', 'Fracción logarítmica', 'log10(100/9)', 1.0458);
  runTest('FRAC', 'Fracción trigonométrica', 'sin(pi/6) / (1/2)', 1.0);

  // ==================== NIVEL 6: OPERACIONES COMPLEJAS ====================
  print('\n⚡ NIVEL 6: OPERACIONES COMPLEJAS');
  print('-' * 45);

  runTest('COMP', 'Raíz n-ésima', '32^(1/5)', 2.0);
  runTest('COMP', 'Potencia decimal', '2.5^3.5', 9.8821);
  runTest('COMP', 'Operación mixta', '(log10(100) + exp(0)) / sqrt(9)', 1.6667);
  runTest('COMP', 'Expresión anidada', 'sqrt(exp(2*log(4)))', 4.0);
  runTest(
      'COMP', 'Fórmula cuadrática', '(-1 + sqrt(1 + 4*2*3)) / (2*2)', 1.3708);

  // ==================== NIVEL 7: DESAFÍO SUPREMO ====================
  print('\n👑 NIVEL 7: DESAFÍO SUPREMO');
  print('-' * 45);

  runTest('SUPREME', 'Número de Euler-Mascheroni aproximado',
      'log(exp(1)) - 1 + 1/2', 0.5);
  runTest('SUPREME', 'Aproximación de pi/4', 'sin(pi/4) * cos(pi/4)', 0.5);
  runTest('SUPREME', 'Fórmula de Stirling simplificada', 'sqrt(2*pi) * exp(-1)',
      1.0844);
  runTest('SUPREME', 'Relación dorada', '(1 + sqrt(5)) / 2', 1.618);
  runTest('SUPREME', 'Constante de Euler', 'exp(log(e))', 2.7183);

  // ==================== RESUMEN ÉPICO ====================
  print('\n' + '=' * 65);
  print('🏆 RESUMEN ÉPICO DEL DESAFÍO FINAL');
  print('=' * 65);

  double percentage = (passedTests / totalTests) * 100;
  String grade = '';
  String emoji = '';
  String message = '';

  if (percentage == 100) {
    grade = 'LEYENDA MATEMÁTICA';
    emoji = '👑';
    message = '¡CALCULATOR 2.0 ES UNA LEYENDA ABSOLUTA!';
  } else if (percentage >= 95) {
    grade = 'MAESTRO SUPREMO';
    emoji = '🌟';
    message = '¡CALCULATOR 2.0 ES UN MAESTRO SUPREMO!';
  } else if (percentage >= 90) {
    grade = 'GENIO MATEMÁTICO';
    emoji = '🧠';
    message = '¡CALCULATOR 2.0 ES UN GENIO!';
  } else if (percentage >= 80) {
    grade = 'EXPERTO AVANZADO';
    emoji = '🎯';
    message = '¡CALCULATOR 2.0 ES UN EXPERTO!';
  } else if (percentage >= 70) {
    grade = 'COMPETENTE';
    emoji = '👍';
    message = 'Calculator 2.0 es competente';
  } else {
    grade = 'NECESITA ENTRENAMIENTO';
    emoji = '🔧';
    message = 'Calculator 2.0 necesita más entrenamiento';
  }

  print('\n📊 ESTADÍSTICAS FINALES:');
  print('   🧮 Tests ejecutados: $totalTests');
  print('   ✅ Tests exitosos: $passedTests');
  print('   ❌ Tests fallidos: ${totalTests - passedTests}');
  print('   📈 Porcentaje de éxito: ${percentage.toStringAsFixed(1)}%');
  print('\n$emoji RANGO FINAL: $grade');
  print('🎉 $message');

  // Análisis por categoría
  print('\n📋 ANÁLISIS POR CATEGORÍA:');
  print('   🚀 Exponenciales: 5 tests');
  print('   📊 Logaritmos: 5 tests');
  print('   🌟 Constantes: 5 tests');
  print('   📐 Trigonometría: 5 tests');
  print('   🔥 Fracciones: 5 tests');
  print('   ⚡ Operaciones complejas: 5 tests');
  print('   👑 Desafío supremo: 5 tests');

  if (percentage == 100) {
    print('\n🎆 ¡VICTORIA TOTAL!');
    print(
        '🏆 Calculator 2.0 ha demostrado ser una calculadora científica PERFECTA');
    print('🚀 Capaz de manejar matemáticas de nivel universitario');
    print('💎 ¡Un verdadero diamante de la programación!');
  } else if (percentage >= 90) {
    print('\n🎊 ¡VICTORIA IMPRESIONANTE!');
    print('🌟 Calculator 2.0 demuestra excelencia matemática');
    print('🎯 Solo pequeños ajustes para la perfección total');
  }

  print('\n🔍 CAPACIDADES DEMOSTRADAS:');
  print('   ✨ Exponenciales complejas con fracciones');
  print('   📊 Logaritmos naturales y base 10');
  print('   🎯 Constantes matemáticas fundamentales');
  print('   📐 Trigonometría avanzada');
  print('   🔥 Fracciones complejas y anidadas');
  print('   ⚡ Operaciones multi-nivel');
  print('   👑 Fórmulas matemáticas clásicas');

  print('\n' + '=' * 65);
  print('👑 CALCULATOR 2.0 - DESAFÍO FINAL COMPLETADO');
  print('=' * 65);
}
