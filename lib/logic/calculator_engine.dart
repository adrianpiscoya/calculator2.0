import 'dart:math';

class CalculatorEngine {
  String _currentInput = '0';
  double _previousInput = 0;
  String _operation = '';
  double _result = 0;
  bool _useRadians = true;
  double _ans = 0;
  double _preAns = 0;
  bool _newInputStarted = false;
  double _memory = 0;

  String get currentInput => _currentInput;
  bool get useRadians => _useRadians;
  String get ans => _ans.toString();
  String get preAns => _preAns.toString();
  double get memory => _memory;

  void toggleRadiansDegrees() {
    _useRadians = !_useRadians;
  }

  double calculateTrigonometric(String function, double value) {
    double radians = _useRadians ? value : value * pi / 180;
    switch (function) {
      case 'sin':
        return sin(radians);
      case 'cos':
        return cos(radians);
      case 'tan':
        return tan(radians);
      case 'asin':
        return asin(value);
      case 'acos':
        return acos(value);
      case 'atan':
        return atan(value);
      case 'sinh':
        return (exp(value) - exp(-value)) / 2;
      case 'cosh':
        return (exp(value) + exp(-value)) / 2;
      case 'tanh':
        return (exp(value) - exp(-value)) / (exp(value) + exp(-value));
      default:
        return value;
    }
  }

  void performTrigonometric(String function) {
    _currentInput =
        calculateTrigonometric(function, double.tryParse(_currentInput) ?? 0)
            .toString();
  }

  void performInverseTrigonometric(String function) {
    _currentInput =
        calculateTrigonometric(function, double.tryParse(_currentInput) ?? 0)
            .toString();
    if (!_useRadians) {
      double val = double.tryParse(_currentInput) ?? 0;
      _currentInput = (val * 180 / pi).toString();
    }
  }

  void calculateSquareRoot() {
    double val = double.tryParse(_currentInput) ?? 0;
    if (val >= 0) {
      _currentInput = sqrt(val).toString();
    } else {
      _currentInput = 'NaN';
    }
  }

  void square() {
    double val = double.tryParse(_currentInput) ?? 0;
    _currentInput = (val * val).toString();
  }

  void cube() {
    double val = double.tryParse(_currentInput) ?? 0;
    _currentInput = (val * val * val).toString();
  }

  void powerOfY() {
    _previousInput = double.tryParse(_currentInput) ?? 0;
    _currentInput = '0';
    _operation = '^';
    _newInputStarted = false;
  }

  void calculatePowerOfY() {
    _preAns = _ans;
    double val = double.tryParse(_currentInput) ?? 0;
    _result = pow(_previousInput, val).toDouble();
    _ans = _result;
    _currentInput = _result.toString();
    _operation = '';
    _previousInput = 0;
    _newInputStarted = true;
  }

  void cubeRoot() {
    double val = double.tryParse(_currentInput) ?? 0;
    _currentInput = pow(val, 1 / 3).toString();
  }

  void nthRoot() {
    _previousInput = double.tryParse(_currentInput) ?? 0;
    _currentInput = '0';
    _operation = 'ⁿ√';
    _newInputStarted = false;
  }

  void calculateNthRoot() {
    _preAns = _ans;
    double val = double.tryParse(_currentInput) ?? 0;
    if (_previousInput >= 0 || (1 / val).round() % 2 != 0) {
      _result = pow(_previousInput, 1 / val).toDouble();
    } else {
      _result = double.nan;
    }
    _ans = _result;
    _currentInput = _result.toString();
    _operation = '';
    _previousInput = 0;
    _newInputStarted = true;
  }

  void inputDigit(int digit) {
    if (_newInputStarted || _currentInput == '0') {
      _currentInput = digit.toString();
      _newInputStarted = false;
    } else {
      _currentInput += digit.toString();
    }
  }

  void inputDecimal() {
    if (!_currentInput.contains('.')) {
      _currentInput += '.';
    }
  }

  void performOperation(String operation) {
    _previousInput = double.tryParse(_currentInput) ?? 0;
    _currentInput = '0';
    _operation = operation;
    _newInputStarted = false;
  }

  // Notación científica (Exp)
  void inputExp() {
    if (!_currentInput.contains('e')) {
      _currentInput += 'e';
    }
  }

  // Combinatoria nCr
  void nCr() {
    _previousInput = double.tryParse(_currentInput) ?? 0;
    _currentInput = '0';
    _operation = 'nCr';
    _newInputStarted = false;
  }

  // Permutación nPr
  void nPr() {
    _previousInput = double.tryParse(_currentInput) ?? 0;
    _currentInput = '0';
    _operation = 'nPr';
    _newInputStarted = false;
  }

  // Cambiar entre radianes y grados
  void setRadians(bool radians) {
    _useRadians = radians;
  }

  int _factorial(int n) => n <= 1 ? 1 : n * _factorial(n - 1);

  void calculateResult() {
    _preAns = _ans;
    double input = double.tryParse(_currentInput) ?? 0;
    switch (_operation) {
      case '+':
        _result = _previousInput + input;
        break;
      case '-':
        _result = _previousInput - input;
        break;
      case '*':
        _result = _previousInput * input;
        break;
      case '/':
        if (input != 0) {
          _result = _previousInput / input;
        } else {
          _result = double.infinity;
        }
        break;
      case '^':
        _result = pow(_previousInput, input).toDouble();
        break;
      case 'ⁿ√':
        if (_previousInput >= 0 || (1 / input).round() % 2 != 0) {
          _result = pow(_previousInput, 1 / input).toDouble();
        } else {
          _result = double.nan;
        }
        break;
      case 'nCr':
        int n = _previousInput.toInt();
        int r = input.toInt();
        if (n >= r && n >= 0 && r >= 0) {
          _result =
              (_factorial(n) ~/ (_factorial(r) * _factorial(n - r))).toDouble();
        } else {
          _result = double.nan;
        }
        break;
      case 'nPr':
        int n = _previousInput.toInt();
        int r = input.toInt();
        if (n >= r && n >= 0 && r >= 0) {
          _result = (_factorial(n) ~/ _factorial(n - r)).toDouble();
        } else {
          _result = double.nan;
        }
        break;
      default:
        _result = input;
    }
    _ans = _result;
    _currentInput = _result.toString().replaceAll(RegExp(r'\\.0+\$'), '');
    _operation = '';
    _previousInput = 0;
    _newInputStarted = true;
  }

  void clear() {
    _currentInput = '0';
    _newInputStarted = false;
  }

  void allClear() {
    _currentInput = '0';
    _previousInput = 0;
    _operation = '';
    _result = 0;
    _ans = 0;
    _preAns = 0;
    _newInputStarted = false;
    _memory = 0;
  }

  void recallAns() {
    _currentInput = _ans.toString().replaceAll(RegExp(r'\\.0+\$'), '');
    _newInputStarted = true;
  }

  void recallPreAns() {
    _currentInput = _preAns.toString().replaceAll(RegExp(r'\\.0+\$'), '');
    _newInputStarted = true;
  }

  void toggleSign() {
    if (_currentInput != '0') {
      if (_currentInput.startsWith('-')) {
        _currentInput = _currentInput.substring(1);
      } else {
        _currentInput = '-$_currentInput';
      }
    } else {
      _currentInput = '-0';
    }
  }

  void memoryClear() {
    _memory = 0;
  }

  void memoryRecall() {
    _currentInput = _memory.toString().replaceAll(RegExp(r'\\.0+\$'), '');
    _newInputStarted = true;
  }

  void memoryAdd() {
    _memory += double.tryParse(_currentInput) ?? 0;
  }

  void memorySubtract() {
    _memory -= double.tryParse(_currentInput) ?? 0;
  }

  void memoryStore() {
    _memory = double.tryParse(_currentInput) ?? 0;
  }

  double getCurrentInput() => double.tryParse(_currentInput) ?? 0;
  void setCurrentInput(double value) =>
      _currentInput = value.toString().replaceAll(RegExp(r'\\.0+\$'), '');
}
