import 'package:flutter/material.dart';

class ButtonGrid extends StatelessWidget {
  final void Function(String) onButtonPressed;
  final bool isRadians;
  const ButtonGrid(
      {required this.onButtonPressed, required this.isRadians, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Botones principales y científicos
    final List<List<String>> buttons = [
      ["MC", "MR", "M+", "M-", "MS"],
      ["Rad", "sin", "cos", "tan", "log"],
      ["ln", "√", "³√", "x²", "x³"],
      ["(", ")", "mod", "!", "AC"],
      ["7", "8", "9", "/", "⌫"],
      ["4", "5", "6", "*", "-"],
      ["1", "2", "3", "+", "="],
      ["0", ".", "Ans", "PreAns", ""]
    ];

    return Column(
      children: buttons.map((row) {
        return Expanded(
          child: Row(
            children: row.map((label) {
              if (label.isEmpty) return const Expanded(child: SizedBox());
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getButtonColor(label),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => onButtonPressed(label),
                    child: Text(
                      label == "Rad" ? (isRadians ? "Rad" : "Deg") : label,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Color _getButtonColor(String label) {
    if (label == "=" || label == "AC")
      return const Color(0xFFF4D35E); // Amarillo
    if (["+", "-", "*", "/", "mod"].contains(label))
      return const Color(0xFFB00020); // Rojo
    if ([
      "sin",
      "cos",
      "tan",
      "log",
      "ln",
      "√",
      "³√",
      "x²",
      "x³",
      "!",
      "Ans",
      "PreAns"
    ].contains(label)) return const Color(0xFF43AA8B); // Verde
    if (["MC", "MR", "M+", "M-", "MS"].contains(label)) return Colors.blueGrey;
    if (["Rad", "(", ")", "⌫"].contains(label)) return Colors.grey[700]!;
    return Colors.grey[900]!;
  }
}
