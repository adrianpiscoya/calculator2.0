// Archivo de pruebas de fracciones para Calculator 2.0

class TestExpressionEvaluator {
  String evaluate(String expression) {
    try {
      // Aquí irá la lógica de evaluación cuando se implemente
      // Por ahora, una implementación básica
      return 'Resultado de: $expression';
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  // Mejorar formato de números
  String _formatResult(double result) {
    // Si es un entero, mostrarlo sin decimales
    if (result == result.roundToDouble()) {
      return result.round().toString();
    }

    // Si tiene pocos decimales significativos, mostrar hasta 6 decimales
    String formatted = result.toStringAsFixed(6);

    // Eliminar ceros innecesarios al final
    formatted = formatted.replaceAll(RegExp(r'\.?0+\$'), '');

    // Si el resultado es muy pequeño, usar notación científica
    if (result.abs() < 0.000001 && result != 0) {
      return result.toStringAsExponential(3);
    }

    // Si el resultado es muy grande, usar notación científica
    if (result.abs() > 1000000) {
      return result.toStringAsExponential(3);
    }

    return formatted;
  }
}

void main() {
  final calculator = TestExpressionEvaluator();

  print('🧮 TEST DE FRACCIONES Y TRIGONOMETRÍA - CALCULATOR 2.0');
  print('=' * 65);
  print('📅 ${DateTime.now().toString().split('.')[0]}');
  print('=' * 65);

  int totalTests = 0;
  int passedTests = 0;

  // Helper para verificar resultados
  bool checkResult(String obtained, double expected,
      {double tolerance = 0.01}) {
    try {
      double result = double.parse(obtained);
      return (result - expected).abs() <= tolerance;
    } catch (e) {
      return false;
    }
  }

  void runTest(String testName, String expression, double expected,
      {double tolerance = 0.01}) {
    totalTests++;
    print('\\n$testName');
    print('   Expresión: $expression');
    String result = calculator.evaluate(expression);
    print('   Resultado: $result');
    print('   Esperado: ${expected.toStringAsFixed(4)}');

    bool passed = checkResult(result, expected, tolerance: tolerance);

    if (passed) {
      passedTests++;
      print('   ✅ CORRECTO');
    } else {
      print('   ❌ INCORRECTO');
    }
  }

  // ==================== MODO BÁSICO CON FRACCIONES ====================
  print('\\n📱 MODO BÁSICO - FRACCIONES');
  print('-' * 40);

  runTest('1.1 Suma de fracciones: 3/4 + 5/6', '3/4 + 5/6', 1.5833);

  runTest('1.2 Resta de fracciones: 7/8 - 1/3', '7/8 - 1/3', 0.5417);

  runTest('1.3 Multiplicación de fracciones: 2/5 × 3/4', '(2/5) * (3/4)', 0.3);

  runTest('1.4 División de fracciones: 4/7 ÷ 2/3', '(4/7) / (2/3)', 0.8571);

  runTest('1.5 Raíz cuadrada de fracción: √(25/4)', 'sqrt(25/4)', 2.5);

  // ==================== MODO CIENTÍFICO CON FRACCIONES ====================
  print('\\n🔬 MODO CIENTÍFICO - FRACCIONES Y TRIGONOMETRÍA');
  print('-' * 55);

  runTest('2.1 Fracciones y trigonometría: sin(45°) × 2/3',
      'sin(45*pi/180) * (2/3)', 0.4714);

  runTest('2.2 Logaritmo con fracción: log10(100/4)', 'log10(100/4)', 1.3979);

  runTest(
      '2.3 Exponencial y fracción: e^(1/2) × 3/4', 'exp(1/2) * (3/4)', 1.2371);

  runTest('2.4 Notación científica con fracción: (5×10³) ÷ (2/5)',
      '(5*10^3) / (2/5)', 12500);

  runTest('2.5 Raíz cúbica y fracción: ∛(64/8)', '(64/8)^(1/3)', 2.0);

  runTest(
      '2.6 Coseno y fracción: cos(60°) ÷ (1/3)', 'cos(60*pi/180) / (1/3)', 1.5);

  runTest('2.7 Logaritmo natural con fracción: ln(1/e) + 5/2', 'log(1/e) + 5/2',
      1.5);

  runTest('2.8 Potencia con fracción: (3/2)³', '(3/2)^3', 3.375);

  runTest('2.9 Tangente y fracción: tan(30°) × 4/5', 'tan(30*pi/180) * (4/5)',
      0.4619);

  runTest('2.10 Combinación compleja: [sin(90°) + cos(0°)] ÷ (2/3)',
      '(sin(90*pi/180) + cos(0*pi/180)) / (2/3)', 3.0);

  // ==================== PRUEBAS ADICIONALES DE FRACCIONES ====================
  print('\\n🧪 PRUEBAS ADICIONALES - CASOS ESPECIALES');
  print('-' * 50);

  runTest('3.1 Fracción impropia: 7/3', '7/3', 2.3333);

  runTest('3.2 Fracción con números grandes: 1000/8', '1000/8', 125);

  runTest('3.3 Fracción muy pequeña: 1/1000', '1/1000', 0.001);

  runTest('3.4 Operación mixta: 1.5 + 3/4', '1.5 + 3/4', 2.25);

  runTest(
      '3.5 Fracción en paréntesis: 2 * (3/4 + 1/4)', '2 * (3/4 + 1/4)', 2.0);

  // ==================== TRIGONOMETRÍA AVANZADA ====================
  print('\\n📐 TRIGONOMETRÍA AVANZADA');
  print('-' * 35);

  runTest('4.1 Identidad fundamental: sin²(30°) + cos²(30°)',
      'sin(30*pi/180)^2 + cos(30*pi/180)^2', 1.0);

  runTest('4.2 Tangente como razón: sin(45°)/cos(45°)',
      'sin(45*pi/180) / cos(45*pi/180)', 1.0);

  runTest('4.3 Ángulo de 0°: sin(0°)', 'sin(0*pi/180)', 0.0, tolerance: 0.001);

  runTest('4.4 Ángulo de 180°: cos(180°)', 'cos(180*pi/180)', -1.0);

  runTest('4.5 Radianes directos: sin(π/2)', 'sin(pi/2)', 1.0);

  // ==================== RESUMEN FINAL ====================
  print('\\n' + '=' * 65);
  print('📊 RESUMEN FINAL - TEST DE FRACCIONES');
  print('=' * 65);

  double percentage = (passedTests / totalTests) * 100;
  String grade = '';
  String emoji = '';

  if (percentage >= 95) {
    grade = 'EXCELENTE';
    emoji = '🌟';
  } else if (percentage >= 85) {
    grade = 'MUY BUENO';
    emoji = '🎯';
  } else if (percentage >= 75) {
    grade = 'BUENO';
    emoji = '👍';
  } else if (percentage >= 60) {
    grade = 'REGULAR';
    emoji = '⚠️';
  } else {
    grade = 'NECESITA MEJORAS';
    emoji = '🔧';
  }

  print('\\n📈 Tests ejecutados: $totalTests');
  print('✅ Tests exitosos: $passedTests');
  print('❌ Tests fallidos: ${totalTests - passedTests}');
  print('📊 Porcentaje de éxito: ${percentage.toStringAsFixed(1)}%');
  print('\\n$emoji CALIFICACIÓN: $grade');

  // Análisis detallado por categoría
  print('\\n📋 ANÁLISIS POR CATEGORÍA:');
  print('   📱 Fracciones básicas: 5 tests');
  print('   🔬 Científico + fracciones: 10 tests');
  print('   🧪 Casos especiales: 5 tests');
  print('   📐 Trigonometría avanzada: 5 tests');

  if (percentage == 100) {
    print('\\n🏆 ¡PERFECTO! Calculator 2.0 maneja fracciones perfectamente');
    print('🎉 Excelente soporte para matemáticas avanzadas');
  } else if (percentage >= 90) {
    print('\\n🎊 ¡EXCELENTE! Muy buen manejo de fracciones');
    print('💪 Casi todas las operaciones complejas funcionan');
  } else if (percentage >= 80) {
    print('\\n👏 ¡BIEN! Buen soporte básico de fracciones');
    print('🔧 Algunas funciones científicas necesitan ajuste');
  } else {
    print('\\n🛠️ El manejo de fracciones necesita trabajo');
    print('📝 Revisar las operaciones que fallaron');
  }

  print('\\n🔍 FUNCIONES CLAVE EVALUADAS:');
  print('   • Operaciones básicas con fracciones');
  print('   • Trigonometría en grados y radianes');
  print('   • Logaritmos base 10 y naturales');
  print('   • Exponenciales y raíces');
  print('   • Notación científica');
  print('   • Combinaciones complejas');

  print('\\n' + '=' * 65);
  print('🧮 FIN DEL TEST DE FRACCIONES');
  print('=' * 65);
}
