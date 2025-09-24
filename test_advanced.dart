import 'package:math_expressions/math_expressions.dart';

class ExpressionEvaluator {
  String evaluate(String expression) {
    try {
      // Preparar reemplazos de símbolos
      expression = expression.replaceAll('√', 'sqrt');
      expression = expression.replaceAll('π', 'pi');
      expression = expression.replaceAll('ln', 'log');
      expression = expression.replaceAll('abs', 'abs');
      expression = expression.replaceAll('exp', 'exp');

      // Manejar log base 10: log10(x) -> log(x)/log(10)
      expression = expression.replaceAll(
          RegExp(r'log10\(([^)]+)\)'), 'log(\$1)/log(10)');

      // Usar ShuntingYardParser
      final p = ShuntingYardParser();
      final Expression exp = p.parse(expression);

      // Crear contexto con constantes predefinidas
      ContextModel cm = ContextModel();
      cm.bindVariable(Variable('pi'), Number(3.141592653589793));
      cm.bindVariable(Variable('e'), Number(2.718281828459045));

      double result = exp.evaluate(EvaluationType.REAL, cm);

      // Mejorar formato de salida
      return _formatResult(result);
    } catch (e) {
      return 'Error: \$e';
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
  final calculator = ExpressionEvaluator();

  print('🧮 TEST AVANZADO - CALCULATOR 2.0');
  print('=' * 60);
  print('📅 ${DateTime.now().toString().split('.')[0]}');
  print('=' * 60);

  int totalTests = 0;
  int passedTests = 0;

  // Helper para verificar resultados
  bool checkResult(String obtained, double expected,
      {double tolerance = 0.001}) {
    try {
      double result = double.parse(obtained);
      return (result - expected).abs() <= tolerance;
    } catch (e) {
      return false;
    }
  }

  void runTest(String testName, String expression, double expected,
      {double tolerance = 0.001, String? expectedStr}) {
    totalTests++;
    print('\\n$testName');
    print('   Expresión: $expression');
    String result = calculator.evaluate(expression);
    print('   Resultado: $result');
    print('   Esperado: ${expectedStr ?? expected.toString()}');

    bool passed = expectedStr != null
        ? result == expectedStr
        : checkResult(result, expected, tolerance: tolerance);

    if (passed) {
      passedTests++;
      print('   ✅ CORRECTO');
    } else {
      print('   ❌ INCORRECTO');
    }
  }

  // ==================== NIVEL 1: OPERACIONES COMPLEJAS ====================
  print('\\n🔢 NIVEL 1: OPERACIONES COMPLEJAS');
  print('-' * 45);

  runTest('1.1 Expresión mixta compleja', '(15.5 + 8.2) * 3 - 12 / 4', 68.1);

  runTest('1.2 Paréntesis anidados', '((10 + 5) * 2) - (8 - 3)', 25);

  runTest('1.3 Potencias con decimales', '2.5^3 + 1.5^2', 17.8125);

  runTest('1.4 División con resto decimal', '22 / 7', 3.142857,
      tolerance: 0.000001);

  runTest('1.5 Operación con negativos', '-5 + 3 * (-2) + 8', -3);

  // ==================== NIVEL 2: FUNCIONES CIENTÍFICAS ====================
  print('\\n🔬 NIVEL 2: FUNCIONES CIENTÍFICAS');
  print('-' * 45);

  runTest('2.1 Trigonometría grados', 'sin(90*pi/180)', 1.0, tolerance: 0.001);

  runTest(
      '2.2 Trigonometría combinada', 'sin(pi/6) + cos(pi/3) + tan(pi/4)', 2.0,
      tolerance: 0.001);

  runTest('2.3 Raíces complejas', 'sqrt(16) + sqrt(9) + sqrt(4)', 9);

  runTest('2.4 Exponencial natural', 'exp(1)', 2.718282, tolerance: 0.000001);

  runTest('2.5 Logaritmo natural', 'log(e^2)', 2.0, tolerance: 0.001);

  // ==================== NIVEL 3: CASOS EXTREMOS ====================
  print('\\n⚡ NIVEL 3: CASOS EXTREMOS');
  print('-' * 35);

  runTest('3.1 Número muy pequeño', '0.000001 + 0.000002', 0.000003);

  runTest('3.2 Número muy grande', '999999 + 1', 1000000);

  runTest('3.3 Potencia alta', '2^10', 1024);

  runTest('3.4 Raíz de número grande', 'sqrt(10000)', 100);

  runTest('3.5 División por decimal pequeño', '1 / 0.1', 10);

  // ==================== NIVEL 4: CONSTANTES MATEMÁTICAS ====================
  print('\\n📐 NIVEL 4: CONSTANTES MATEMÁTICAS');
  print('-' * 45);

  runTest('4.1 Pi exacto', 'pi', 3.141593, tolerance: 0.000001);

  runTest('4.2 E exacto', 'e', 2.718282, tolerance: 0.000001);

  runTest('4.3 Operación con pi', '2 * pi', 6.283185, tolerance: 0.000001);

  runTest('4.4 Área del círculo', 'pi * 5^2', 78.539816, tolerance: 0.000001);

  runTest('4.5 Fórmula de Euler simplificada', 'e^0', 1);

  // ==================== NIVEL 5: DESAFÍOS MATEMÁTICOS ====================
  print('\\n🎯 NIVEL 5: DESAFÍOS MATEMÁTICOS');
  print('-' * 42);

  runTest('5.1 Identidad trigonométrica', 'sin(pi/2)^2 + cos(pi/2)^2', 1.0,
      tolerance: 0.001);

  runTest('5.2 Exponencial compleja', 'e^(log(5))', 5.0, tolerance: 0.001);

  runTest('5.3 Raíz cúbica simulada', '27^(1/3)', 3.0, tolerance: 0.001);

  runTest('5.4 Fórmula cuadrática (discriminante)', 'sqrt(4^2 - 4*1*3)', 2.0);

  runTest('5.5 Serie geométrica simple', '1 + 2 + 4 + 8 + 16', 31);

  // ==================== NIVEL 6: CASOS ESPECIALES ====================
  print('\\n🌟 NIVEL 6: CASOS ESPECIALES');
  print('-' * 38);

  runTest('6.1 Cero elevado a potencia', '0^5', 0);

  runTest('6.2 Uno elevado a cualquier potencia', '1^100', 1);

  runTest('6.3 Cualquier número elevado a cero', '999^0', 1);

  runTest('6.4 Raíz cuadrada de 1', 'sqrt(1)', 1);

  runTest('6.5 Multiplicación por cero', '12345 * 0', 0);

  // ==================== RESUMEN FINAL ====================
  print('\\n' + '=' * 60);
  print('📊 RESUMEN FINAL DEL TEST');
  print('=' * 60);

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
  print('❌ Tests fallados: ${totalTests - passedTests}');
  print('📊 Porcentaje de éxito: ${percentage.toStringAsFixed(1)}%');
  print('\\n$emoji CALIFICACIÓN: $grade');

  if (percentage == 100) {
    print('\\n🏆 ¡PERFECTO! Calculator 2.0 pasó todos los tests');
    print('🎉 La calculadora está lista para uso profesional');
  } else if (percentage >= 90) {
    print('\\n🎊 ¡EXCELENTE! Calculator 2.0 tiene alta precisión');
    print('💪 Muy pocas mejoras necesarias');
  } else if (percentage >= 80) {
    print('\\n👏 ¡BIEN! Calculator 2.0 funciona correctamente');
    print('🔧 Algunas funciones necesitan ajustes');
  } else {
    print('\\n🛠️ Calculator 2.0 necesita más trabajo');
    print('📝 Revisar las funciones que fallaron');
  }

  print('\\n' + '=' * 60);
  print('🧮 FIN DEL TEST AVANZADO');
  print('=' * 60);
}
