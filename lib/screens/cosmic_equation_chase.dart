import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/banner_ad_widget.dart'; // Asumimos que existe
import '../ads_helper.dart'; // Asumimos que existe

/// Representa una mina estelar (partícula animada) en el juego.
class StarMine {
  String equation;
  int correctAnswer;
  double x, y, speed;
  double size, opacity;
  bool isDoubleEquation; // Requiere dos respuestas correctas
  StarMine(this.equation, this.correctAnswer, this.x, this.y, this.speed,
      {this.size = 30, this.opacity = 0.8, this.isDoubleEquation = false});
}

/// Lógica del juego separada para modularidad.
class GameLogic {
  final Random _rand = Random();
  int level = 1;
  ValueNotifier<int> score = ValueNotifier(0);
  ValueNotifier<int> highScore = ValueNotifier(0);
  ValueNotifier<int> energy = ValueNotifier(100); // Energía de la nave
  ValueNotifier<int> combo = ValueNotifier(0); // Contador de combos
  ValueNotifier<String> currentEquation = ValueNotifier('');
  int correctAnswer = 0;
  int powerUpType = 0; // 0=none, 1=shield, 2=extra time, 3=slow mines
  int powerUpDuration = 0;
  bool hasShield = false;

  Future<void> loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    highScore.value = prefs.getInt('cosmic_highscore') ?? 0;
  }

  Future<void> saveHighScoreIfNeeded() async {
    if (score.value > highScore.value) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('cosmic_highscore', score.value);
      highScore.value = score.value;
    }
  }

  void generateEquation() {
    final ops = ['+', '-', '×', '÷'];
    final op = ops[_rand.nextInt(ops.length)];
    int maxBase = 5 + level * 3;
    if (level < 3) maxBase = 10;
    int a = _rand.nextInt(maxBase) + 1;
    int b = _rand.nextInt(maxBase) + 1;

    if (op == '+') {
      correctAnswer = a + b;
      currentEquation.value = '$a + $b';
    } else if (op == '-') {
      if (b > a) {
        final t = a;
        a = b;
        b = t;
      }
      correctAnswer = a - b;
      currentEquation.value = '$a - $b';
    } else if (op == '×') {
      correctAnswer = a * b;
      currentEquation.value = '$a × $b';
    } else {
      b = _rand.nextInt(5) + 1;
      a = b * (_rand.nextInt(level + 2) + 1);
      correctAnswer = a ~/ b;
      currentEquation.value = '$a ÷ $b';
    }
  }

  String getPowerUpName() {
    switch (powerUpType) {
      case 1:
        return 'Escudo';
      case 2:
        return 'Tiempo Extra';
      case 3:
        return 'Ralentizar Minas';
      default:
        return '';
    }
  }

  // NUEVO: Calcula velocidad basada en puntaje (cada 100 puntos aumenta la velocidad)
  double getSpeedMultiplier() {
    final scoreLevel =
        (score.value / 100).floor(); // Cada 100 puntos = 1 nivel de velocidad
    switch (scoreLevel) {
      case 0:
        return 1.0; // 0-99 puntos: velocidad normal
      case 1:
        return 1.3; // 100-199 puntos: +30% velocidad
      case 2:
        return 1.6; // 200-299 puntos: +60% velocidad
      case 3:
        return 2.0; // 300-399 puntos: +100% velocidad
      default:
        return 2.2; // 400+ puntos: velocidad máxima +120%
    }
  }

  void dispose() {
    score.dispose();
    highScore.dispose();
    energy.dispose();
    combo.dispose();
    currentEquation.dispose();
  }
}

/// Pintor para minas estelares y fondo animado.
class StarFieldPainter extends CustomPainter {
  final List<StarMine> mines;
  final double animationValue; // Para animar el fondo

  StarFieldPainter(this.mines, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    // Fondo con estrellas
    final bgPaint = Paint()..color = Colors.blue[900]!;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Estrellas de fondo animadas
    final starPaint = Paint()..color = Colors.white.withOpacity(0.6);
    for (int i = 0; i < 50; i++) {
      final x = Random(i).nextDouble() * size.width;
      final y = (Random(i).nextDouble() * size.height + animationValue * 100) %
          size.height;
      canvas.drawCircle(Offset(x, y), 2, starPaint);
    }

    // Pintar minas estelares
    for (var mine in mines) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: mine.equation,
          style: TextStyle(
            color: Colors.yellow.withOpacity(mine.opacity),
            fontSize: mine.size,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(mine.x, mine.y));
    }
  }

  @override
  bool shouldRepaint(covariant StarFieldPainter oldDelegate) => true;
}

/// Widget para asegurar que el campo de texto sea visible.
class EnsureVisibleWhenFocusedLocal extends StatefulWidget {
  final Widget child;
  final FocusNode focusNode;
  final ScrollController scrollController;

  const EnsureVisibleWhenFocusedLocal({
    super.key,
    required this.child,
    required this.focusNode,
    required this.scrollController,
  });

  @override
  State<EnsureVisibleWhenFocusedLocal> createState() =>
      _EnsureVisibleWhenFocusedStateLocal();
}

class _EnsureVisibleWhenFocusedStateLocal
    extends State<EnsureVisibleWhenFocusedLocal> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (widget.focusNode.hasFocus && mounted) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        final contextKey = widget.child.key as GlobalKey?;
        if (contextKey == null) return;
        final renderBox =
            contextKey.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox == null || !renderBox.hasSize) return;

        final fieldGlobal = renderBox.localToGlobal(Offset.zero);
        final fieldTop = fieldGlobal.dy;
        final media = MediaQuery.of(context);
        final keyboardHeight = media.viewInsets.bottom;
        final visibleHeight = media.size.height - keyboardHeight;
        final desiredFieldTop = visibleHeight * 0.8;

        if (fieldTop > desiredFieldTop) {
          final delta = fieldTop - desiredFieldTop;
          final currentOffset = widget.scrollController.offset;
          final targetOffset = (currentOffset + delta)
              .clamp(0.0, widget.scrollController.position.maxScrollExtent);
          widget.scrollController.animateTo(
            targetOffset,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Pantalla principal del juego.
class CosmicEquationChase extends StatefulWidget {
  const CosmicEquationChase({super.key});

  @override
  State<CosmicEquationChase> createState() => _CosmicEquationChaseState();
}

class _CosmicEquationChaseState extends State<CosmicEquationChase>
    with TickerProviderStateMixin {
  final TextEditingController _answerController = TextEditingController();
  final GlobalKey _answerFieldKey = GlobalKey();
  late ScrollController _scrollController;
  late FocusNode _answerFocusNode;
  late GameLogic _gameLogic;
  Timer? _timer;
  ValueNotifier<int> _remainingSeconds = ValueNotifier(8);
  bool _gamePaused = false;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late AnimationController _explosionController;
  late AnimationController _starFieldController;
  final List<StarMine> _mines = [];
  ValueNotifier<Color?> _textFieldColor = ValueNotifier(null);
  bool _showTutorial = false;
  int _tutorialStep = 0;
  bool _tutorialCompleted = false;

  @override
  void initState() {
    super.initState();
    _gameLogic = GameLogic();
    _scrollController = ScrollController();
    _answerFocusNode = FocusNode();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _explosionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _starFieldController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

    // Defer actions that use MediaQuery or async services until after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        _gameLogic.loadHighScore().then((_) {
          if (mounted) setState(() {});
        });
      } catch (_) {}

      try {
        AdHelper.preloadRewarded();
      } catch (_) {}

      try {
        _checkTutorial();
        _gameLogic.generateEquation();
        _spawnMines();
        _resetTimer();
      } catch (_) {}

      try {
        _starFieldController.repeat();
        _starFieldController.addListener(() {
          _updateMines();
          if (mounted) setState(() {});
        });
      } catch (_) {}
    });
  }

  void _spawnMines() {
    final screenWidth = MediaQuery.of(context).size.width;
    _mines.clear();
    for (int i = 0; i < 3 + _gameLogic.level ~/ 2; i++) {
      _mines.add(StarMine(
        _gameLogic.currentEquation.value,
        _gameLogic.correctAnswer,
        Random().nextDouble() * screenWidth,
        -50,
        (1.0 + _gameLogic.level * 0.2) *
            _gameLogic.getSpeedMultiplier(), // VELOCIDAD AUMENTA CON PUNTAJE
        size: 25 + Random().nextDouble() * 10,
        isDoubleEquation: Random().nextDouble() < 0.1 * _gameLogic.level,
      ));
    }
  }

  void _updateMines() {
    final screenHeight = MediaQuery.of(context).size.height;
    for (var mine in _mines) {
      final speed =
          _gameLogic.powerUpType == 3 && _gameLogic.powerUpDuration > 0
              ? mine.speed * 0.5
              : mine.speed;
      mine.y += speed;
      mine.opacity = max(0.3, 1.0 - mine.y / screenHeight).clamp(0.0, 1.0);
    }
    // Recycle mines that went off-screen and spawn new ones
    _mines.removeWhere((m) => m.y > screenHeight + 50);
    while (_mines.length < 3 + _gameLogic.level ~/ 2) {
      final screenWidth = MediaQuery.of(context).size.width;
      _mines.add(StarMine(
        _gameLogic.currentEquation.value,
        _gameLogic.correctAnswer,
        Random().nextDouble() * screenWidth,
        -50 - Random().nextDouble() * 200,
        (1.0 + _gameLogic.level * 0.2) *
            _gameLogic.getSpeedMultiplier(), // VELOCIDAD AUMENTA CON PUNTAJE
        size: 20 + Random().nextDouble() * 20,
        isDoubleEquation: Random().nextDouble() < 0.1 * _gameLogic.level,
      ));
    }
  }

  void _resetTimer() {
    _remainingSeconds.value = 8;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_gamePaused) return;
      _remainingSeconds.value = max(0, _remainingSeconds.value - 1);
      if (_remainingSeconds.value == 0) {
        // Time out -> treat as wrong
        _handleWrongAnswer();
      }
    });
  }

  void _handleWrongAnswer() {
    _gameLogic.combo.value = 0;
    _gameLogic.energy.value = max(0, _gameLogic.energy.value - 12);
    _textFieldColor.value = Colors.red.withOpacity(0.6);
    _explosionController.forward(from: 0);
    if (_gameLogic.energy.value <= 0) {
      _gameOver();
    } else {
      // regenerate equation and keep playing
      _gameLogic.generateEquation();
      _spawnMines();
      _resetTimer();
      // keep focus so keyboard stays open
      FocusScope.of(context).requestFocus(_answerFocusNode);
      Future.delayed(const Duration(milliseconds: 500), () {
        _textFieldColor.value = null;
      });
    }
  }

  void _verifyAnswer() {
    final text = _answerController.text.trim();
    if (text.isEmpty) return;
    final val = int.tryParse(text);
    if (val == null) return;

    if (val == _gameLogic.correctAnswer) {
      // Correct
      _gameLogic.score.value += 10 + (_gameLogic.combo.value * 2);
      _gameLogic.combo.value += 1;
      _textFieldColor.value = Colors.green.withOpacity(0.6);
      _animationController.forward(from: 0);
      _gameLogic.generateEquation();
      _spawnMines();
      _resetTimer();
      _answerController.clear();
      // keep keyboard open
      FocusScope.of(context).requestFocus(_answerFocusNode);
      Future.delayed(const Duration(milliseconds: 300), () {
        _textFieldColor.value = null;
      });
    } else {
      _handleWrongAnswer();
    }
  }

  void _gameOver() async {
    _timer?.cancel();
    await _gameLogic.saveHighScoreIfNeeded();
    // Show simple dialog
    if (!mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Game Over'),
        content: Text('Puntaje: ${_gameLogic.score.value}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // restart
              _gameLogic.score.value = 0;
              _gameLogic.combo.value = 0;
              _gameLogic.energy.value = 100;
              _gameLogic.generateEquation();
              _spawnMines();
              _resetTimer();
              FocusScope.of(context).requestFocus(_answerFocusNode);
            },
            child: const Text('Reiniciar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Salir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Fondo animado
            AnimatedBuilder(
              animation: _starFieldController,
              builder: (context, child) {
                return CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: StarFieldPainter(_mines, _starFieldController.value),
                );
              },
            ),

            // UI encima
            SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 80),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    // Header con puntaje y botón de tutorial
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            ValueListenableBuilder<int>(
                              valueListenable: _gameLogic.score,
                              builder: (_, score, __) => Text('Puntaje: $score',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18)),
                            ),
                            const SizedBox(height: 8),
                            ValueListenableBuilder<int>(
                              valueListenable: _gameLogic.highScore,
                              builder: (_, hs, __) => Text('Record: $hs',
                                  style: const TextStyle(
                                      color: Colors.white54, fontSize: 14)),
                            ),
                          ],
                        ),
                        // Botón de tutorial/ayuda
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _showTutorial = true;
                              _tutorialStep = 0;
                            });
                          },
                          icon: const Icon(Icons.help_outline,
                              color: Colors.yellow, size: 28),
                          tooltip: 'Ver tutorial',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Equation (animated)
                    ValueListenableBuilder<String>(
                      valueListenable: _gameLogic.currentEquation,
                      builder: (_, eq, __) => ScaleTransition(
                        scale: _pulseAnimation,
                        child: Text(eq,
                            style: const TextStyle(
                                color: Colors.yellow,
                                fontSize: 36,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Answer box
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: EnsureVisibleWhenFocusedLocal(
                        focusNode: _answerFocusNode,
                        scrollController: _scrollController,
                        child: Container(
                          key: _answerFieldKey,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: ValueListenableBuilder<Color?>(
                                  valueListenable: _textFieldColor,
                                  builder: (ctx, color, _) {
                                    return TextField(
                                      controller: _answerController,
                                      focusNode: _answerFocusNode,
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                      decoration: InputDecoration(
                                        hintText: 'Escribe la respuesta',
                                        hintStyle:
                                            TextStyle(color: Colors.white54),
                                        filled: true,
                                        fillColor: color ?? Colors.transparent,
                                        border: InputBorder.none,
                                      ),
                                      onSubmitted: (_) => _verifyAnswer(),
                                    );
                                  },
                                ),
                              ),
                              IconButton(
                                onPressed: _verifyAnswer,
                                icon:
                                    const Icon(Icons.send, color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // HUD: energy, combo, timer
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ValueListenableBuilder<int>(
                            valueListenable: _gameLogic.energy,
                            builder: (_, energy, __) => Text('Energía: $energy',
                                style: const TextStyle(color: Colors.white70)),
                          ),
                          ValueListenableBuilder<int>(
                            valueListenable: _gameLogic.combo,
                            builder: (_, combo, __) => Text('Combo: $combo',
                                style: const TextStyle(color: Colors.white70)),
                          ),
                          ValueListenableBuilder<int>(
                            valueListenable: _remainingSeconds,
                            builder: (_, sec, __) => Text('Tiempo: $sec',
                                style: const TextStyle(color: Colors.white70)),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),

            // Banner ad anchored bottom
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Align(
                  alignment: Alignment.bottomCenter, child: BannerAdWidget()),
            ),

            // Tutorial overlay
            _buildTutorialOverlay(),
          ],
        ),
      ),
    );
  }

  Future<void> _checkTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    _tutorialCompleted = prefs.getBool('cosmic_tutorial_completed') ?? false;
    if (!_tutorialCompleted) {
      setState(() {
        _showTutorial = true;
        _tutorialStep = 0;
      });
    }
  }

  void _nextTutorialStep() {
    setState(() {
      _tutorialStep++;
      if (_tutorialStep >= _getTutorialSteps().length) {
        _completeTutorial();
      }
    });
  }

  void _completeTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('cosmic_tutorial_completed', true);
    setState(() {
      _showTutorial = false;
      _tutorialCompleted = true;
    });
  }

  List<Map<String, String>> _getTutorialSteps() {
    return [
      {
        'title': '¡Bienvenido a Cosmic Chase!',
        'content':
            'Tu misión: destruye las minas estelares resolviendo las ecuaciones matemáticas antes de que te alcancen.',
      },
      {
        'title': 'Cómo jugar',
        'content':
            '1. Toca una mina estelar (ecuación amarilla)\n2. Escribe la respuesta en el campo de abajo\n3. ¡Responde rápido!',
      },
      {
        'title': 'Sistema de energía',
        'content':
            'Respuestas correctas consecutivas crean COMBOS que dan más energía. Si tu energía llega a 0, ¡pierdes!',
      },
      {
        'title': 'Tiempo límite',
        'content':
            'Tienes 8 segundos para responder cada ecuación. El tiempo se reinicia con cada nueva pregunta.',
      },
      {
        'title': '¡Listo para comenzar!',
        'content':
            'Obtén la puntuación más alta destruyendo minas. ¡Que la fuerza esté contigo!',
      },
    ];
  }

  Widget _buildTutorialOverlay() {
    if (!_showTutorial) return const SizedBox.shrink();

    final steps = _getTutorialSteps();
    if (_tutorialStep >= steps.length) return const SizedBox.shrink();

    final currentStep = steps[_tutorialStep];

    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.blue[900],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.yellow, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                currentStep['title']!,
                style: const TextStyle(
                  color: Colors.yellow,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                currentStep['content']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Paso ${_tutorialStep + 1} de ${steps.length}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _nextTutorialStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      foregroundColor: Colors.black,
                    ),
                    child: Text(_tutorialStep == steps.length - 1
                        ? '¡Jugar!'
                        : 'Siguiente'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    _explosionController.dispose();
    _starFieldController.dispose();
    _answerController.dispose();
    _answerFocusNode.dispose();
    _scrollController.dispose();
    _gameLogic.dispose();
    _remainingSeconds.dispose();
    _textFieldColor.dispose();
    super.dispose();
  }
}
