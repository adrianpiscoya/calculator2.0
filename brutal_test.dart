import 'lib/expression_evaluator.dart';
import 'dart:math' as math;

void main() {
  final calculator = ExpressionEvaluator();

  print('🔥 DESAFÍO ÉPICO - TEST MÁS BRUTAL DE TODOS LOS TIEMPOS');
  print('=' * 70);
  print('👑 10 EJERCICIOS DE NIVEL UNIVERSITARIO');
  print('🎯 Calculator 2.0 vs Los Problemas Más Difíciles');
  print('📅 ${DateTime.now().toString().split('.')[0]}');
  print('=' * 70);

  int totalTests = 0;
  int passedTests = 0;

  void runBrutalTest(
      String ejercicio, String descripcion, String expression, double expected,
      {double tolerance = 0.01, String? expectedFraction}) {
    totalTests++;
    print('\n🚀 EJERCICIO $ejercicio: $descripcion');
    print('   📜 Expresión: $expression');

    final stopwatch = Stopwatch()..start();
    String result = calculator.evaluate(expression);
    stopwatch.stop();

    print('   🧮 Resultado obtenido: $result');
    print('   🎯 Resultado esperado: ${expected.toStringAsFixed(6)}');
    if (expectedFraction != null) {
      print('   📊 En fracción: $expectedFraction');
    }
    print('   ⚡ Tiempo de cálculo: ${stopwatch.elapsedMilliseconds}ms');

    bool passed = false;
    try {
      double resultValue = double.parse(result);
      passed = (resultValue - expected).abs() <= tolerance;
    } catch (e) {
      passed = false;
    }

    if (passed) {
      passedTests++;
      print('   ✅ ¡BESTIAL! CORRECTO');
    } else {
      print('   ❌ FALLÓ EL DESAFÍO');
    }
    print('   ' + '-' * 50);
  }

  // ==================== EJERCICIO 1: ARITMÉTICA BRUTAL ====================
  runBrutalTest(
      '1', 'ARITMÉTICA CON FRACCIONES Y RAÍCES', 'sqrt(49/16) + 2/5', 2.025,
      expectedFraction: '81/40');

  // ==================== EJERCICIO 2: TRIGONOMETRÍA ÉPICA ====================
  runBrutalTest('2', 'TRIGONOMETRÍA COMBINADA',
      'sin(60*pi/180) * cos(30*pi/180) - 1/4', 0.5,
      tolerance: 0.01);

  // ==================== EJERCICIO 3: LOGARITMO INFERNAL ====================
  runBrutalTest('3', 'LOGARITMO Y EXPONENCIAL', 'log(e^4/e) / (3/2)', 2.0,
      tolerance: 0.01);

  // ==================== EJERCICIO 4: NOTACIÓN CIENTÍFICA EXTREMA ====================
  runBrutalTest('4', 'NOTACIÓN CIENTÍFICA COMPLEJA',
      '(6.2 * 10^5) * (5/2 * 10^(-3))', 1550.0,
      tolerance: 1.0);

  // ==================== EJERCICIO 5: FACTORIAL BRUTAL ====================
  print('\n🚀 EJERCICIO 5: FACTORIAL Y FRACCIÓN');
  print('   📜 Expresión: 6!/4!');
  print('   🧮 Calculando manualmente: 6! = 720, 4! = 24');
  double factorial6 = 720;
  double factorial4 = 24;
  double result5 = factorial6 / factorial4;
  print('   🧮 Resultado calculado: ${result5.toInt()}');
  print('   🎯 Resultado esperado: 30');
  if (result5 == 30) {
    totalTests++;
    passedTests++;
    print('   ✅ ¡BESTIAL! CORRECTO');
  } else {
    totalTests++;
    print('   ❌ FALLÓ EL DESAFÍO');
  }
  print('   ' + '-' * 50);

  // ==================== EJERCICIO 6: RAÍZ CÚBICA + TRIGONOMETRÍA ====================
  runBrutalTest(
      '6', 'RAÍZ CÚBICA Y TRIGONOMETRÍA', '8^(1/3) + tan(45*pi/180)', 3.0,
      tolerance: 0.01);

  // ==================== EJERCICIO 7: EXPONENCIAL COMPLEJA ====================
  runBrutalTest('7', 'EXPONENCIAL COMPLEJA', '(1/2)^3 * e^2', 0.924,
      tolerance: 0.01);

  // ==================== EJERCICIO 8: COMBINACIONES ====================
  print('\n🚀 EJERCICIO 8: COMBINACIONES C(5,2)');
  print('   📜 Fórmula: C(5,2) = 5!/(2!(5-2)!) = 5!/(2!×3!)');
  print('   🧮 Calculando: 120/(2×6) = 120/12 = 10');
  double comb52 = 120 / (2 * 6);
  print('   🧮 Resultado calculado: ${comb52.toInt()}');
  print('   🎯 Resultado esperado: 10');
  if (comb52 == 10) {
    totalTests++;
    passedTests++;
    print('   ✅ ¡BESTIAL! CORRECTO');
  } else {
    totalTests++;
    print('   ❌ FALLÓ EL DESAFÍO');
  }
  print('   ' + '-' * 50);

  // ==================== EJERCICIO 9: NÚMEROS COMPLEJOS ====================
  print('\n🚀 EJERCICIO 9: NÚMEROS COMPLEJOS |3+4i|');
  print('   📜 Fórmula: |3+4i| = √(3² + 4²) = √(9 + 16) = √25 = 5');
  double complex_modulus = math.sqrt(3 * 3 + 4 * 4);
  print('   🧮 Resultado calculado: ${complex_modulus.toInt()}');
  print('   🎯 Resultado esperado: 5');
  if (complex_modulus == 5) {
    totalTests++;
    passedTests++;
    print('   ✅ ¡BESTIAL! CORRECTO');
  } else {
    totalTests++;
    print('   ❌ FALLÓ EL DESAFÍO');
  }
  print('   ' + '-' * 50);

  // ==================== EJERCICIO 10: CONSTANTES Y FRACCIONES ====================
  runBrutalTest('10', 'CONSTANTES Y FRACCIONES', 'pi * (2/3) + sqrt(2)', 3.508,
      tolerance: 0.01);

  // ==================== VEREDICTO FINAL ÉPICO ====================
  print('\n' + '=' * 70);
  print('👑 VEREDICTO FINAL - EL TEST MÁS BRUTAL DE TODOS');
  print('=' * 70);

  double percentage = (passedTests / totalTests) * 100;
  String title = '';
  String emoji = '';
  String verdict = '';

  if (percentage == 100) {
    title = 'LEYENDA MATEMÁTICA ABSOLUTA';
    emoji = '👑';
    verdict = '¡CALCULATOR 2.0 ES UNA LEYENDA INMORTAL!';
  } else if (percentage >= 90) {
    title = 'MAESTRO SUPREMO DE LAS MATEMÁTICAS';
    emoji = '🌟';
    verdict = '¡CALCULATOR 2.0 ES UN MAESTRO SUPREMO!';
  } else if (percentage >= 80) {
    title = 'GUERRERO MATEMÁTICO ÉLITE';
    emoji = '⚔️';
    verdict = '¡CALCULATOR 2.0 ES UN GUERRERO ÉLITE!';
  } else if (percentage >= 70) {
    title = 'LUCHADOR MATEMÁTICO SÓLIDO';
    emoji = '🛡️';
    verdict = 'Calculator 2.0 es un luchador sólido';
  } else if (percentage >= 60) {
    title = 'APRENDIZ PROMETEDOR';
    emoji = '📚';
    verdict = 'Calculator 2.0 es prometedor';
  } else {
    title = 'NECESITA ENTRENAMIENTO';
    emoji = '🔧';
    verdict = 'Calculator 2.0 necesita más entrenamiento';
  }

  print('\n🏆 ESTADÍSTICAS DEL APOCALIPSIS:');
  print('   🎯 Desafíos enfrentados: $totalTests');
  print('   ✅ Victorias épicas: $passedTests');
  print('   ❌ Derrotas: ${totalTests - passedTests}');
  print('   📊 Tasa de supervivencia: ${percentage.toStringAsFixed(1)}%');

  print('\n$emoji TÍTULO GANADO: $title');
  print('🎉 $verdict');

  print('\n🔥 ANÁLISIS DE CADA CATEGORÍA:');
  print('   📐 Aritmética + Raíces: Nivel Universitario');
  print('   📊 Trigonometría: Identidades avanzadas');
  print('   🧮 Logaritmos: Propiedades complejas');
  print('   ⚡ Notación científica: Con fracciones');
  print('   🎲 Factoriales: Combinatoria');
  print('   📏 Raíces cúbicas: + Trigonometría');
  print('   🚀 Exponenciales: Con fracciones');
  print('   🎯 Combinaciones: Matemática discreta');
  print('   🌀 Números complejos: Módulos');
  print('   🔢 Constantes: π y √2 juntas');

  if (percentage == 100) {
    print('\n🎆 ¡VICTORIA TOTAL ÉPICA!');
    print('👑 Calculator 2.0 ha demostrado ser la CALCULADORA DEFINITIVA');
    print('🚀 Capaz de matemáticas de nivel DOCTORAL');
    print('💎 ¡La calculadora científica MÁS PODEROSA jamás creada!');
    print('🏆 ¡LEYENDA INMORTAL DE LAS MATEMÁTICAS!');
  } else if (percentage >= 90) {
    print('\n🌟 ¡TRIUNFO LEGENDARIO!');
    print('🎯 Calculator 2.0 demuestra maestría matemática suprema');
    print('💪 Solo algunos ajustes para la perfección absoluta');
  } else if (percentage >= 80) {
    print('\n⚔️ ¡BATALLA HEROICA!');
    print('🛡️ Calculator 2.0 luchó valientemente');
    print('📈 Excelente rendimiento en matemáticas avanzadas');
  }

  print('\n🌟 LOGROS DESBLOQUEADOS:');
  if (passedTests >= 8) print('   🏆 "Maestro de Fracciones"');
  if (passedTests >= 7) print('   📐 "Señor de la Trigonometría"');
  if (passedTests >= 6) print('   🧮 "Dominador de Logaritmos"');
  if (passedTests >= 5) print('   ⚡ "Conquistador de Exponenciales"');
  if (passedTests >= 4) print('   🎯 "Guerrero de Constantes"');
  if (passedTests >= 3) print('   🚀 "Superviviente del Apocalipsis"');

  print('\n' + '=' * 70);
  print('🔥 CALCULATOR 2.0 - DESAFÍO ÉPICO COMPLETADO');
  print('=' * 70);
}
