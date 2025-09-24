import 'lib/expression_evaluator.dart';

void main() {
  final calculator = ExpressionEvaluator();

  print('🔍 DEBUG - ANÁLISIS DE PROBLEMAS');
  print('=' * 40);

  // Probar paso a paso
  List<String> debugTests = [
    'e', // ¿Funciona e solo?
    'log(1)', // ¿Funciona log sin e?
    'log(2.718)', // ¿Funciona log con número?
    '1/e', // ¿Funciona división con e?
    'log(1/2.718)', // ¿Funciona con número en lugar de e?
    '100/4', // ¿Funciona la división?
    'log(25)', // ¿Funciona log de 25?
    'log(25)/log(10)', // ¿Funciona la conversión manual?
  ];

  for (String test in debugTests) {
    String result = calculator.evaluate(test);
    print('$test = $result');
  }
}
