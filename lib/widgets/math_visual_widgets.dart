import 'package:flutter/material.dart';

class MathDisplayWidget extends StatelessWidget {
  final String expression;
  final TextStyle? baseTextStyle;
  final Color mathColor;
  final double fontSize;

  const MathDisplayWidget({
    Key? key,
    required this.expression,
    this.baseTextStyle,
    this.mathColor = Colors.white,
    this.fontSize = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultStyle = TextStyle(
      fontSize: fontSize,
      color: mathColor,
      fontFamily: 'RobotoMono',
      fontWeight: FontWeight.bold,
    );

    return Text(
      _safeSymbolReplacement(expression),
      style: baseTextStyle ?? defaultStyle,
    );
  }

  String _safeSymbolReplacement(String expr) {
    return expr
        .replaceAll('sqrt', '√')
        .replaceAll('pi', 'π')
        .replaceAll('*', '×')
        .replaceAll('/', '÷')
        .replaceAll('cbrt', '∛');
  }
}
