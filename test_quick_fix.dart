import 'lib/expression_evaluator.dart';

void main() {
  final calculator = ExpressionEvaluator();

  print('🔧 TEST RÁPIDO - CORRECCIÓN DE ERRORES');
  print('=' * 50);

  // Probar las funciones que fallaban
  List<Map<String, dynamic>> tests = [
    {'expr': 'log10(100/4)', 'desc': 'Logaritmo base 10 con fracción'},
    {'expr': 'exp(1/2) * (3/4)', 'desc': 'Exponencial con fracción'},
    {'expr': 'log(1/e) + 5/2', 'desc': 'Logaritmo natural con fracción'},
    {'expr': 'exp(1)', 'desc': 'Exponencial de 1 (debe ser e)'},
    {'expr': 'log(e^2)', 'desc': 'Logaritmo de e^2 (debe ser 2)'},
    {'expr': 'e', 'desc': 'Constante e'},
    {'expr': 'pi', 'desc': 'Constante pi'},
    {'expr': '2.5^3 + 1.5^2', 'desc': 'Potencias decimales'},
  ];

  print('\n📊 RESULTADOS:');
  print('-' * 50);

  int passed = 0;
  for (var test in tests) {
    String result = calculator.evaluate(test['expr']);
    print('${test['desc']}:');
    print('   ${test['expr']} = $result');

    if (!result.startsWith('Error')) {
      passed++;
      print('   ✅ OK');
    } else {
      print('   ❌ ERROR');
    }
    print('');
  }

  print('=' * 50);
  print('Exitosos: $passed/${tests.length}');
  print('Porcentaje: ${(passed / tests.length * 100).toStringAsFixed(1)}%');
  print('=' * 50);
}
