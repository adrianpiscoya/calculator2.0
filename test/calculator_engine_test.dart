import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_scientific/logic/calculator_engine.dart';

void main() {
  group('CalculatorEngine basic', () {
    test('digit input and decimal', () {
      final engine = CalculatorEngine();
      engine.inputDigit(1);
      engine.inputDigit(2);
      engine.inputDecimal();
      engine.inputDigit(3);
      expect(engine.currentInput, '12.3');
    });

    test('basic operations + - * /', () {
      final engine = CalculatorEngine();
      engine.setCurrentInput(2);
      engine.performOperation('+');
      engine.setCurrentInput(3);
      engine.calculateResult();
      expect(engine.getCurrentInput(), 5);

      engine.setCurrentInput(10);
      engine.performOperation('-');
      engine.setCurrentInput(4);
      engine.calculateResult();
      expect(engine.getCurrentInput(), 6);

      engine.setCurrentInput(6);
      engine.performOperation('*');
      engine.setCurrentInput(7);
      engine.calculateResult();
      expect(engine.getCurrentInput(), 42);

      engine.setCurrentInput(20);
      engine.performOperation('/');
      engine.setCurrentInput(4);
      engine.calculateResult();
      expect(engine.getCurrentInput(), 5);
    });

    test('nCr valid and invalid', () {
      final engine = CalculatorEngine();
      engine.setCurrentInput(5);
      engine.nCr();
      engine.setCurrentInput(2);
      engine.calculateResult();
      expect(engine.getCurrentInput(), 10);

      engine.setCurrentInput(2);
      engine.nCr();
      engine.setCurrentInput(5);
      engine.calculateResult();
      expect(engine.getCurrentInput().isNaN, true);
    });

    test('toggle radians degrees', () {
      final engine = CalculatorEngine();
      final initial = engine.useRadians;
      engine.toggleRadiansDegrees();
      expect(engine.useRadians, !initial);
    });
  });
}
