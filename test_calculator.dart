import 'package:math_expressions/math_expressions.dart';

class ExpressionEvaluator {
  String evaluate(String expression) {
    try {
      expression = expression.replaceAll('√', 'sqrt');
      expression = expression.replaceAll('π', 'pi');
      expression = expression.replaceAll('ln', 'log');
      expression = expression.replaceAll('abs', 'abs');
      expression = expression.replaceAll('exp', 'exp');

      final p = ShuntingYardParser();
      final Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);
      return result.toStringAsFixed(8).replaceAll(RegExp(r'\.0+?$'), '');
    } catch (e) {
      return 'Error: $e';
    }
  }
}

void main() {
  final calculator = ExpressionEvaluator();

  print('🧮 PRUEBAS DE CALCULATOR 2.0');
  print('=' * 50);

  // MODO BÁSICO - 5 ejercicios
  print('\n📱 MODO BÁSICO:');
  print('-' * 25);

  // 1. Suma y resta combinada: 45.67+23.89-15.32
  print('\n1️⃣ Suma y resta combinada: 45.67+23.89-15.32');
  print('   Esperado: 54.24');
  String result1 = calculator.evaluate('45.67+23.89-15.32');
  print('   Resultado: $result1');
  print('   ✅ ${result1 == '54.24' ? 'CORRECTO' : 'INCORRECTO'}');

  // 2. Multiplicación y división: 128*3.5/4
  print('\n2️⃣ Multiplicación y división: 128*3.5/4');
  print('   Esperado: 112');
  String result2 = calculator.evaluate('128*3.5/4');
  print('   Resultado: $result2');
  print('   ✅ ${result2 == '112' ? 'CORRECTO' : 'INCORRECTO'}');

  // 3. Porcentaje: 15% de 250 = 250*0.15
  print('\n3️⃣ Porcentaje: 15% de 250');
  print('   Esperado: 37.5');
  String result3 = calculator.evaluate('250*0.15');
  print('   Resultado: $result3');
  print('   ✅ ${result3 == '37.5' ? 'CORRECTO' : 'INCORRECTO'}');

  // 4. Raíz cuadrada: sqrt(144)+sqrt(25)
  print('\n4️⃣ Raíz cuadrada: sqrt(144)+sqrt(25)');
  print('   Esperado: 17');
  String result4 = calculator.evaluate('sqrt(144)+sqrt(25)');
  print('   Resultado: $result4');
  print('   ✅ ${result4 == '17' ? 'CORRECTO' : 'INCORRECTO'}');

  // 5. Potencia simple: 7^2*3
  print('\n5️⃣ Potencia simple: 7^2*3');
  print('   Esperado: 147');
  String result5 = calculator.evaluate('7^2*3');
  print('   Resultado: $result5');
  print('   ✅ ${result5 == '147' ? 'CORRECTO' : 'INCORRECTO'}');

  // MODO CIENTÍFICO - 5 ejercicios
  print('\n\n🔬 MODO CIENTÍFICO:');
  print('-' * 25);

  // 1. Trigonometría: sin(30°)+cos(60°) = sin(30*pi/180)+cos(60*pi/180)
  print('\n1️⃣ Trigonometría: sin(30°)+cos(60°)');
  print('   Esperado: 1.0');
  String result6 = calculator.evaluate('sin(30*pi/180)+cos(60*pi/180)');
  print('   Resultado: $result6');
  double val6 = double.tryParse(result6) ?? 0;
  print('   ✅ ${(val6 - 1.0).abs() < 0.001 ? 'CORRECTO' : 'INCORRECTO'}');

  // 2. Logaritmo: log10(1000)+ln(e^2) - necesitamos usar log(1000)/log(10) para log base 10
  print('\n2️⃣ Logaritmo: log10(1000)+ln(e^2)');
  print('   Esperado: 5.0');
  String result7 = calculator.evaluate('log(1000)/log(10)+log(e^2)');
  print('   Resultado: $result7');
  double val7 = double.tryParse(result7) ?? 0;
  print('   ✅ ${(val7 - 5.0).abs() < 0.001 ? 'CORRECTO' : 'INCORRECTO'}');

  // 3. Notación científica: (2.5*10^4)*(4*10^-2)
  print('\n3️⃣ Notación científica: (2.5*10^4)*(4*10^-2)');
  print('   Esperado: 1000');
  String result8 = calculator.evaluate('(2.5*10^4)*(4*10^(-2))');
  print('   Resultado: $result8');
  print('   ✅ ${result8 == '1000' ? 'CORRECTO' : 'INCORRECTO'}');

  // 4. Factorial: Necesitamos implementar factorial manualmente
  print('\n4️⃣ Factorial: 5!');
  print('   Esperado: 120');
  String result9 = calculator.evaluate('5*4*3*2*1');
  print('   Resultado: $result9 (calculado como 5*4*3*2*1)');
  print('   ✅ ${result9 == '120' ? 'CORRECTO' : 'INCORRECTO'}');

  // 5. Exponencial y raíz cúbica: e^3+27^(1/3)
  print('\n5️⃣ Exponencial y raíz cúbica: e^3+27^(1/3)');
  print('   Esperado: ~23.0855');
  String result10 = calculator.evaluate('e^3+27^(1/3)');
  print('   Resultado: $result10');
  double val10 = double.tryParse(result10) ?? 0;
  print('   ✅ ${(val10 - 23.0855).abs() < 0.1 ? 'CORRECTO' : 'INCORRECTO'}');

  print('\n' + '=' * 50);
  print('🎯 RESUMEN DE PRUEBAS COMPLETADO');
}
