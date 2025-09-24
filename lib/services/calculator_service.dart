import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculatorService extends ChangeNotifier {
  List<String> _history = [];
  static const _kHistoryKey = 'calc_history';

  List<String> get history => List.unmodifiable(_history);

  CalculatorService() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _history = prefs.getStringList(_kHistoryKey) ?? [];
    notifyListeners();
  }

  Future<void> addEntry(String expr, String result) async {
    final entry = '$expr = $result';
    _history.insert(0, entry);
    if (_history.length > 50) _history.removeLast();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kHistoryKey, _history);
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _history.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kHistoryKey);
    notifyListeners();
  }
}
