import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../logic/calculator_state.dart';

/// DisplayPanel shows calculator output and optional history.
/// It accepts either a static [state] (backwards-compatible) or an
/// optional [stateListenable] which allows the panel to rebuild only when
/// the notifier updates, reducing unnecessary parent rebuilds.
class DisplayPanel extends StatelessWidget {
  final CalculatorState state;
  final ValueListenable<CalculatorState>? stateListenable;

  const DisplayPanel({required this.state, this.stateListenable, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (stateListenable != null) {
      return ValueListenableBuilder<CalculatorState>(
        valueListenable: stateListenable!,
        builder: (context, s, _) => _buildContent(s),
      );
    }
    return _buildContent(state);
  }

  Widget _buildContent(CalculatorState state) {
    final bool isResult = state.history.isEmpty || state.history.endsWith('=');
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            state.output,
            style: TextStyle(
              color: Colors.white,
              fontSize: state.fontSize,
              fontWeight: FontWeight.bold,
              fontFamily: 'RobotoMono',
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (!isResult) ...[
            const SizedBox(height: 8),
            Text(
              state.history,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 18,
                fontFamily: 'RobotoMono',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
