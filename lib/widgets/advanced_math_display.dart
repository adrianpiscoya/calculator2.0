import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class AdvancedMathDisplay extends StatefulWidget {
  final String expression;
  final String result;
  final List<String> history;
  final String angleMode; // RAD, DEG, GRAD
  final String numberFormat; // NORMAL, SCI, ENG
  final bool isShiftActive; // Para funciones secundarias
  final bool isAlphaActive; // Para variables/constantes

  const AdvancedMathDisplay({
    Key? key,
    required this.expression,
    required this.result,
    required this.history,
    this.angleMode = 'RAD',
    this.numberFormat = 'NORMAL',
    this.isShiftActive = false,
    this.isAlphaActive = false,
  }) : super(key: key);

  @override
  State<AdvancedMathDisplay> createState() => _AdvancedMathDisplayState();
}

class _AdvancedMathDisplayState extends State<AdvancedMathDisplay> {
  // Convierte expresiones normales a LaTeX para renderizado matemático avanzado
  String _convertToLatex(String expression) {
    String latex = expression;

    // Limpiar espacios extra
    latex = latex.trim().replaceAll(RegExp(r'\s+'), ' ');

    // Constantes matemáticas
    latex = latex.replaceAll('pi', r'\pi');
    latex = latex.replaceAll('π', r'\pi');
    latex = latex.replaceAll('infinity', r'\infty');
    latex = latex.replaceAll('∞', r'\infty');
    latex = latex.replaceAll(RegExp(r'\be\b'), r'e'); // Número e

    // Operadores matemáticos avanzados
    latex = latex.replaceAll('±', r'\pm');
    latex = latex.replaceAll('×', r'\times');
    latex = latex.replaceAll('*', r' \times ');
    latex = latex.replaceAll('÷', r'\div');
    latex = latex.replaceAll('≠', r'\neq');
    latex = latex.replaceAll('≤', r'\leq');
    latex = latex.replaceAll('≥', r'\geq');
    latex = latex.replaceAll('≈', r'\approx');

    // Funciones trigonométricas e hiperbólicas
    latex = latex.replaceAll('sin⁻¹', r'\arcsin');
    latex = latex.replaceAll('cos⁻¹', r'\arccos');
    latex = latex.replaceAll('tan⁻¹', r'\arctan');
    latex = latex.replaceAll('sin(', r'\sin\left(');
    latex = latex.replaceAll('cos(', r'\cos\left(');
    latex = latex.replaceAll('tan(', r'\tan\left(');
    latex = latex.replaceAll('sinh(', r'\sinh\left(');
    latex = latex.replaceAll('cosh(', r'\cosh\left(');
    latex = latex.replaceAll('tanh(', r'\tanh\left(');

    // Logaritmos
    latex = latex.replaceAll('ln(', r'\ln\left(');
    latex = latex.replaceAll('log(', r'\log\left(');
    latex = latex.replaceAll('log10(', r'\log_{10}\left(');
    latex = latex.replaceAll('log2(', r'\log_2\left(');

    // Raíces cuadradas y cúbicas
    latex = latex.replaceAll('sqrt(', r'\sqrt{');
    latex = latex.replaceAll('√(', r'\sqrt{');
    latex = latex.replaceAll('∛(', r'\sqrt[3]{');

    // Potencias comunes
    latex = latex.replaceAll('²', r'^{2}');
    latex = latex.replaceAll('³', r'^{3}');
    latex = latex.replaceAll(r'^2', r'^{2}');
    latex = latex.replaceAll(r'^3', r'^{3}');
    latex = latex.replaceAll(r'^(-1)', r'^{-1}');

    // Factoriales
    latex = latex.replaceAll(RegExp(r'(\d+)!'), r'\1!');

    // Fracciones complejas (expresiones/expresiones)
    RegExp complexFractionPattern = RegExp(r'\(([^)]+)\)/\(([^)]+)\)');
    latex = latex.replaceAllMapped(complexFractionPattern, (match) {
      return r'\frac{' + match.group(1)! + '}{' + match.group(2)! + '}';
    });

    // Fracciones simples (número/número)
    RegExp simpleFractionPattern = RegExp(r'(\d+\.?\d*)/(\d+\.?\d*)');
    latex = latex.replaceAllMapped(simpleFractionPattern, (match) {
      return r'\frac{' + match.group(1)! + '}{' + match.group(2)! + '}';
    });

    // Potencias generales x^y -> x^{y}
    RegExp powerPattern = RegExp(r'(\w+|\([^)]+\))\^(\w+|\([^)]+\))');
    latex = latex.replaceAllMapped(powerPattern, (match) {
      return match.group(1)! + '^{' + match.group(2)! + '}';
    });

    // Corregir paréntesis para LaTeX
    latex = latex.replaceAll('(', r'\left(');
    latex = latex.replaceAll(')', r'\right)');
    latex = latex.replaceAll('[', r'\left[');
    latex = latex.replaceAll(']', r'\right]');

    // Integrales básicas
    latex = latex.replaceAll('∫', r'\int');
    latex = latex.replaceAll('integral(', r'\int ');

    // Derivadas
    latex = latex.replaceAll("d/dx", r'\frac{d}{dx}');
    latex = latex.replaceAll("∂/∂x", r'\frac{\partial}{\partial x}');

    // Sumatorias y productos
    latex = latex.replaceAll('Σ', r'\sum');
    latex = latex.replaceAll('∏', r'\prod');

    return latex;
  }

  Widget _buildMathExpression(String expr, {double fontSize = 24}) {
    if (expr.isEmpty) {
      return Container(
        height: fontSize * 1.5,
        child: Center(
          child: Text(
            '0',
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'RobotoMono',
              color: Colors.grey[400],
            ),
          ),
        ),
      );
    }

    try {
      String latexExpr = _convertToLatex(expr);
      return Container(
        padding: EdgeInsets.all(8),
        child: Math.tex(
          latexExpr,
          textStyle: TextStyle(
            fontSize: fontSize,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    } catch (e) {
      // Fallback inteligente con símbolos Unicode para matemáticas
      String fallbackExpr = _createUnicodeFallback(expr);
      return Container(
        padding: EdgeInsets.all(8),
        child: Text(
          fallbackExpr,
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: 'RobotoMono',
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
  }

  // Crear fallback con símbolos Unicode cuando LaTeX falla
  String _createUnicodeFallback(String expr) {
    String fallback = expr;

    // Símbolos matemáticos Unicode
    fallback = fallback.replaceAll('*', '×');
    fallback = fallback.replaceAll('/', '÷');
    fallback = fallback.replaceAll('pi', 'π');
    fallback = fallback.replaceAll('infinity', '∞');
    fallback = fallback.replaceAll('sqrt(', '√(');
    fallback = fallback.replaceAll('^2', '²');
    fallback = fallback.replaceAll('^3', '³');
    fallback = fallback.replaceAll('+-', '±');
    fallback = fallback.replaceAll('<=', '≤');
    fallback = fallback.replaceAll('>=', '≥');
    fallback = fallback.replaceAll('!=', '≠');
    fallback = fallback.replaceAll('~=', '≈');

    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double displayHeight = screenHeight * 0.35; // Fijo 35% de la pantalla

    return Container(
      height: displayHeight,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Barra de estado superior con indicadores
          Container(
            height: 35,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Indicadores izquierda
                Row(
                  children: [
                    _buildIndicator('HYP', false),
                    SizedBox(width: 8),
                    _buildIndicator(widget.angleMode, true),
                    SizedBox(width: 8),
                    _buildIndicator(
                        widget.numberFormat, widget.numberFormat != 'NORMAL'),
                  ],
                ),
                // Indicadores derecha
                Row(
                  children: [
                    _buildIndicator('SHIFT', widget.isShiftActive),
                    SizedBox(width: 8),
                    _buildIndicator('ALPHA', widget.isAlphaActive),
                    SizedBox(width: 8),
                    Icon(Icons.battery_full, color: Colors.white, size: 16),
                  ],
                ),
              ],
            ),
          ),

          // Display principal matemático
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Línea superior: expresión pequeña o historial
                  Container(
                    height: 30,
                    width: double.infinity,
                    alignment: Alignment.centerRight,
                    child: widget.history.isNotEmpty
                        ? Text(
                            widget.history.last,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontFamily: 'RobotoMono',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        : SizedBox.shrink(),
                  ),

                  // Área principal de expresión (75% del display)
                  Expanded(
                    flex: 7,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      padding: EdgeInsets.all(12),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          reverse: true,
                          child: widget.expression.isEmpty
                              ? Center(
                                  child: Text(
                                    '0',
                                    style: TextStyle(
                                      fontSize: 36,
                                      color: Colors.grey[400],
                                      fontFamily: 'RobotoMono',
                                    ),
                                  ),
                                )
                              : _buildMathExpression(widget.expression,
                                  fontSize: 32),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 8),

                  // Área de resultado (25% del display)
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      padding: EdgeInsets.all(12),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: widget.result.isEmpty
                            ? SizedBox.shrink()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '= ',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.blue[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  _buildMathExpression(widget.result,
                                      fontSize: 28),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget para indicadores de estado
  Widget _buildIndicator(String text, bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? Colors.orange[600] : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isActive ? Colors.orange[600]! : Colors.grey[600]!,
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
