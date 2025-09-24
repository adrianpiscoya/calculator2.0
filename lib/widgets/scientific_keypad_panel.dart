import 'package:flutter/material.dart';
import 'scientific_keypad.dart';

/// Stateful panel that wraps [ScientificKeypad] and provides toggles for
/// second-mode (2nd) and shift. It also exposes the pressed key callback.
class ScientificKeypadPanel extends StatefulWidget {
  final void Function(String) onKeyPressed;
  final List<List<String>> buttonsMatrix;
  final Map<String, String>? secondaryAbbrev;

  const ScientificKeypadPanel({
    Key? key,
    required this.onKeyPressed,
    required this.buttonsMatrix,
    this.secondaryAbbrev,
  }) : super(key: key);

  @override
  State<ScientificKeypadPanel> createState() => _ScientificKeypadPanelState();
}

class _ScientificKeypadPanelState extends State<ScientificKeypadPanel> {
  bool _secondMode = false;

  void _onKey(String label) {
    if (label.toLowerCase() == '2nd' || label.toLowerCase() == 'shift') {
      setState(() => _secondMode = !_secondMode);
      return;
    }
    // Map label when second mode is active
    if (_secondMode && widget.secondaryAbbrev != null) {
      final mapped = widget.secondaryAbbrev![label];
      if (mapped != null && mapped.isNotEmpty) {
        widget.onKeyPressed(mapped);
        return;
      }
    }
    widget.onKeyPressed(label);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // small indicator row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('2nd: ${_secondMode ? 'ON' : 'OFF'}',
                  style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 8),
            ],
          ),
        ),
        Expanded(
          child: ScientificKeypad(
            buttonsMatrix: widget.buttonsMatrix,
            onKeyPressed: _onKey,
            secondMode: _secondMode,
            secondaryAbbrev: widget.secondaryAbbrev,
          ),
        ),
      ],
    );
  }
}
