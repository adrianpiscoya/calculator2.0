import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppPalette { basic, scientific, graph }

class ThemeProvider extends ChangeNotifier {
  AppPalette _palette = AppPalette.basic;
  bool _isDark = false;
  double _fontScale = 1.0;

  static const _kDarkKey = 'app_dark_mode';
  static const _kFontScaleKey = 'app_font_scale';

  ThemeProvider() {
    _load();
  }

  AppPalette get palette => _palette;
  bool get isDark => _isDark;
  double get fontScale => _fontScale;

  void setPalette(AppPalette palette) {
    _palette = palette;
    notifyListeners();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool(_kDarkKey) ?? false;
    _fontScale = prefs.getDouble(_kFontScaleKey) ?? 1.0;
    notifyListeners();
  }

  Future<void> setDark(bool dark) async {
    _isDark = dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kDarkKey, dark);
    notifyListeners();
  }

  Future<void> toggleDark() async => setDark(!isDark);

  Future<void> setFontScale(double scale) async {
    _fontScale = scale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kFontScaleKey, scale);
    notifyListeners();
  }

  // Colores para cada calculadora, adaptados a modo oscuro
  Color get backgroundColor {
    if (_isDark) return const Color(0xFF0F1419); // Azul muy oscuro profesional
    switch (_palette) {
      case AppPalette.basic:
        return const Color(0xFF1A237E); // Azul marino profesional
      case AppPalette.scientific:
        return const Color(0xFF263238); // Gris azulado profesional
      case AppPalette.graph:
        return const Color(0xFF1B2021); // Carbón profesional
    }
  }

  // Gradiente profesional para el fondo principal
  LinearGradient get backgroundGradient {
    if (_isDark) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF0F1419), // Azul oscuro
          Color(0xFF000000), // Negro
        ],
      );
    }
    switch (_palette) {
      case AppPalette.basic:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A237E), // Azul marino
            Color(0xFF0D1421), // Azul muy oscuro
          ],
        );
      case AppPalette.scientific:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF263238), // Gris azulado
            Color(0xFF0F1419), // Azul muy oscuro
          ],
        );
      case AppPalette.graph:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1B2021), // Carbón
            Color(0xFF000000), // Negro
          ],
        );
    }
  }

  Color get buttonColor {
    if (_isDark) return const Color(0xFF2C3E50); // Azul gris profesional
    switch (_palette) {
      case AppPalette.basic:
        return const Color(0xFF34495E); // Gris azulado elegante
      case AppPalette.scientific:
        return const Color(0xFF2C3E50); // Azul gris profesional
      case AppPalette.graph:
        return const Color(0xFF37474F); // Gris carbón
    }
  }

  Color get accentColor {
    if (_isDark) return const Color(0xFF64B5F6); // Azul profesional
    switch (_palette) {
      case AppPalette.basic:
        return const Color(0xFF1976D2); // Azul corporativo
      case AppPalette.scientific:
        return const Color(0xFFFF6F00); // Naranja profesional
      case AppPalette.graph:
        return const Color(0xFF00ACC1); // Cian profesional
    }
  }

  Color get displayColor {
    if (_isDark) return const Color(0xFF1C2833); // Azul muy oscuro elegante
    switch (_palette) {
      case AppPalette.basic:
        return const Color(0xFF212F3D); // Azul muy oscuro profesional
      case AppPalette.scientific:
        return const Color(0xFF1C2833); // Azul gris oscuro
      case AppPalette.graph:
        return const Color(0xFF17202A); // Casi negro azulado
    }
  }

  Color get displayTextColor {
    if (_isDark) return Colors.white;
    switch (_palette) {
      case AppPalette.basic:
        return Colors.black;
      case AppPalette.scientific:
        return Colors.black;
      case AppPalette.graph:
        return Colors.greenAccent;
    }
  }
}
