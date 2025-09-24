import 'package:flutter/material.dart';
import '../logic/calculator_state_notifier.dart';
import 'display_panel.dart';
import 'scientific_keypad.dart';

/// A lightweight host that composes the display and keypad and exposes a
/// small integration surface for external calculator logic.
class CalculatorHost extends StatelessWidget {
  final CalculatorStateNotifier stateNotifier;
  final void Function(String) onKey;
  final String? assetPrefix;
  final List<List<String>> buttonsMatrix;
  final Map<String, String> secondaryAbbrev;
  final bool secondMode;

  const CalculatorHost({
    Key? key,
    required this.stateNotifier,
    required this.onKey,
    required this.buttonsMatrix,
    required this.secondaryAbbrev,
    this.assetPrefix,
    this.secondMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Display: listen only to the notifier to avoid rebuilding parent
        DisplayPanel(
            state: stateNotifier.value, stateListenable: stateNotifier),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ScientificKeypad(
              buttonsMatrix: buttonsMatrix,
              secondaryAbbrev: secondaryAbbrev,
              secondMode: secondMode,
              onKeyPressed: onKey,
            ),
          ),
        ),
      ],
    );
  }
}
