import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// credit service removed
import '../widgets/banner_ad_widget.dart';

class ExchangeScreen extends StatefulWidget {
  const ExchangeScreen({Key? key}) : super(key: key);

  @override
  State<ExchangeScreen> createState() => _ExchangeScreenState();
}

class _ExchangeScreenState extends State<ExchangeScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _from = 'USD';
  String _to = 'EUR';
  double _result = 0.0;
  double _lastUsedRate = 0.0;
  int _credits = 0;
  bool _isLoading = false;
  String _errorMessage = '';

  // Lista de monedas soportadas (fácil de extender)
  final List<String> _currencies = [
    'USD',
    'EUR',
    'ARS',
    'PEN',
    'GBP',
    'JPY',
    'CAD',
    'AUD',
    'MXN',
    'BRL',
    'CHF',
  ];

  // Tasas base relativas a USD. Para convertir de A a B: rate = base[B] / base[A]
  final Map<String, double> _baseRates = {
    'USD': 1.0,
    'EUR': 0.92,
    'ARS': 350.0,
    'PEN': 3.7,
    'GBP': 0.79,
    'JPY': 157.0,
    'CAD': 1.35,
    'AUD': 1.47,
    'MXN': 17.5,
    'BRL': 5.1,
    'CHF': 0.92,
  };

  bool _ratesLoading = false;
  String? _ratesLastUpdated;

  // Cargar tasas cacheadas de SharedPreferences
  Future<void> _loadCachedRates() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('cached_base_rates');
      if (raw != null) {
        final Map<String, dynamic> m = json.decode(raw) as Map<String, dynamic>;
        if (m.isNotEmpty) {
          setState(() {
            m.forEach((k, v) => _baseRates[k] = (v as num).toDouble());
          });
        }
      }
    } catch (_) {}
  }

  // Obtener tasas desde exchangerate.host (base USD) y cachearlas
  Future<void> _fetchRates() async {
    setState(() => _ratesLoading = true);

    // Usar open.er-api.com por defecto (no requiere clave) y exchangerate.host como fallback
    bool succeeded = false;
    try {
      final uri = Uri.parse('https://open.er-api.com/v6/latest/USD');
      final res = await http.get(uri).timeout(const Duration(seconds: 8));
      if (res.statusCode == 200) {
        final data = json.decode(res.body) as Map<String, dynamic>;
        final rates = (data['rates'] as Map<String, dynamic>?) ?? {};
        final Map<String, double> updated = {};
        for (final cur in _currencies) {
          final val = rates[cur];
          if (val != null) updated[cur] = (val as num).toDouble();
        }
        if (updated.isNotEmpty) {
          setState(() {
            updated.forEach((k, v) => _baseRates[k] = v);
            _ratesLastUpdated = DateTime.now().toIso8601String();
          });
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('cached_base_rates', json.encode(_baseRates));
          debugPrint(
              'Exchange: rates updated (open.er-api.com): ${updated.keys.join(', ')}');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Tasas actualizadas desde open.er-api.com'),
              duration: Duration(seconds: 2),
            ));
          }
          succeeded = true;
        }
      }
    } catch (e) {
      debugPrint('Exchange: open.er-api.com failed: $e');
    }

    // Fallback: intentar exchangerate.host si el anterior falló
    if (!succeeded) {
      try {
        final uri2 = Uri.parse('https://api.exchangerate.host/latest?base=USD');
        final res2 = await http.get(uri2).timeout(const Duration(seconds: 8));
        if (res2.statusCode == 200) {
          final data2 = json.decode(res2.body) as Map<String, dynamic>;
          if (data2['success'] == false)
            throw Exception(
                'exchangerate.host error: ${data2['error'] ?? 'unknown'}');
          final rates = (data2['rates'] as Map<String, dynamic>?) ?? {};
          final Map<String, double> updated = {};
          for (final cur in _currencies) {
            final val = rates[cur];
            if (val != null) updated[cur] = (val as num).toDouble();
          }
          if (updated.isNotEmpty) {
            setState(() {
              updated.forEach((k, v) => _baseRates[k] = v);
              _ratesLastUpdated = DateTime.now().toIso8601String();
            });
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('cached_base_rates', json.encode(_baseRates));
            debugPrint(
                'Exchange: rates updated (exchangerate.host): ${updated.keys.join(', ')}');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Tasas actualizadas desde exchangerate.host'),
                duration: Duration(seconds: 2),
              ));
            }
            succeeded = true;
          }
        }
      } catch (e) {
        debugPrint('Exchange: exchangerate.host failed: $e');
      }
    }

    // Si nada funcionó, avisar y usar caché/valores locales
    if (!succeeded && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'No se pudo actualizar las tasas. Usando valores locales o caché.'),
        duration: Duration(seconds: 3),
      ));
    }

    if (mounted) setState(() => _ratesLoading = false);
  }

  @override
  void initState() {
    super.initState();
    _loadCredits();
    _loadCachedRates();
    // Buscar tasas en background
    _fetchRates();
    // Nota: la deducción ya se realiza centralmente desde el HomeScreen al navegar.
  }

  Future<void> _loadCredits() async {
    // créditos removidos: mantener _credits en 0 o eliminar uso
    if (mounted) setState(() => _credits = 0);
  }

  Future<void> _convert() async {
    setState(() {
      _errorMessage = '';
      _isLoading = true;
    });

    final amtStr = _amountController.text.trim().replaceAll(',', '.');
    final amt = double.tryParse(amtStr) ?? 0.0;
    if (amt <= 0) {
      setState(() {
        _errorMessage = 'Ingresa un monto válido mayor a 0.';
        _isLoading = false;
      });
      return;
    }

    // Nota: la deducción de crédito ocurre al entrar a la pantalla (initState)

    // Usar tasas base para calcular el tipo cruzado
    final fromBase = _baseRates[_from] ?? 1.0;
    final toBase = _baseRates[_to] ?? 1.0;
    final usedRate = toBase / fromBase;
    _lastUsedRate = usedRate;
    final newResult = amt * usedRate;

    // Actualizar resultado sin bloquear
    if (mounted) {
      setState(() {
        _result = newResult;
        _isLoading = false;
        _errorMessage = '';
      });
    }

    // Guardar en el historial local de divisas
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'exchange_history';
      final List<String> hist = prefs.getStringList(key) ?? [];
      final entry =
          '${DateTime.now().toIso8601String()} | ${amt.toStringAsFixed(2)} $_from → ${newResult.toStringAsFixed(2)} $_to (rate ${usedRate.toStringAsFixed(6)})';
      hist.insert(0, entry);
      if (hist.length > 100) hist.removeLast();
      await prefs.setStringList(key, hist);
    } catch (_) {
      // no bloquear en caso de fallo
    }

    // No se deduce crédito al convertir: la conversión es gratuita si ya pagaste al entrar
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _openHistoryDialog() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hist = prefs.getStringList('exchange_history') ?? [];
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Historial de Divisas'),
          content: SizedBox(
            width: double.maxFinite,
            child: hist.isEmpty
                ? const Text('No hay historial')
                : ListView(
                    shrinkWrap: true,
                    children:
                        hist.map((e) => ListTile(title: Text(e))).toList(),
                  ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar')),
            if (hist.isNotEmpty)
              TextButton(
                  onPressed: () async {
                    await prefs.remove('exchange_history');
                    if (!mounted) return;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Historial borrado')));
                  },
                  child: const Text('Borrar todo'))
          ],
        ),
      );
    } catch (_) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('No disponible')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Colors.blue;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text(
          'Currency Exchange - Advanced Calculator',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            tooltip: 'Historial',
            onPressed: () => _openHistoryDialog(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.04 * 255).round()),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Convierte divisas fácilmente',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: Container()),
                          TextButton.icon(
                            onPressed:
                                _ratesLoading ? null : () => _fetchRates(),
                            icon: _ratesLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2))
                                : const Icon(Icons.refresh),
                            label: const Text('Actualizar tasas'),
                          ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: _ratesLoading
                                ? null
                                : () async {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.remove('cached_base_rates');
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text('Caché limpiada'),
                                              duration: Duration(seconds: 1)));
                                    }
                                    _fetchRates();
                                  },
                            icon: const Icon(Icons.delete_outline),
                            label: const Text('Limpiar caché'),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _from,
                              items: _currencies
                                  .map((c) => DropdownMenuItem(
                                      value: c, child: Text(c)))
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _from = v ?? _from),
                              decoration: InputDecoration(
                                labelText: 'De',
                                prefixIcon: Icon(Icons.currency_exchange,
                                    color: primary),
                                filled: true,
                                fillColor:
                                    primary.withAlpha((0.05 * 255).round()),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _to,
                              items: _currencies
                                  .map((c) => DropdownMenuItem(
                                      value: c, child: Text(c)))
                                  .toList(),
                              onChanged: (v) => setState(() => _to = v ?? _to),
                              decoration: InputDecoration(
                                labelText: 'A',
                                prefixIcon:
                                    Icon(Icons.arrow_forward, color: primary),
                                filled: true,
                                fillColor:
                                    primary.withAlpha((0.05 * 255).round()),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Monto',
                          prefixIcon: Icon(Icons.money, color: primary),
                          filled: true,
                          fillColor: primary.withAlpha((0.05 * 255).round()),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          helperText: 'Usa punto (.) para decimales',
                          errorText:
                              _errorMessage.isNotEmpty ? _errorMessage : null,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: _isLoading ? null : _convert,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.calculate),
                        label:
                            Text(_isLoading ? 'Convirtiendo...' : 'Convertir'),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text('Resultado: ${_result.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(height: 6),
                              if (_lastUsedRate > 0)
                                Text(
                                    'Tipo: 1 $_from = ${_lastUsedRate.toStringAsFixed(6)} $_to',
                                    style: const TextStyle(
                                        color: Colors.black54, fontSize: 13)),
                              const SizedBox(height: 8),
                              Text('De: $_from  →  A: $_to',
                                  style:
                                      const TextStyle(color: Colors.black54)),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('Créditos: $_credits',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54)),
                                    if (_ratesLastUpdated != null)
                                      Text(
                                          'Tasas: ${_ratesLastUpdated!.split('T').first} ${_ratesLastUpdated!.split('T').last.split('.').first}',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.black38)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(child: BannerAdWidget()),
                      const SizedBox(height: 12),
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
}
