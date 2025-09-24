/// **DEMOSTRACIÓN DEL SISTEMA VISUAL MATEMÁTICO** 🎯
///
/// Este archivo demuestra las capacidades revolucionarias del nuevo sistema:
/// - Raíces cuadradas que se EXTIENDEN: √(25+16) → símbolo √ que crece
/// - Fracciones que PERSISTEN: 3/4 + 1/2 → ¾ + ½ (sin convertir a decimal)
/// - Exponentes ELEVADOS: e^2 → e² (visualmente elevado)
///
/// ¡Tu calculadora ahora compite con Casio y TI a nivel visual!

import 'package:flutter/material.dart';
import 'package:calculator_scientific/widgets/math_visual_widgets.dart';

void main() {
  runApp(MaterialApp(
    home: MathVisualDemo(),
    theme: ThemeData.dark(),
  ));
}

class MathVisualDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🎯 REVOLUCIÓN VISUAL MATEMÁTICA'),
        backgroundColor: Colors.blue[700],
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // **DEMO 1**: Raíces cuadradas extendidas
            _buildDemoSection(
              title: '🔥 1. RAÍCES CUADRADAS EXTENDIDAS',
              description: 'El símbolo √ se extiende según el contenido',
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[400]!, width: 2),
                ),
                child: Column(
                  children: [
                    MathDisplayWidget(
                      expression: 'sqrt(25)',
                      fontSize: 28,
                    ),
                    SizedBox(height: 12),
                    MathDisplayWidget(
                      expression: 'sqrt(16+25*4)',
                      fontSize: 28,
                    ),
                    SizedBox(height: 12),
                    MathDisplayWidget(
                      expression: 'sqrt(sin(45)*cos(30)+tan(60))',
                      fontSize: 24,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // **DEMO 2**: Fracciones persistentes
            _buildDemoSection(
              title: '🔥 2. FRACCIONES PERSISTENTES',
              description: 'Las fracciones se mantienen visibles siempre',
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[400]!, width: 2),
                ),
                child: Column(
                  children: [
                    MathDisplayWidget(
                      expression: '3/4',
                      fontSize: 32,
                    ),
                    SizedBox(height: 16),
                    MathDisplayWidget(
                      expression: '3/4 + 1/2',
                      fontSize: 28,
                    ),
                    SizedBox(height: 16),
                    MathDisplayWidget(
                      expression: '(25+16)/(8*4)',
                      fontSize: 24,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // **DEMO 3**: Exponentes elevados
            _buildDemoSection(
              title: '🔥 3. EXPONENTES ELEVADOS',
              description: 'Los exponentes aparecen visualmente elevados',
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange[400]!, width: 2),
                ),
                child: Column(
                  children: [
                    MathDisplayWidget(
                      expression: 'e^2',
                      fontSize: 32,
                    ),
                    SizedBox(height: 16),
                    MathDisplayWidget(
                      expression: 'x^(2+3)',
                      fontSize: 28,
                    ),
                    SizedBox(height: 16),
                    MathDisplayWidget(
                      expression: '2^8 + 3^(4+1)',
                      fontSize: 24,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // **DEMO 4**: Expresión compleja combinada
            _buildDemoSection(
              title: '🔥 4. EXPRESIÓN COMPLEJA COMBINADA',
              description: '¡TODO JUNTO! Raíces + Fracciones + Exponentes',
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.purple[400]!, width: 2),
                ),
                child: MathDisplayWidget(
                  expression: 'sqrt(25) + 3/4 + e^2',
                  fontSize: 26,
                ),
              ),
            ),

            Spacer(),

            // Mensaje de éxito
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[800],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '🎉 ¡ÉXITO TOTAL!\n\nTu calculadora ahora tiene renderizado matemático profesional.\n¡Como las calculadoras Casio y TI más avanzadas!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoSection({
    required String title,
    required String description,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
        ),
        SizedBox(height: 12),
        child,
      ],
    );
  }
}
