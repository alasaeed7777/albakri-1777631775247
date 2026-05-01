```dart
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ø­Ø§Ø³Ø¨Ù',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blueGrey,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  double _firstOperand = 0;
  String _operator = '';
  bool _isOperatorPressed = false;
  String _history = '';

  void _onDigitPressed(String digit) {
    setState(() {
      if (_isOperatorPressed || _display == '0') {
        _display = digit;
        _isOperatorPressed = false;
      } else {
        _display += digit;
      }
    });
  }

  void _onOperatorPressed(String op) {
    setState(() {
      if (_operator.isNotEmpty && !_isOperatorPressed) {
        _calculateResult();
      }
      _firstOperand = double.parse(_display);
      _operator = op;
      _isOperatorPressed = true;
      _history = '$_firstOperand $op';
    });
  }

  void _onDecimalPressed() {
    setState(() {
      if (!_display.contains('.')) {
        _display += '.';
      }
    });
  }

  void _onClearPressed() {
    setState(() {
      _display = '0';
      _firstOperand = 0;
      _operator = '';
      _isOperatorPressed = false;
      _history = '';
    });
  }

  void _onDeletePressed() {
    setState(() {
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
      } else {
        _display = '0';
      }
    });
  }

  void _onPercentagePressed() {
    setState(() {
      final value = double.parse(_display) / 100;
      _display = _formatNumber(value);
    });
  }

  void _onSquareRootPressed() {
    setState(() {
      final value = double.parse(_display);
      if (value >= 0) {
        _display = _formatNumber(sqrt(value));
      } else {
        _display = 'Error';
      }
    });
  }

  void _onPowerPressed() {
    setState(() {
      final value = double.parse(_display);
      _display = _formatNumber(value * value);
    });
  }

  void _onReciprocalPressed() {
    setState(() {
      final value = double.parse(_display);
      if (value != 0) {
        _display = _formatNumber(1 / value);
      } else {
        _display = 'Error';
      }
    });
  }

  void _onNegatePressed() {
    setState(() {
      final value = double.parse(_display);
      _display = _formatNumber(-value);
    });
  }

  void _calculateResult() {
    if (_operator.isEmpty) return;
    final secondOperand = double.parse(_display);
    double result;
    switch (_operator) {
      case '+':
        result = _firstOperand + secondOperand;
        break;
      case '-':
        result = _firstOperand - secondOperand;
        break;
      case 'Ã':
        result = _firstOperand * secondOperand;
        break;
      case 'Ã·':
        if (secondOperand == 0) {
          _display = 'Error';
          _operator = '';
          _isOperatorPressed = true;
          _history = '';
          return;
        }
        result = _firstOperand / secondOperand;
        break;
      default:
        return;
    }
    _history = '$_firstOperand $_operator $secondOperand =';
    _display = _formatNumber(result);
    _operator = '';
    _isOperatorPressed = true;
  }

  String _formatNumber(double number) {
    if (number == number.floor() && !number.isInfinite && !number.isNaN) {
      return number.toInt().toString();
    }
    return number.toStringAsFixed(6).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  void _onEqualsPressed() {
    setState(() {
      _calculateResult();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Display area
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _history,
                      style: TextStyle(
                        fontSize: 20,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _display,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w300,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Button grid
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  _buildButtonRow([
                    _CalculatorButton('C', ButtonType.function, _onClearPressed),
                    _CalculatorButton('â«', ButtonType.function, _onDeletePressed),
                    _CalculatorButton('%', ButtonType.function, _onPercentagePressed),
                    _CalculatorButton('Ã·', ButtonType.operator, () => _onOperatorPressed('Ã·')),
                  ]),
                  _buildButtonRow([
                    _CalculatorButton('7', ButtonType.number, () => _onDigitPressed('7')),
                    _CalculatorButton('8', ButtonType.number, () => _onDigitPressed('8')),
                    _CalculatorButton('9', ButtonType.number, () => _onDigitPressed('9')),
                    _CalculatorButton('Ã', ButtonType.operator, () => _onOperatorPressed('Ã')),
                  ]),
                  _buildButtonRow([
                    _CalculatorButton('4', ButtonType.number, () => _onDigitPressed('4')),
                    _CalculatorButton('5', ButtonType.number, () => _onDigitPressed('5')),
                    _CalculatorButton('6', ButtonType.number, () => _onDigitPressed('6')),
                    _CalculatorButton('-', ButtonType.operator, () => _onOperatorPressed('-')),
                  ]),
                  _buildButtonRow([
                    _CalculatorButton('1', ButtonType.number, () => _onDigitPressed('1')),
                    _CalculatorButton('2', ButtonType.number, () => _onDigitPressed('2')),
                    _CalculatorButton('3', ButtonType.number, () => _onDigitPressed('3')),
                    _CalculatorButton('+', ButtonType.operator, () => _onOperatorPressed('+')),
                  ]),
                  _buildButtonRow([
                    _CalculatorButton('Â±', ButtonType.function, _onNegatePressed),
                    _CalculatorButton('0', ButtonType.number, () => _onDigitPressed('0')),
                    _CalculatorButton('.', ButtonType.number, _onDecimalPressed),
                    _CalculatorButton('=', ButtonType.equals, _onEqualsPressed),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonRow(List<_CalculatorButton> buttons) {
    return Row(
      children: buttons.map((button) => Expanded(child: _buildButton(button))).toList(),
    );
  }

  Widget _buildButton(_CalculatorButton button) {
    final colorScheme = Theme.of(context).colorScheme;

    Color backgroundColor;
    Color foregroundColor;

    switch (button.type) {
      case ButtonType.number:
        backgroundColor = colorScheme.surfaceVariant;
        foregroundColor = colorScheme.onSurfaceVariant;
        break;
      case ButtonType.operator:
        backgroundColor = colorScheme.primaryContainer;
        foregroundColor = colorScheme.onPrimaryContainer;
        break;
      case ButtonType.function:
        backgroundColor = colorScheme.secondaryContainer;
        foregroundColor = colorScheme.onSecondaryContainer;
        break;
      case ButtonType.equals:
        backgroundColor = colorScheme.primary;
        foregroundColor = colorScheme.onPrimary;
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(4),
      child: SizedBox(
        height: 72,
        child: Material(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: button.onPressed,
            child: Center(
              child: Text(
                button.label,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: foregroundColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum ButtonType { number, operator, function, equals }

class _CalculatorButton {
  final String label;
  final ButtonType type;
  final VoidCallback onPressed;

  const _CalculatorButton(this.label, this.type, this.onPressed);
}
```