import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // 🌍 LOCALIZACIÓN
import 'package:provider/provider.dart';
import 'theme_provider.dart';
// import 'screens/calculator_snippet_screen.dart'; // removed - unused
import 'screens/hiper_calculator_screen.dart'; // Nueva calculadora HiPER
import 'services/calculator_service.dart';
import 'widgets/asset_button.dart';
import 'ads_helper.dart'; // PUBLICIDAD: Sistema de AdMob
import 'app_text.dart'; // 🌍 SISTEMA DE TRADUCCIÓN

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🌍 RESETEAR CACHE DE IDIOMA AL INICIO (detecta cambios del sistema)
  AppText.resetLanguageCache();
  print(
      '🌍 DETECTANDO IDIOMA DEL SISTEMA: ${AppText.isSpanish ? "ESPAÑOL" : "ENGLISH"}');

  // PUBLICIDAD: Inicializar AdMob
  print('🎯 INICIANDO ADMOB...');
  await AdHelper.initialize();
  print('✅ ADMOB INICIALIZADO CORRECTAMENTE');

  // Precargar anuncios
  print('📱 PRECARGANDO ANUNCIOS...');
  AdHelper.preloadInterstitial();
  AdHelper.preloadRewarded();
  print('🎁 ANUNCIOS PRECARGADOS');

  // prewarm svg assets (non-blocking)
  Future.microtask(() => AssetButton.prewarmAllSvgAssetsFromRootBundle());

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ChangeNotifierProvider(create: (_) => CalculatorService()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Locale? _currentLocale;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Inicializar locale actual
    final platformLocale = WidgetsBinding.instance.window.locale;
    _currentLocale = platformLocale;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    // Cuando cambie el locale del sistema, resetear cache y forzar rebuild
    AppText.resetLanguageCache();
    if (locales != null && locales.isNotEmpty) {
      final newLocale = locales.first;
      if (_currentLocale == null ||
          _currentLocale!.languageCode != newLocale.languageCode) {
        setState(() {
          _currentLocale = newLocale;
        });
      }
    } else {
      // Forzar rebuild por si acaso
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Advanced Calculator',

      // 🌍 CONFIGURACIÓN DE LOCALIZACIÓN
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // Inglés
        Locale('es', ''), // Español
      ],
      // Usar locale actual del sistema si la detectamos, sino null para fallback automático
      locale: _currentLocale,

      localeResolutionCallback: (locale, supportedLocales) {
        // Resetear cache por seguridad y devolver el mismo locale elegido
        AppText.resetLanguageCache();
        return locale;
      },

      home: HiperCalculatorScreen(),
    );
  }
}
