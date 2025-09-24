class Fraction {
  int numerator;
  int denominator;

  Fraction(this.numerator, this.denominator) {
    if (denominator == 0) {
      throw ArgumentError('Denominator cannot be zero');
    }
    simplify();
  }

  // Crear fracción desde decimal (aproximación)
  factory Fraction.fromDecimal(double decimal, {int maxDenominator = 1000}) {
    if (decimal == decimal.toInt()) {
      return Fraction(decimal.toInt(), 1);
    }

    int sign = decimal.isNegative ? -1 : 1;
    decimal = decimal.abs();

    for (int denom = 1; denom <= maxDenominator; denom++) {
      int num = (decimal * denom).round();
      if ((num / denom - decimal).abs() < 0.0001) {
        return Fraction(sign * num, denom);
      }
    }

    // Si no se encuentra una fracción simple, usar aproximación
    int wholePart = decimal.toInt();
    double fractionalPart = decimal - wholePart;
    int num = (fractionalPart * 1000).round();
    return Fraction(sign * (wholePart * 1000 + num), 1000);
  }

  // Simplificar fracción
  void simplify() {
    int gcd = _gcd(numerator.abs(), denominator.abs());
    numerator ~/= gcd;
    denominator ~/= gcd;

    // Asegurar que el denominador sea positivo
    if (denominator < 0) {
      numerator = -numerator;
      denominator = -denominator;
    }
  }

  // Máximo común divisor
  int _gcd(int a, int b) {
    while (b != 0) {
      int temp = b;
      b = a % b;
      a = temp;
    }
    return a;
  }

  // Operaciones aritméticas
  Fraction operator +(Fraction other) {
    return Fraction(
      numerator * other.denominator + other.numerator * denominator,
      denominator * other.denominator,
    );
  }

  Fraction operator -(Fraction other) {
    return Fraction(
      numerator * other.denominator - other.numerator * denominator,
      denominator * other.denominator,
    );
  }

  Fraction operator *(Fraction other) {
    return Fraction(
      numerator * other.numerator,
      denominator * other.denominator,
    );
  }

  Fraction operator /(Fraction other) {
    return Fraction(
      numerator * other.denominator,
      denominator * other.numerator,
    );
  }

  // Convertir a decimal
  double toDouble() {
    return numerator / denominator;
  }

  // Convertir a string
  @override
  String toString() {
    if (denominator == 1) {
      return numerator.toString();
    }
    return '$numerator/$denominator';
  }

  // Mostrar como fracción mixta si es apropiado
  String toMixedString() {
    if (numerator.abs() < denominator) {
      return toString();
    }

    int wholePart = numerator ~/ denominator;
    int remainderNum = numerator % denominator;

    if (remainderNum == 0) {
      return wholePart.toString();
    }

    return '$wholePart ${remainderNum.abs()}/$denominator';
  }

  @override
  bool operator ==(Object other) {
    if (other is! Fraction) return false;
    return numerator == other.numerator && denominator == other.denominator;
  }

  @override
  int get hashCode => numerator.hashCode ^ denominator.hashCode;
}

class FractionCalculator {
  // Evaluar expresión que puede contener fracciones
  String evaluateWithFractions(String expression) {
    try {
      print('DEBUG: Evaluando expresión: $expression');

      // Detectar si la expresión contiene fracciones
      if (expression.contains('/') && _containsFractions(expression)) {
        print('DEBUG: Contiene fracciones, usando evaluador de fracciones');
        return _evaluateFractionExpression(expression);
      } else {
        print('DEBUG: No contiene fracciones, usando evaluador decimal');
        // Usar evaluador decimal normal
        return _evaluateDecimal(expression);
      }
    } catch (e) {
      print('DEBUG: Error evaluando: $e');
      return 'Error';
    }
  }

  // Detectar si la expresión contiene fracciones (paréntesis con /)
  bool _containsFractions(String expression) {
    return RegExp(r'\([0-9]+/[0-9]+\)').hasMatch(expression);
  }

  // Evaluar expresión decimal normal
  String _evaluateDecimal(String expression) {
    // Usar el evaluador existente
    try {
      expression = expression.replaceAll('√', 'sqrt');
      expression = expression.replaceAll('π', 'pi');
      expression = expression.replaceAll('ln', 'log');

      // Simular evaluación simple para operaciones básicas
      if (expression.contains('+')) {
        List<String> parts = expression.split('+');
        double sum = 0;
        for (String part in parts) {
          sum += double.parse(part.trim());
        }
        return _formatResult(sum);
      } else if (expression.contains('-') && expression.indexOf('-') > 0) {
        List<String> parts = expression.split('-');
        double result = double.parse(parts[0].trim());
        for (int i = 1; i < parts.length; i++) {
          result -= double.parse(parts[i].trim());
        }
        return _formatResult(result);
      } else if (expression.contains('*')) {
        List<String> parts = expression.split('*');
        double product = 1;
        for (String part in parts) {
          product *= double.parse(part.trim());
        }
        return _formatResult(product);
      } else if (expression.contains('/')) {
        List<String> parts = expression.split('/');
        double result = double.parse(parts[0].trim());
        for (int i = 1; i < parts.length; i++) {
          result /= double.parse(parts[i].trim());
        }
        return _formatResult(result);
      }

      return expression;
    } catch (e) {
      return 'Error';
    }
  }

  // Evaluar expresión con fracciones
  String _evaluateFractionExpression(String expression) {
    try {
      print('DEBUG: Evaluando expresión: $expression'); // Debug

      // Extraer fracciones de la expresión
      List<Fraction> fractions = [];
      List<String> operators = [];

      // Patrón para encontrar fracciones (numerador/denominador)
      RegExp fractionPattern = RegExp(r'\(([0-9]+)/([0-9]+)\)');

      Iterable<Match> fractionMatches = fractionPattern.allMatches(expression);

      print(
          'DEBUG: Fracciones encontradas: ${fractionMatches.length}'); // Debug

      // Extraer fracciones
      for (Match match in fractionMatches) {
        int num = int.parse(match.group(1)!);
        int denom = int.parse(match.group(2)!);
        fractions.add(Fraction(num, denom));
        print('DEBUG: Fracción agregada: $num/$denom'); // Debug
      }

      // Extraer operadores que están FUERA de los paréntesis de las fracciones
      String tempExpression = expression;

      // Reemplazar las fracciones con marcadores para encontrar operadores válidos
      List<Match> matchesList = fractionMatches.toList();
      for (int i = matchesList.length - 1; i >= 0; i--) {
        Match match = matchesList[i];
        tempExpression =
            tempExpression.replaceRange(match.start, match.end, 'F');
      }

      print('DEBUG: Expresión simplificada: $tempExpression'); // Debug

      // Ahora extraer operadores de la expresión simplificada
      RegExp operatorPattern = RegExp(r'[+\-*/]');
      Iterable<Match> operatorMatches =
          operatorPattern.allMatches(tempExpression);

      for (Match match in operatorMatches) {
        operators.add(match.group(0)!);
        print('DEBUG: Operador agregado: ${match.group(0)!}'); // Debug
      }

      print('DEBUG: Operadores encontrados: ${operators.length}'); // Debug

      if (fractions.isEmpty) {
        return 'Error';
      }

      // Evaluar secuencialmente de izquierda a derecha
      Fraction result = fractions[0];
      print('DEBUG: Resultado inicial: $result'); // Debug

      for (int i = 0; i < operators.length && i + 1 < fractions.length; i++) {
        String op = operators[i];
        Fraction nextFraction = fractions[i + 1];

        print('DEBUG: Operando $result $op $nextFraction'); // Debug

        switch (op) {
          case '+':
            result = result + nextFraction;
            break;
          case '-':
            result = result - nextFraction;
            break;
          case '*':
            result = result * nextFraction;
            break;
          case '/':
            result = result / nextFraction;
            break;
        }

        print('DEBUG: Resultado parcial: $result'); // Debug
      }

      // Formatear resultado
      return _formatFractionResult(result);
    } catch (e) {
      return 'Error';
    }
  }

  // Formatear resultado de fracción
  String _formatFractionResult(Fraction fraction) {
    double decimal = fraction.toDouble();

    // Si el decimal es un número entero o muy simple, mostrar solo decimal
    if (decimal == decimal.toInt()) {
      return decimal.toInt().toString();
    }

    // Si la fracción es muy compleja, mostrar decimal
    if (fraction.denominator > 100) {
      return _formatResult(decimal);
    }

    // Mostrar fracción y decimal
    return '${fraction.toString()} = ${_formatResult(decimal)}';
  }

  // Formatear resultado decimal
  String _formatResult(double result) {
    if (result == result.toInt()) {
      return result.toInt().toString();
    }
    return result
        .toStringAsFixed(8)
        .replaceAll(RegExp(r'\.0+$'), '')
        .replaceAll(RegExp(r'0+$'), '');
  }
}
