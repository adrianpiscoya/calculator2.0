import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

/// **WIDGET SIMPLE DE FRACCIONES VISUALES** 🔢
/// Usa flutter_math_fork para renderizar fracciones matemáticas hermosas

class SimpleFractionDisplay extends StatelessWidget {
  final String expression;
  final TextStyle? baseTextStyle;
  final Color mathColor;
  final double fontSize;
  final bool
      isFractionContext; // Nuevo parámetro para indicar si viene de operaciones con fracciones

  const SimpleFractionDisplay({
    Key? key,
    required this.expression,
    this.baseTextStyle,
    this.mathColor = Colors.white,
    this.fontSize = 24,
    this.isFractionContext = false, // Por defecto, tratar como división normal
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String cleanExpression = expression.trim();
    print('🎨 MATH_FRACTION_DISPLAY: Recibido "$cleanExpression"');

    try {
      // Detectar fracción simple como "3/4"
      final fractionMatch =
          RegExp(r'^(\d+)/(\d+)$').firstMatch(cleanExpression);
      if (fractionMatch != null) {
        String numerator = fractionMatch.group(1)!;
        String denominator = fractionMatch.group(2)!;

        // LÓGICA INTELIGENTE: Simplificar fracciones que resultan en enteros
        int num = int.parse(numerator);
        int den = int.parse(denominator);

        // Si la fracción se simplifica a un entero, mostrar solo el número
        if (num % den == 0) {
          int result = num ~/ den;
          print('🎨 FRACCIÓN ENTERA: $cleanExpression -> $result');
          return Text(
            result.toString(),
            style: TextStyle(
              fontSize: fontSize,
              color: mathColor,
              fontFamily: 'RobotoMono',
              fontWeight: FontWeight.bold,
            ),
          );
        }

        // NUEVO: Solo mostrar como fracción TeX si estamos en contexto de fracciones
        if (isFractionContext) {
          String texExpression =
              r'\frac{' + numerator + '}{' + denominator + '}';
          print(
              '🎨 FRACCIÓN SIMPLE (contexto fracción): $cleanExpression -> $texExpression');

          return Math.tex(
            texExpression,
            textStyle: TextStyle(
              fontSize: fontSize,
              color: mathColor,
            ),
          );
        } else {
          // En contexto de división normal, mostrar como decimal
          double result = num / den;
          String resultStr = result == result.toInt()
              ? result.toInt().toString()
              : result.toString();
          print('🎨 DIVISIÓN NORMAL: $cleanExpression -> $resultStr');

          return Text(
            resultStr,
            style: TextStyle(
              fontSize: fontSize,
              color: mathColor,
              fontFamily: 'RobotoMono',
              fontWeight: FontWeight.bold,
            ),
          );
        }
      }

      // Detectar expresiones mixtas con fracciones SOLO en contexto de fracciones
      if (isFractionContext &&
          cleanExpression.contains('/') &&
          (cleanExpression.contains('(') ||
              RegExp(r'^\d+/\d+(\+|\-|\*|×|/|$)').hasMatch(cleanExpression))) {
        String texExpression = _convertToTeX(cleanExpression);
        print(
            '🎨 EXPRESIÓN MIXTA (contexto fracción): $cleanExpression -> $texExpression');

        return Math.tex(
          texExpression,
          textStyle: TextStyle(
            fontSize: fontSize,
            color: mathColor,
          ),
        );
      }

      print('🎨 NO ES FRACCIÓN: Mostrando como texto normal');

      // Si no es fracción, mostrar como texto normal
      return Text(
        _basicSymbolReplacement(cleanExpression),
        style: baseTextStyle ??
            TextStyle(
              fontSize: fontSize,
              color: mathColor,
              fontFamily: 'RobotoMono',
              fontWeight: FontWeight.bold,
            ),
      );
    } catch (e) {
      print('🎨 ERROR AL RENDERIZAR: $e');
      // Fallback a texto normal si hay error
      return Text(
        cleanExpression,
        style: TextStyle(
          fontSize: fontSize,
          color: mathColor,
          fontFamily: 'RobotoMono',
        ),
      );
    }
  }

  // Convertir expresión matemática a notación TeX
  String _convertToTeX(String expression) {
    // Convertir fracciones a formato TeX
    String texExpression = expression.replaceAllMapped(
      RegExp(r'(\d+)/(\d+)'),
      (match) => r'\frac{' + match.group(1)! + '}{' + match.group(2)! + '}',
    );

    // Convertir operadores a símbolos TeX
    texExpression = texExpression
        .replaceAll('*', r' \times ')
        .replaceAll('sqrt', r'\sqrt')
        .replaceAll('pi', r'\pi');

    return texExpression;
  }

  String _basicSymbolReplacement(String expr) {
    return expr
        .replaceAll('sqrt', '√')
        .replaceAll('pi', 'π')
        .replaceAll('*', '×')
        .replaceAll('/', '÷')
        .replaceAll('cbrt', '∛');
  }
}
