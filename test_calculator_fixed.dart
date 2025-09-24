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
      return 'Error: $e';
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
    formatted = formatted.replaceAll(RegExp(r'\.?0+$'), '');

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

  print('🔧 PRUEBAS CORREGIDAS - CALCULATOR 2.0');
  print('=' * 55);

  // TESTS CORREGIDOS
  print('\n📱 MODO BÁSICO (Corregido):');
  print('-' * 30);

  // Test formato de decimales
  print('\n1️⃣ Suma y resta (formato corregido): 45.67+23.89-15.32');
  String result1 = calculator.evaluate('45.67+23.89-15.32');
  print('   Resultado: $result1');
  print(
      '   ✅ ${result1 == '54.24' ? 'CORRECTO - Formato mejorado!' : 'Revisar formato'}');

  print('\n3️⃣ Porcentaje (formato corregido): 250*0.15');
  String result3 = calculator.evaluate('250*0.15');
  print('   Resultado: $result3');
  print(
      '   ✅ ${result3 == '37.5' ? 'CORRECTO - Formato mejorado!' : 'Revisar formato'}');

  print('\n\n🔬 MODO CIENTÍFICO (Corregido):');
  print('-' * 35);

  // Test trigonometría con π definida
  print('\n1️⃣ Trigonometría (π corregida): sin(30*pi/180)+cos(60*pi/180)');
  String result6 = calculator.evaluate('sin(30*pi/180)+cos(60*pi/180)');
  print('   Resultado: $result6');
  double val6 = double.tryParse(result6) ?? 0;
  print(
      '   ✅ ${(val6 - 1.0).abs() < 0.01 ? 'CORRECTO - π definida!' : 'Revisar trigonometría'}');

  // Test logaritmo base 10 corregido
  print('\n2️⃣ Logaritmo (log10 corregido): log10(1000)+log(e^2)');
  String result7 = calculator.evaluate('log10(1000)+log(e^2)');
  print('   Resultado: $result7');
  double val7 = double.tryParse(result7) ?? 0;
  print(
      '   ✅ ${(val7 - 5.0).abs() < 0.01 ? 'CORRECTO - log10 funciona!' : 'Revisar logaritmo'}');

  // Tests adicionales
  print('\n\n🧪 TESTS ADICIONALES:');
  print('-' * 25);

  print('\n🔢 Números grandes: 1000000*2');
  String big = calculator.evaluate('1000000*2');
  print('   Resultado: $big (notación científica si > 1M)');

  print('\n🔢 Números pequeños: 0.000001*2');
  String small = calculator.evaluate('0.000001*2');
  print('   Resultado: $small (notación científica si < 0.000001)');

  print('\n🔢 Constante π: pi*2');
  String piTest = calculator.evaluate('pi*2');
  print('   Resultado: $piTest');

  print('\n🔢 Constante e: e^1');
  String eTest = calculator.evaluate('e^1');
  print('   Resultado: $eTest');

  print('\n' + '=' * 55);
  print('🎯 CORRECCIONES APLICADAS:');
  print('   ✅ Formato de decimales mejorado');
  print('   ✅ Constante π definida');
  print('   ✅ Constante e definida');
  print('   ✅ log10() implementado');
  print('   ✅ Notación científica para números extremos');
  print('=' * 55);
}
