import 'package:math_expressions/math_expressions.dart';
import 'dart:math' as math;

void main() {
  print('🔬 TEST DE LOG10 DIRECTO');
  print('=' * 30);

  try {
    final p = ShuntingYardParser();
    ContextModel cm = ContextModel();
    cm.bindVariable(Variable('pi'), Number(math.pi));

    // Probar log10 directamente
    List<String> logTests = [
      'log10(10)',
      'log10(100)',
      'log10(1000)',
      'log10(25)',
    ];

    for (String expr in logTests) {
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
