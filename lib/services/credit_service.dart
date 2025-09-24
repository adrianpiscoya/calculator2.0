import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class CreditService {
  static const String _creditsKey = 'creditos';
  static const int _initialCredits = 10;
  // Persistir marca de tiempo para evitar doble descuento entre instancias rápidas
  static const String _lastDeductPrefsKey = 'last_deduct_ts';
  // simple in-process debounce to avoid accidental double writes (increase to 2s)
  static const int _deductDebounceMs = 2000;
  // simple in-process lock to avoid overlapping deduct operations
  static bool _deductInProgress = false;
  // Marca en memoria para evitar cobrar más de una vez por sesión al abrir la app
  static bool _appOpenCharged = false;

  static Future<int> getCredits() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_creditsKey) ?? _initialCredits;
  }

  static Future<bool> hasEnoughCredits() async {
    try {
      final credits = await getCredits();
      return credits >= 1;
    } catch (e) {
      debugPrint('Error checking credits: $e');
      return false;
    }
  }

  static Future<bool> deductCredit() async {
    try {
      debugPrint('deductCredit: called');
      // check persistent timestamp first to avoid cross-process double-deduct
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now().millisecondsSinceEpoch;
      final persisted = prefs.getInt(_lastDeductPrefsKey) ?? 0;
      debugPrint(
          'deductCredit: now=$now persisted=$persisted _deductInProgress=$_deductInProgress');
      if (now - persisted < _deductDebounceMs) {
        debugPrint(
            'deductCredit ignored due to persistent debounce (${now - persisted}ms)');
        return false;
      }

      if (_deductInProgress) {
        debugPrint('deductCredit ignored: operation already in progress');
        return false;
      }
      _deductInProgress = true;

      // double-check persisted timestamp after acquiring lock (race safety)
      final now2 = DateTime.now().millisecondsSinceEpoch;
      final persisted2 = prefs.getInt(_lastDeductPrefsKey) ?? 0;
      if (now2 - persisted2 < _deductDebounceMs) {
        debugPrint(
            'deductCredit ignored after lock due to persistent debounce (${now2 - persisted2}ms)');
        _deductInProgress = false;
        return false;
      }

      final credits = await getCredits();
      if (credits >= 1) {
        await prefs.setInt(_creditsKey, credits - 1);
        // store persisted timestamp
        await prefs.setInt(_lastDeductPrefsKey, now2);
        debugPrint(
            'deductCredit: credits decreased from $credits to ${credits - 1}');
        _deductInProgress = false;
        return true;
      } else {
        debugPrint('deductCredit: insufficient credits ($credits)');
      }
      _deductInProgress = false;
      return false;
    } catch (e) {
      debugPrint('Error deducting credit: $e');
      _deductInProgress = false;
      return false;
    }
  }

  // Intentar cobrar una vez por sesión al abrir la app. Devuelve true si se pudo cobrar.
  static Future<bool> deductOnAppOpen() async {
    if (_appOpenCharged) {
      debugPrint('deductOnAppOpen: already charged this session');
      return true; // ya cobrado en esta sesión, permitir acceso
    }
    // Reusar la lógica existente: intentamos descontar un crédito
    final ok = await deductCredit();
    if (ok) {
      _appOpenCharged = true;
    }
    return ok;
  }

  static Future<void> addCredits(int amount) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int credits = await getCredits();
      credits += amount;
      await prefs.setInt(_creditsKey, credits);
    } catch (e) {
      debugPrint('Error adding credits: $e');
    }
  }

  static Future<void> resetCredits() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_creditsKey);
  }
}
