import 'package:flutter/foundation.dart';
import 'calculator_state.dart';

/// A small helper that wraps an immutable [CalculatorState] into a
/// [ValueNotifier] so widgets can listen only to the parts that change.
class CalculatorStateNotifier extends ValueNotifier<CalculatorState> {
  CalculatorStateNotifier([CalculatorState? initial])
      : super(initial ?? const CalculatorState());

  String get output => value.output;
  String get history => value.history;
  double get fontSize => value.fontSize;

  void setOutput(String out) {
    value = value.copyWith(output: out);
  }

  void setHistory(String h) {
    value = value.copyWith(history: h);
  }

  void update({String? output, String? history, double? fontSize}) {
    value = value.copyWith(
      output: output,
      history: history,
      fontSize: fontSize,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
