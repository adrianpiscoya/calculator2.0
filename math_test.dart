import 'package:math_expressions/math_expressions.dart';
import 'dart:math' as math;

void main() {
  print('🔬 ANÁLISIS DE MATH_EXPRESSIONS');
  print('=' * 40);

  // Probar directamente con math_expressions
  try {
    final p = ShuntingYardParser();

    // Crear contexto
    ContextModel cm = ContextModel();
    cm.bindVariable(Variable('pi'), Number(math.pi));
    cm.bindVariable(Variable('e'), Number(math.e));

    // Probar qué funciones están disponibles
    List<String> testExprs = [
      'pi',
      'e',
      'sqrt(4)',
      'sin(pi/2)',
      'cos(0)',
      'ln(e)', // Probar ln en lugar de log
      'log(10)', // Probar log
    ];

    for (String expr in testExprs) {
      try {
        final Expression exp = p.parse(expr);
        double result = exp.evaluate(EvaluationType.REAL, cm);
        print('✅ $expr = $result');
      } catch (e) {
        print('❌ $expr = Error: $e');
      }
    }
  } catch (e) {
    print('Error general: $e');
  }
}
