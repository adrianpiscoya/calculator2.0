class CalculatorState {
  final String output;
  final String history;
  final double fontSize;
  final bool isRadians;
  final double memoryValue;

  const CalculatorState({
    this.output = "0",
    this.history = "",
    this.fontSize = 48,
    this.isRadians = true,
    this.memoryValue = 0,
  });

  CalculatorState copyWith({
    String? output,
    String? history,
    double? fontSize,
    bool? isRadians,
    double? memoryValue,
  }) {
    return CalculatorState(
      output: output ?? this.output,
      history: history ?? this.history,
      fontSize: fontSize ?? this.fontSize,
      isRadians: isRadians ?? this.isRadians,
      memoryValue: memoryValue ?? this.memoryValue,
    );
  }
}
