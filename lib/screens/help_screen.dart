import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../theme_provider.dart';
import 'suggestions_screen.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  Future<void> _launchPlayStore() async {
    // TODO: Reemplazar con tu package name real cuando subas a Play Store
    const playStoreUrl =
        'https://play.google.com/store/apps/details?id=com.example.calculator_scientific';
    final uri = Uri.parse(playStoreUrl);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'No se pudo abrir Play Store';
      }
    } catch (e) {
      print('Error al abrir Play Store: $e');
    }
  }

  Future<void> _shareApp() async {
    const message = '''
🧮 ¡Descubre Advanced Calculator! 
    
✨ Calculadora científica completa con:
• Funciones trigonométricas y logarítmicas
• Gráficos de funciones matemáticas  
• Conversor de unidades
• Estadísticas y análisis de datos
• Juegos matemáticos divertidos
• Interfaz profesional y moderna

📱 Descárgala gratis: https://play.google.com/store/apps/details?id=com.example.calculator_scientific

#Calculator #Math #Science #Education
    ''';

    await Share.share(message);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayuda y Soporte'),
        backgroundColor: theme.backgroundGradient.colors.first,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: theme.backgroundGradient,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(Icons.help_outline,
                          size: 48,
                          color: theme.backgroundGradient.colors.first),
                      const SizedBox(height: 12),
                      Text(
                        'Advanced Calculator',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: theme.displayTextColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tu calculadora científica profesional',
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.displayTextColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // FAQ Section
              _buildSection(
                context,
                title: '❓ Preguntas Frecuentes',
                items: [
                  _buildFAQItem('¿Cómo cambiar entre modos de calculadora?',
                      'Usa los tabs en la parte inferior: Básico, Trigonométrico, Avanzado, Constantes y Fracciones.'),
                  _buildFAQItem('¿Cómo cambiar el modo de ángulos?',
                      'En el menú lateral, selecciona "Modo Ángulo" para cambiar entre RAD, DEG y GRAD.'),
                  _buildFAQItem('¿Cómo usar las funciones premium?',
                      'Algunas funciones avanzadas requieren ver un anuncio corto para acceder.'),
                  _buildFAQItem('¿Cómo compartir resultados?',
                      'En Estadísticas y Gráficos, usa el botón compartir para enviar tus análisis.'),
                ],
                theme: theme,
              ),

              const SizedBox(height: 20),

              // Features Section
              _buildSection(
                context,
                title: '🚀 Características Principales',
                items: [
                  _buildFeatureItem(Icons.calculate, 'Calculadora Científica',
                      'Funciones trigonométricas, logarítmicas, exponenciales y más'),
                  _buildFeatureItem(Icons.show_chart, 'Gráficos de Funciones',
                      'Visualiza funciones matemáticas en tiempo real'),
                  _buildFeatureItem(Icons.swap_horiz, 'Conversor de Unidades',
                      'Convierte entre diferentes unidades de medida'),
                  _buildFeatureItem(Icons.bar_chart, 'Estadísticas',
                      'Análisis estadístico completo con gráficos'),
                  _buildFeatureItem(Icons.games, 'Juegos Matemáticos',
                      'Aprende mientras te diviertes'),
                ],
                theme: theme,
              ),

              const SizedBox(height: 20),

              // Action Buttons
              _buildActionButtons(context, theme),

              const SizedBox(height: 20),

              // Contact Section
              _buildSection(
                context,
                title: '📧 Contacto y Soporte',
                items: [
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.email, color: Colors.blue),
                      title: const Text('Enviar Sugerencias'),
                      subtitle:
                          const Text('Comparte tus ideas para mejorar la app'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SuggestionsScreen()),
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading:
                          const Icon(Icons.bug_report, color: Colors.orange),
                      title: const Text('Reportar Problema'),
                      subtitle:
                          const Text('Ayúdanos a mejorar reportando errores'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SuggestionsScreen()),
                        );
                      },
                    ),
                  ),
                ],
                theme: theme,
              ),

              const SizedBox(height: 20),

              // Version Info
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Advanced Calculator v1.0.0',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.displayTextColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Desarrollado con ❤️ para estudiantes y profesionales',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.displayTextColor.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> items,
    required ThemeProvider theme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.displayTextColor,
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title:
            Text(question, style: const TextStyle(fontWeight: FontWeight.w600)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(answer, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue, size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(description),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ThemeProvider theme) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '⭐ Acciones Rápidas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.displayTextColor,
              ),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _launchPlayStore,
                icon: const Icon(Icons.star),
                label: const Text('Calificar App'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _shareApp,
                icon: const Icon(Icons.share),
                label: const Text('Compartir App'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
