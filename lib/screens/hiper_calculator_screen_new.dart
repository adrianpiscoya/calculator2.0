import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import 'package:calculator_scientific/expression_evaluator.dart';
import 'package:calculator_scientific/theme_provider.dart';
import 'package:calculator_scientific/screens/statistics_screen.dart';
import 'package:calculator_scientific/screens/function_graph.dart';
import 'package:calculator_scientific/screens/unit_converter_screen.dart';
import 'package:calculator_scientific/screens/exchange_screen.dart';
import 'package:calculator_scientific/screens/guess_game.dart';
import 'package:calculator_scientific/screens/cosmic_equation_chase.dart';
import 'package:calculator_scientific/screens/help_screen.dart';
import 'package:calculator_scientific/screens/suggestions_screen.dart';
import 'package:calculator_scientific/widgets/simple_fraction_display.dart';
import 'package:calculator_scientific/ads_helper.dart';
import '../app_text.dart';

class HiperCalculatorScreen extends StatefulWidget {
  @override
  _HiperCalculatorScreenState createState() => _HiperCalculatorScreenState();
}

class _HiperCalculatorScreenState extends State<HiperCalculatorScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      decoration: BoxDecoration(
        gradient: themeProvider.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Advanced Calculator',
            style: TextStyle(fontSize: 20)), 
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
          elevation: 4,
          actions: [
            // ... resto de acciones del AppBar ...
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // ... contenido del drawer ...
            ],
          ),
        ),
        body: Column(
          children: [
            // ... resto del contenido del body ...
          ],
        ),
      ),
    );
  }
}