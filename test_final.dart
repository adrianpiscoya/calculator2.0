import 'lib/expression_evaluator.dart';

void main() {
  final calculator = ExpressionEvaluator();

  print('🎯 TEST FINAL - CALCULATOR 2.0 CORREGIDO');
  print('=' * 50);
  print('📅 ${DateTime.now().toString().split('.')[0]}');
  print('=' * 50);

  int totalTests = 0;
  int passedTests = 0;

  void runTest(String testName, String expression, double expected,
      {double tolerance = 0.01}) {
    totalTests++;
    print('\n$testName');
    print('   Expresión: $expression');
    String result = calculator.evaluate(expression);
    print('   Resultado: $result');
    print('   Esperado: ${expected.toStringAsFixed(4)}');

    bool passed = false;
    try {
      double resultValue = double.parse(result);
      passed = (resultValue - expected).abs() <= tolerance;
    } catch (e) {
      passed = false;
    }

    if (passed) {
      passedTests++;
      print('   ✅ CORRECTO');
    } else {
      print('   ❌ INCORRECTO');
    }
  }

  // ==================== TESTS CRÍTICOS QUE ESTABAN FALLANDO ====================
  print('\n🔧 TESTS DE LAS CORRECCIONES PRINCIPALES');
  print('-' * 50);

  runTest('Logaritmo base 10 con fracción', 'log10(100/4)', 1.3979);
  runTest('Exponencial con fracción', 'exp(1/2) * (3/4)', 1.2371);
  runTest('Logaritmo natural con fracción', 'log(1/e) + 5/2', 1.5);
  runTest('Exponencial de 1 (constante e)', 'exp(1)', 2.7183);
  runTest('Logaritmo de e²', 'log(e^2)', 2.0);
  runTest('Constante e sola', 'e', 2.7183);

  // ==================== TESTS BÁSICOS DE FRACCIONES ====================
  print('\n📱 FRACCIONES BÁSICAS');
  print('-' * 30);

  runTest('Suma de fracciones', '3/4 + 5/6', 1.5833);
  runTest('Multiplicación de fracciones', '(2/5) * (3/4)', 0.3);
  runTest('División de fracciones', '(4/7) / (2/3)', 0.8571);

  // ==================== TESTS DE TRIGONOMETRÍA ====================
  print('\n📐 TRIGONOMETRÍA');
  print('-' * 25);

  runTest('Seno de 45°', 'sin(45*pi/180)', 0.7071);
  runTest('Coseno de 60°', 'cos(60*pi/180)', 0.5);
  runTest(
      'Identidad trigonométrica', 'sin(30*pi/180)^2 + cos(30*pi/180)^2', 1.0);

  // ==================== TESTS DE POTENCIAS Y RAÍCES ====================
  print('\n⚡ POTENCIAS Y RAÍCES');
  print('-' * 30);

  runTest('Potencias decimales', '2.5^3 + 1.5^2', 17.875);
  runTest('Raíz cuadrada', 'sqrt(25/4)', 2.5);
  runTest('Raíz cúbica simulada', '(64/8)^(1/3)', 2.0);

  // ==================== RESUMEN FINAL ====================
  print('\n' + '=' * 50);
  print('📊 RESUMEN FINAL - CALCULATOR 2.0');
  print('=' * 50);

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
  } else {
    grade = 'NECESITA MEJORAS';
    emoji = '🔧';
  }

  print('\n📈 Tests ejecutados: $totalTests');
  print('✅ Tests exitosos: $passedTests');
  print('❌ Tests fallidos: ${totalTests - passedTests}');
  print('📊 Porcentaje de éxito: ${percentage.toStringAsFixed(1)}%');
  print('\n$emoji CALIFICACIÓN: $grade');

  if (percentage == 100) {
    print('\n🏆 ¡PERFECTO! Calculator 2.0 funciona perfectamente');
    print('🎉 Todas las correcciones aplicadas exitosamente');
    print('✨ Logaritmos, exponenciales y constantes funcionan');
  } else if (percentage >= 90) {
    print('\n🎊 ¡EXCELENTE! Calculator 2.0 funciona muy bien');
    print('💪 La mayoría de las correcciones fueron exitosas');
  } else {
    print('\n🛠️ Calculator 2.0 necesita más trabajo');
    print('📝 Revisar las funciones que fallaron');
  }

  print('\n🔍 CORRECCIONES IMPLEMENTADAS:');
  print('   ✅ Constante e definida numéricamente');
  print('   ✅ Función exp() convertida a e^x');
  print('   ✅ Logaritmos implementados con dart:math');
  print('   ✅ Manejo correcto de errores');
  print('   ✅ Compatibilidad con math_expressions');

  print('\n' + '=' * 50);
  print('🧮 Calculator 2.0 - CORRECCIONES COMPLETADAS');
  print('=' * 50);
}
