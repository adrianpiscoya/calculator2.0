// ScientificKeypad: renders a grid of buttons using SVG assets placed in
// `assets/buttons/`. If an SVG for a label is not available, it falls back
// to rendering the label as text.
import 'package:flutter/material.dart';
// Removed flutter_svg and rootBundle usage to improve performance and
// avoid loading SVG assets at runtime. Buttons use native Flutter visuals.

class ScientificKeypad extends StatelessWidget {
  /// Matrix of button labels; each inner list is a row.
  final List<List<String>> buttonsMatrix;

  /// Called when a button is pressed with the label as argument.
  final void Function(String) onKeyPressed;

  /// Optional map for secondary abbreviations (kept for API compatibility).
  final Map<String, String>? secondaryAbbrev;

  /// Optional: whether to show secondary labels (not implemented here).
  final bool secondMode;

  /// How many top rows should be rendered as 'small' (scientific buttons).
  final int smallTopRows;

  const ScientificKeypad({
    Key? key,
    required this.buttonsMatrix,
    required this.onKeyPressed,
    this.secondaryAbbrev,
    this.secondMode = false,
    this.smallTopRows = 4,
  }) : super(key: key);

  // Explicit mapping: when a label is exactly one of these keys, prefer the
  // provided asset path. This avoids heuristic mismatches when SVGs were
  // supplied with custom filenames.
  // Asset map removed: we don't load SVG assets at runtime anymore.

  // Labels considered 'scientific' — these should use a larger icon size
  static const Set<String> _scientificLabels = {
    'sin',
    'cos',
    'tan',
    'asin',
    'acos',
    'atan',
    'hyp',
    '√',
    'log',
    '10^x',
    'ln',
    'e^x',
    'rad',
    'deg',
    'π',
    'e',
    'x^y',
    'y√x',
    'x²',
    '1/x',
    'n!',
    '|x|',
    'mod',
    'a/b',
    '%',
    'MR',
    'MC',
    'M+',
    'M-',
    'exp',
    'shift',
    '2nd',
    'Ans',
    '+/-'
  };

  // ...existing code...

  // Build a professional styled button with better colors and design
  Widget _buildButton(BuildContext context, String label,
      {double iconWidth = 36, double iconHeight = 36}) {
    final isSecondToggle = label.toLowerCase() == '2nd' || label == '2nd';
    final isOperator = ['+', '-', '*', '/', '÷', '×', '='].contains(label);
    final isFunction = _scientificLabels.contains(label);
    final isNumber = RegExp(r'^[0-9]$').hasMatch(label);
    final isSpecial = ['AC', 'back', '.', 'deg', 'rad'].contains(label);

    Color backgroundColor;
    Color textColor;
    Color borderColor;

    if (isSecondToggle && secondMode) {
      backgroundColor = const Color(0xFFEA580C); // Orange activo
      textColor = Colors.white;
      borderColor = const Color(0xFFFB923C);
    } else if (isOperator) {
      backgroundColor = const Color(0xFF1E40AF); // Azul para operadores
      textColor = Colors.white;
      borderColor = const Color(0xFF3B82F6);
    } else if (isFunction) {
      backgroundColor =
          const Color(0xFF059669); // Verde para funciones científicas
      textColor = Colors.white;
      borderColor = const Color(0xFF10B981);
    } else if (isNumber) {
      backgroundColor = const Color(0xFF374151); // Gris para números
      textColor = Colors.white;
      borderColor = const Color(0xFF4B5563);
    } else if (isSpecial) {
      backgroundColor = const Color(0xFF7C2D12); // Marrón para especiales
      textColor = Colors.white;
      borderColor = const Color(0xFF9A3412);
    } else {
      backgroundColor = const Color(0xFF1F2937); // Default gris oscuro
      textColor = Colors.white70;
      borderColor = const Color(0xFF374151);
    }

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: SizedBox(
        height: iconHeight,
        child: Material(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.3),
          child: InkWell(
            onTap: () => onKeyPressed(label),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: 1),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    backgroundColor,
                    backgroundColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: textColor,
                    fontSize: _getFontSize(label),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _getFontSize(String label) {
    if (label.length > 3) return 10;
    if (label.length > 2) return 12;
    if (RegExp(r'^[0-9]$').hasMatch(label)) return 18;
    return 14;
  }

  @override
  Widget build(BuildContext context) {
    final rows = buttonsMatrix;

    final totalRows = rows.length;
    const bottomCount = 4; // number of rows from bottom to enlarge

    return LayoutBuilder(builder: (context, constraints) {
      final availableHeight = constraints.maxHeight.isFinite
          ? constraints.maxHeight
          : MediaQuery.of(context).size.height *
              0.35; // Reducido para más espacio al display
      final int rowCount = totalRows;
      final double spacing = 6.0 * rowCount; // Reducido spacing
      final double rawButtonHeight = (availableHeight - spacing) / rowCount;
      final double buttonHeight =
          rawButtonHeight.clamp(32.0, 56.0); // Tamaño un poco más grande

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 4), // Reducido espacio superior
          ...rows.asMap().entries.map((entry) {
            final rowIndex = entry.key;
            final row = entry.value;
            final isBottom = rowIndex >= (totalRows - bottomCount);

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row.map((label) {
                final labelIsScientific = _scientificLabels.contains(label);
                double w;
                double h;

                if (isBottom) {
                  w = 36.0; // Reducido
                  h = 42.0; // Reducido
                } else if (labelIsScientific) {
                  w = 32.0; // Reducido
                  h = 32.0; // Reducido
                } else {
                  w = 28.0; // Reducido
                  h = 28.0; // Reducido
                }

                final svgHeight =
                    h.clamp(16.0, buttonHeight); // Reducido mínimo

                String effectiveLabel = label;
                if (secondMode && secondaryAbbrev != null) {
                  final sec = secondaryAbbrev![label];
                  if (sec != null && sec.isNotEmpty) effectiveLabel = sec;
                }

                return Expanded(
                    child: SizedBox(
                        height: buttonHeight,
                        child: _buildButton(context, effectiveLabel,
                            iconWidth: w, iconHeight: svgHeight)));
              }).toList(),
            );
          })
        ],
      );
    });
  }
}
