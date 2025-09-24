import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme_provider.dart';
import '../widgets/banner_ad_widget.dart';

class SuggestionsScreen extends StatefulWidget {
  const SuggestionsScreen({Key? key}) : super(key: key);

  @override
  State<SuggestionsScreen> createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _sending = false;
  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _history = prefs.getStringList('suggestions_history') ?? []);
  }

  Future<void> _saveToHistory(String subject, String message) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('suggestions_history') ?? [];
    final item = subject.isNotEmpty ? '$subject: $message' : message;
    list.insert(0, item);
    if (list.length > 50) list.removeLast();
    await prefs.setStringList('suggestions_history', list);
    setState(() => _history = list);
  }

  Future<void> _clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('suggestions_history');
    setState(() => _history = []);
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    final subject = _subjectController.text.trim();
    final message = _messageController.text.trim();
    setState(() => _sending = true);

    try {
      // Email profesional para recibir sugerencias
      const email = 'advancedmath.calculator@gmail.com';
      final emailSubject =
          subject.isNotEmpty ? subject : 'Sugerencia para Advanced Calculator';
      final emailBody = '''
Sugerencia para Advanced Calculator:

${subject.isNotEmpty ? 'Asunto: $subject\n\n' : ''}Mensaje:
$message

---
Enviado desde Advanced Calculator v1.0.0
Dispositivo: Android
      ''';

      final uri = Uri(
        scheme: 'mailto',
        path: email,
        query:
            'subject=${Uri.encodeComponent(emailSubject)}&body=${Uri.encodeComponent(emailBody)}',
      );

      // Intentar abrir directamente con launchUrl
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        await _saveToHistory(subject, message);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('✅ Se abrió tu app de email para enviar la sugerencia'),
          backgroundColor: Colors.green,
        ));
        _subjectController.clear();
        _messageController.clear();
      } catch (emailError) {
        // Si falla el email, mostrar opciones al usuario
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('📧 Enviar Sugerencia'),
            content:
                Text('Tu dispositivo no tiene una app de email configurada.\n\n'
                    'Puedes:\n'
                    '• Copiar el email: $email\n'
                    '• O compartir tu sugerencia por otro medio'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Fallback: compartir via Share
                  final content = '''
📧 Para: $email
📋 Asunto: $emailSubject

$emailBody
                  ''';
                  Share.share(content);
                  _saveToHistory(subject, message);
                  _subjectController.clear();
                  _messageController.clear();
                },
                child: const Text('📱 Compartir'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('❌ Error al enviar: $e'),
        backgroundColor: Colors.red,
      ));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sugerencias y Feedback'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Envíanos tus sugerencias',
                    style: TextStyle(
                        fontSize: 18 * theme.fontScale,
                        color: theme.displayTextColor)),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _subjectController,
                  decoration: const InputDecoration(
                      labelText: 'Asunto (opcional)',
                      prefixIcon: Icon(Icons.subject)),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _messageController,
                  maxLines: 6,
                  decoration: const InputDecoration(
                      labelText: 'Mensaje', prefixIcon: Icon(Icons.message)),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Escribe tu sugerencia';
                    }
                    if (v.trim().length < 8) {
                      return 'Agrega un poco más de detalle (mín. 8 caracteres)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _sending ? null : _send,
                      icon: const Icon(Icons.send),
                      label: const Text('Enviar'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: _history.isEmpty ? null : _clearHistory,
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Borrar historial'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Historial',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: theme.displayTextColor)),
                const SizedBox(height: 8),
                if (_history.isEmpty)
                  const Text('No hay sugerencias previas')
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _history.length,
                    itemBuilder: (_, i) => ListTile(
                      leading: const Icon(Icons.chat_bubble_outline),
                      title: Text(_history[i]),
                    ),
                  ),
                const SizedBox(height: 12),
                const BannerAdWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
