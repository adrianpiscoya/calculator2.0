import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/banner_ad_widget.dart';

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _selectedCategory = 'Longitud';
  String _fromUnit = 'Metros';
  String _toUnit = 'Kilómetros';
  double? _result;
  String _errorMessage = '';

  final Map<String, Map<String, double>> _categories = {
    'Longitud': {
      'Metros': 1.0,
      'Kilómetros': 1000.0,
      'Centímetros': 0.01,
      'Milímetros': 0.001,
      'Pies': 0.3048,
      'Pulgadas': 0.0254,
      'Yardas': 0.9144,
      'Millas': 1609.34,
    },
    'Masa': {
      'Kilos': 1.0,
      'Gramos': 0.001,
      'Miligramos': 0.000001,
      'Toneladas': 1000.0,
      'Libras': 0.453592,
      'Onzas': 0.0283495,
    },
    'Tiempo': {
      'Segundos': 1.0,
      'Minutos': 60.0,
      'Horas': 3600.0,
      'Días': 86400.0,
      'Semanas': 604800.0,
      'Años': 31557600.0, // Año promedio corregido
    },
    'Área': {
      'm²': 1.0,
      'cm²': 0.0001,
      'mm²': 0.000001,
      'km²': 1000000.0,
      'Hectáreas': 10000.0,
      'Pies²': 0.092903,
    },
    'Volumen': {
      'm³': 1.0,
      'Litros': 0.001,
      'Mililitros': 0.000001,
      'Galones': 0.00378541,
      'Pintas': 0.000473176,
      'Tazas': 0.000236588,
    },
    'Velocidad': {
      'm/s': 1.0,
      'km/h': 0.277778,
      'mph': 0.44704,
      'nudos': 0.514444,
      'pies/s': 0.3048,
    },
    'Presión': {
      'Pascales': 1.0,
      'Atmósferas': 101325.0,
      'Bares': 100000.0,
      'PSI': 6894.76,
      'mmHg': 133.322,
    },
  };

  List<String> _history = [];

  // ----------------- Temperatura: funciones puras -----------------
  static double _celsiusToFahrenheit(double c) => (c * 9 / 5) + 32;
  static double _celsiusToKelvin(double c) => c + 273.15;
  static double _fahrenheitToCelsius(double f) => (f - 32) * 5 / 9;
  static double _fahrenheitToKelvin(double f) =>
      _fahrenheitToCelsius(f) + 273.15;
  static double _kelvinToCelsius(double k) => k - 273.15;
  static double _kelvinToFahrenheit(double k) =>
      (_kelvinToCelsius(k) * 9 / 5) + 32;

  double _convertTemperature(double input, String from, String to) {
    if (from == to) return input;
    if (from == 'Celsius' && to == 'Fahrenheit')
      return _celsiusToFahrenheit(input);
    if (from == 'Celsius' && to == 'Kelvin') return _celsiusToKelvin(input);
    if (from == 'Fahrenheit' && to == 'Celsius')
      return _fahrenheitToCelsius(input);
    if (from == 'Fahrenheit' && to == 'Kelvin')
      return _fahrenheitToKelvin(input);
    if (from == 'Kelvin' && to == 'Celsius') return _kelvinToCelsius(input);
    if (from == 'Kelvin' && to == 'Fahrenheit')
      return _kelvinToFahrenheit(input);
    throw Exception('Conversión de temperatura no soportada');
  }

  // ----------------- Init / Historial / Créditos -----------------
  @override
  void initState() {
    super.initState();
    _inputController.addListener(_onInputChanged);
    _loadConversionHistory();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    // Tutorial removido - funcionalidad obvia
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_time_converter', false);
  }

  Future<void> _loadConversionHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('conversion_history') ?? [];
    // Credits removed: no-op here (was previously tracked visually)
    setState(() => _history = history);
  }

  Future<void> _saveToHistory(
      String input, String from, String to, double result) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('conversion_history') ?? [];
    final formatted =
        _formatResult(result, category: _selectedCategory, unit: to);
    final entry = _selectedCategory == 'Tiempo'
        ? '$input $from → $formatted'
        : '$input $from → $formatted $to';
    history.insert(0, entry);
    if (history.length > 50) history.removeLast();
    await prefs.setStringList('conversion_history', history);
    setState(() => _history = history);
  }

  void _showHistoryDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Historial de Conversiones',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
            fontSize: 20,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: _history.isEmpty
              ? const Text(
                  'No hay conversiones guardadas.',
                  style: TextStyle(color: Colors.black54),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _history.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: const Icon(Icons.history, color: Colors.blue),
                    title: Text(
                      _history[index],
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cerrar',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------- UI Helpers -----------------
  void _onInputChanged() {
    setState(() {
      _errorMessage = '';
      _result = null;
    });
  }

  void _swapUnits() {
    setState(() {
      final temp = _fromUnit;
      _fromUnit = _toUnit;
      _toUnit = temp;
      _result = null;
    });
  }

  void _onCategoryChanged(String? value) {
    if (value == null) return;
    setState(() {
      _selectedCategory = value;
      if (value == 'Temperatura') {
        _fromUnit = 'Celsius';
        _toUnit = 'Fahrenheit';
      } else {
        final units = _categories[value]!.keys.toList();
        _fromUnit = units.first;
        _toUnit = units.length > 1 ? units[1] : units.first;
      }
      _result = null;
      _errorMessage = '';
      _inputController.clear();
    });
  }

  void _onFromChanged(String? value) {
    if (value == null) return;
    setState(() {
      _fromUnit = value;
      _result = null;
    });
  }

  void _onToChanged(String? value) {
    if (value == null) return;
    setState(() {
      _toUnit = value;
      _result = null;
    });
  }

  // ----------------- Conversión -----------------
  void _convert() async {
    setState(() {
      _errorMessage = '';
      _result = null;
    });

    final inputStr = _inputController.text.trim();
    if (inputStr.isEmpty) {
      setState(() => _errorMessage = '¡Ingresa un valor! Ej: 100');
      return;
    }

    final input = double.tryParse(inputStr);
    if (input == null) {
      setState(() => _errorMessage = 'Número inválido');
      return;
    }

    if (input < 0 && _selectedCategory != 'Temperatura') {
      setState(
          () => _errorMessage = 'Solo valores positivos (salvo Temperatura)');
      return;
    }

    try {
      double result;
      if (_selectedCategory == 'Temperatura') {
        result = _convertTemperature(input, _fromUnit, _toUnit);
      } else {
        final category = _categories[_selectedCategory];
        if (category == null) throw Exception('Categoría no encontrada');
        final factorFrom = category[_fromUnit];
        final factorTo = category[_toUnit];
        if (factorFrom == null || factorTo == null)
          throw Exception('Unidad no válida');
        result = input * (factorFrom / factorTo);
      }

      setState(() => _result = result);
      await _saveToHistory(inputStr, _fromUnit, _toUnit, result);
      if (!mounted) return;
      final formatted =
          _formatResult(result, category: _selectedCategory, unit: _toUnit);
      final display =
          '${formatted}${_selectedCategory == 'Tiempo' ? '' : ' $_toUnit'}';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.blue,
          content: Text(
            'Resultado: $display',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } catch (e) {
      setState(() => _errorMessage = 'Error en conversión: $e');
    }
  }

  String _formatTimeResult(double value, String toUnit) {
    if (toUnit == 'Segundos') {
      final totalSec = value.round();
      final h = totalSec ~/ 3600;
      final rem = totalSec % 3600;
      final m = rem ~/ 60;
      final s = rem % 60;
      final parts = <String>[];
      if (h > 0) parts.add('${h}h');
      if (m > 0) parts.add('${m}min');
      if (s > 0 || parts.isEmpty) parts.add('${s}s');
      return parts.join(' ');
    }

    if (toUnit == 'Minutos') {
      final totalSec = (value * 60).round();
      final h = totalSec ~/ 3600;
      final rem = totalSec % 3600;
      final m = rem ~/ 60;
      final s = rem % 60;
      final parts = <String>[];
      if (h > 0) parts.add('${h}h');
      if (m > 0) parts.add('${m}min');
      if (s > 0) parts.add('${s}s');
      if (parts.isEmpty) parts.add('0s');
      return parts.join(' ');
    }

    final totalSec = (value * 3600).round();
    final h = totalSec ~/ 3600;
    final rem = totalSec % 3600;
    final m = rem ~/ 60;
    final s = rem % 60;
    final parts = <String>[];
    if (h > 0) parts.add('${h}h');
    if (m > 0) parts.add('${m}min');
    if (s > 0) parts.add('${s}s');
    if (parts.isEmpty) parts.add('0s');
    return parts.join(' ');
  }

  String _formatResult(double value, {String? category, String? unit}) {
    if (category == 'Temperatura' ||
        (unit != null && ['Celsius', 'Fahrenheit', 'Kelvin'].contains(unit))) {
      return _formatTemperatureResult(value, unit ?? 'Celsius');
    }
    if (category == 'Tiempo' ||
        (unit != null && ['Segundos', 'Minutos', 'Horas'].contains(unit))) {
      return _formatTimeResult(value, unit ?? 'Segundos');
    }
    if (category == 'Longitud' ||
        (unit != null && _categories['Longitud']?.containsKey(unit) == true)) {
      return _formatLengthResult(value, unit ?? 'Metros');
    }
    if (category == 'Masa' ||
        (unit != null && _categories['Masa']?.containsKey(unit) == true)) {
      return _formatMassResult(value, unit ?? 'Kilos');
    }
    if (category == 'Volumen' ||
        (unit != null && _categories['Volumen']?.containsKey(unit) == true)) {
      return _formatVolumeResult(value, unit ?? 'm³');
    }
    if (category == 'Área' ||
        (unit != null && _categories['Área']?.containsKey(unit) == true)) {
      return _formatAreaResult(value, unit ?? 'm²');
    }

    if (value == value.toInt()) return value.toInt().toString();
    if (value.abs() < 1) return value.toStringAsFixed(6);
    if (value.abs() < 1000) return value.toStringAsFixed(4);
    return value.toStringAsFixed(2);
  }

  String _formatLengthResult(double value, String toUnit) {
    return _formatGenericResult(value);
  }

  String _formatMassResult(double value, String toUnit) {
    return _formatGenericResult(value);
  }

  String _formatVolumeResult(double value, String toUnit) {
    return _formatGenericResult(value);
  }

  String _formatAreaResult(double value, String toUnit) {
    return _formatGenericResult(value);
  }

  String _formatGenericResult(double value) {
    if (value == value.toInt()) {
      return '${value.toInt()}';
    } else if (value > 1000) {
      return value.toStringAsFixed(0);
    } else if (value > 1) {
      return value.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '');
    } else {
      return value.toStringAsFixed(4).replaceAll(RegExp(r'\.?0+$'), '');
    }
  }

  String _formatTemperatureResult(double value, String toUnit) {
    final v = (value * 10).round() / 10.0;
    if (toUnit == 'Celsius') return '$v °C';
    if (toUnit == 'Fahrenheit') return '$v °F';
    return '${v.toStringAsFixed(1)} K';
  }

  // ----------------- Manejo de salida (async seguro) -----------------
  Future<bool> _handleWillPop() async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final isTemperature = _selectedCategory == 'Temperatura';
    final units = isTemperature
        ? ['Celsius', 'Fahrenheit', 'Kelvin']
        : _categories[_selectedCategory]!.keys.toList();

    final theme = Theme.of(context);

    return PopScope(
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        await _handleWillPop();
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: theme.colorScheme.primary,
          elevation: 0,
          title: const Text(
            'Unit Converter - Advanced Calculator',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.history, color: Colors.white),
              onPressed: _showHistoryDialog,
              tooltip: 'Ver historial',
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                      color:
                          theme.dividerColor.withAlpha((0.12 * 255).round())),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox.shrink(),
                      const SizedBox(height: 16),
                      Semantics(
                        label: 'Seleccionar categoría de conversión',
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedCategory,
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: '1. Categoría',
                            prefixIcon: Icon(Icons.category,
                                color: theme.colorScheme.primary),
                            filled: true,
                            fillColor: theme.colorScheme.primary
                                .withAlpha((0.05 * 255).round()),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: theme.colorScheme.primary,
                                    width: 2)),
                            labelStyle:
                                TextStyle(color: theme.colorScheme.primary),
                          ),
                          items: [
                            ..._categories.keys.map((k) => DropdownMenuItem(
                                  value: k,
                                  child: Text(
                                    k,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        const TextStyle(color: Colors.black87),
                                  ),
                                )),
                            const DropdownMenuItem(
                              value: 'Temperatura',
                              child: Text(
                                'Temperatura',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.black87),
                              ),
                            ),
                          ],
                          onChanged: _onCategoryChanged,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Semantics(
                        label:
                            'Campo para ingresar el valor a convertir en $_fromUnit',
                        child: TextFormField(
                          controller: _inputController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true, signed: true),
                          decoration: InputDecoration(
                            labelText: isTemperature
                                ? 'Valor en $_fromUnit (ej: 25)'
                                : '2. Valor en $_fromUnit (ej: 100)',
                            prefixIcon: Icon(Icons.input,
                                color: theme.colorScheme.primary),
                            filled: true,
                            fillColor: theme.colorScheme.primary
                                .withAlpha((0.05 * 255).round()),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            helperText: 'Usa punto (.) para decimales',
                            helperStyle: const TextStyle(color: Colors.black54),
                            errorText:
                                _errorMessage.isNotEmpty ? _errorMessage : null,
                            errorStyle:
                                const TextStyle(color: Colors.redAccent),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: theme.colorScheme.primary,
                                    width: 2)),
                            labelStyle:
                                TextStyle(color: theme.colorScheme.primary),
                          ),
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Semantics(
                              label: 'Unidad de origen',
                              child: DropdownButtonFormField<String>(
                                initialValue: _fromUnit,
                                isExpanded: true,
                                decoration: InputDecoration(
                                  labelText: 'De ($_fromUnit)',
                                  prefixIcon: Icon(Icons.arrow_downward,
                                      color: theme.colorScheme.primary),
                                  filled: true,
                                  fillColor: theme.colorScheme.primary
                                      .withAlpha((0.05 * 255).round()),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: theme.colorScheme.primary,
                                          width: 2)),
                                  labelStyle: TextStyle(
                                      color: theme.colorScheme.primary),
                                ),
                                items: units
                                    .map((u) => DropdownMenuItem(
                                        value: u,
                                        child: Text(u,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.black87))))
                                    .toList(),
                                onChanged: _onFromChanged,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.primary
                                  .withAlpha((0.1 * 255).round()),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.swap_horiz,
                                  color: theme.colorScheme.primary),
                              onPressed: _swapUnits,
                              tooltip: 'Intercambiar unidades',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Semantics(
                              label: 'Unidad de destino',
                              child: DropdownButtonFormField<String>(
                                initialValue: _toUnit,
                                isExpanded: true,
                                decoration: InputDecoration(
                                  labelText: 'A ($_toUnit)',
                                  prefixIcon: Icon(Icons.arrow_upward,
                                      color: theme.colorScheme.primary),
                                  filled: true,
                                  fillColor: theme.colorScheme.primary
                                      .withAlpha((0.05 * 255).round()),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: theme.colorScheme.primary,
                                          width: 2)),
                                  labelStyle: TextStyle(
                                      color: theme.colorScheme.primary),
                                ),
                                items: units
                                    .map((u) => DropdownMenuItem(
                                        value: u,
                                        child: Text(u,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.black87))))
                                    .toList(),
                                onChanged: _onToChanged,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (MediaQuery.of(context).size.width < 600) ...[
                        const SizedBox(height: 12),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.primary
                                  .withAlpha((0.08 * 255).round()),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.swap_horiz,
                                  color: theme.colorScheme.primary),
                              onPressed: _swapUnits,
                              tooltip: 'Intercambiar unidades',
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _convert,
                        icon: const Icon(Icons.calculate,
                            size: 24, color: Colors.white),
                        label: const Text(
                          'Convertir',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 16),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) =>
                            FadeTransition(opacity: animation, child: child),
                        child: _result != null
                            ? Container(
                                key: const ValueKey('result'),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: theme.cardColor,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Color(0x0A000000),
                                        blurRadius: 8,
                                        offset: Offset(0, 3)),
                                  ],
                                  border: Border.all(
                                      color: theme.dividerColor
                                          .withAlpha((0.12 * 255).round())),
                                ),
                                child: Builder(builder: (context) {
                                  final formatted = _formatResult(_result!,
                                      category: _selectedCategory,
                                      unit: _toUnit);
                                  final display =
                                      "${formatted}${_selectedCategory == 'Tiempo' ? '' : ' $_toUnit'}";
                                  return Text(
                                    '${_inputController.text} $_fromUnit = $display',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                    textAlign: TextAlign.center,
                                  );
                                }),
                              )
                            : const SizedBox.shrink(),
                      ),
                      const SizedBox(height: 16),
                      const SizedBox(height: 12),
                      Center(child: BannerAdWidget()),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}
