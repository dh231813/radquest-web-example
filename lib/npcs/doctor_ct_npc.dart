import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:RadQuest/player/player_serife.dart';
import 'package:RadQuest/player/player_sprite.dart';
import 'package:RadQuest/utilities/constants.dart';

const Color kLightBlueColor = Color(0xFF1fbfa2); // Define the light blue color

class DoctorCTNPC extends SimpleEnemy with BlockMovementCollision {
  bool isPlayerNearby = false;
  bool isShowingDialog = false;

  final String imagePath = 'assets/images/characters/doctor_ct.png';
  final String badgeImagePath = 'assets/images/objects/BadgeCT-large.png';
  final String badgeID = kCTBadge;

  int currentQuestionIndex = 0;
  int correctAnswersCount = 0;

  @override
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Wie arbeitet ein Computertomograph, um Querschnittsbilder des Körpers zu erstellen?',
      'answers': [
        'a) Durch die Verwendung von Magnetfeldern',
        'b) Durch die Messung von Schallwellenreflexionen',
        'c) Durch das Rotieren von Röntgenstrahlen um den Körper',
        'd) Durch die Erzeugung elektrischer Impulse'
      ],
      'correctAnswerIndex': 2,
      'explanation': 'Ein Computertomograph erstellt Querschnittsbilder des Körpers durch das Rotieren von Röntgenstrahlen um den Körper, was detaillierte Bilder ermöglicht.'
    },
    {
      'question': 'Welche Art von Kontrastmittel wird oft vor einem CT-Scan verabreicht, um die Bildgebung zu verbessern?',
      'answers': [
        'a) Iodhaltiges Kontrastmittel',
        'b) Eisenhaltiges Kontrastmittel',
        'c) Bariumsulfat',
        'd) Gadolinium'
      ],
      'correctAnswerIndex': 0,
      'explanation': 'Iodhaltiges Kontrastmittel wird oft vor einem CT-Scan verabreicht, um die Sichtbarkeit bestimmter Strukturen im Körper zu verbessern.'
    },
    {
      'question': 'Welche Art von Gewebe erscheint typischerweise heller als andere in CT-Scans?',
      'answers': [
        'a) Luft',
        'b) Knochen',
        'c) Fett',
        'd) Muskel'
      ],
      'correctAnswerIndex': 1,
      'explanation': 'Knochen erscheint typischerweise heller in CT-Scans aufgrund ihrer hohen Dichte und ihrer Fähigkeit, Röntgenstrahlen stark zu absorbieren.'
    },
    {
      'question': 'Was ist die Hauptgefahrquelle beim Betreten des Untersuchungsraumes während einer CT-Untersuchung?',
      'answers': [
        'a) Magnetfelder',
        'b) Ionisierende Strahlung',
        'c) Akustische Emissionen',
        'd) Thermische Belastung'
      ],
      'correctAnswerIndex': 1,
      'explanation': 'Die Hauptgefahrquelle beim Betreten des Untersuchungsraumes während einer CT-Untersuchung ist die ionisierende Strahlung, die gesundheitsschädlich sein kann.'
    },
    {
      'question': 'Wie viele Schichtbilder kann ein CT-Scanner maximal pro Sekunde erstellen?',
      'answers': [
        'a) 10 Bilder pro Sekunde',
        'b) 100 Bilder pro Sekunde',
        'c) 1000 Bilder pro Sekunde',
        'd) 10000 Bilder pro Sekunde'
      ],
      'correctAnswerIndex': 2,
      'explanation': 'Ein CT-Scanner kann maximal 1000 Bilder pro Sekunde erstellen, was eine schnelle und detaillierte Bildgebung ermöglicht.'
    },
    {
      'question': 'Was misst die Hounsfield-Skala in der CT-Bildgebung?',
      'answers': [
        'a) Röntgenabsorptionseigenschaften von Geweben',
        'b) Blutflussgeschwindigkeit',
        'c) Radioaktivitätsniveau',
        'd) Akustische Impedanz'
      ],
      'correctAnswerIndex': 0,
      'explanation': 'Die Hounsfield-Skala misst die Röntgenabsorptionseigenschaften von Geweben, was hilft, verschiedene Gewebetypen im CT-Bild zu unterscheiden.'
    },
    {
      'question': 'Was ist ein häufiger Vorteil der Spiral-CT gegenüber der herkömmlichen CT?',
      'answers': [
        'a) Höhere Strahlendosis für den Patienten',
        'b) Längere Bildaufnahmezeit',
        'c) Verbesserte Auflösung',
        'd) Reduzierte Kontrasterhöhung'
      ],
      'correctAnswerIndex': 2,
      'explanation': 'Ein häufiger Vorteil der Spiral-CT gegenüber der herkömmlichen CT ist die verbesserte Auflösung, die detailliertere Bilder ermöglicht.'
    },
  ];

  DoctorCTNPC(Vector2 position)
      : super(
    position: position,
    animation: SimpleDirectionAnimation(
      idleRight: DoctorCTSpriteSheet.docIdle,
      runRight: DoctorCTSpriteSheet.docFront,
      idleDown: DoctorCTSpriteSheet.docIdle,
    ),
    size: Vector2(16, 23) * 2.0,
    speed: 0,
  ) {
    HardwareKeyboard.instance.addHandler(_handleKey);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _checkPlayerProximity();
  }

  void _checkPlayerProximity() {
    final player = gameRef.player;
    if (player != null && player is PlayerSerife) {
      final distance = player.position.distanceTo(position);
      isPlayerNearby = distance < size.x + player.size.x; // Adjust distance threshold as needed
    }
  }

  bool _handleKey(KeyEvent event) {
    if (isPlayerNearby && !isShowingDialog && event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.space) {
      _triggerDialog(gameRef.context, gameRef.player as PlayerSerife);
      return true;
    }
    return false;
  }

  void _triggerDialog(BuildContext context, PlayerSerife player) {
    isShowingDialog = true;
    gameRef.pauseEngine();
    player.stopMovement();
    _showGreetingDialog(context, player);
  }

  void _showGreetingDialog(BuildContext context, PlayerSerife player) {
    _showCustomDialog(
      context: context,
      player: player,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: Image.asset(imagePath),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  greetingText,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextButton(
            child: const Text('Weiter', style: TextStyle(color: kLightBlueColor, fontSize: 20)),
            onPressed: () {
              Navigator.of(context).pop();
              _showQuestionDialog(context, player);
            },
          ),
        ],
      ),
    );
  }

  void _showQuestionDialog(BuildContext context, PlayerSerife player) {
    _showCustomDialog(
      context: context,
      player: player,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.asset(imagePath),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      questions[currentQuestionIndex]['question'],
                      style: TextStyle(color: Colors.white, fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ..._buildAnswerButtons(context, player),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAnswerButtons(BuildContext context, PlayerSerife player) {
    List<Widget> buttons = [];
    List<String> answers = questions[currentQuestionIndex]['answers'];
    for (int i = 0; i < answers.length; i++) {
      buttons.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: TextButton(
            child: Text(answers[i], style: TextStyle(color: Colors.white, fontSize: 20)),
            onPressed: () {
              Navigator.of(context).pop();
              _showFeedbackDialog(context, player, i == questions[currentQuestionIndex]['correctAnswerIndex']);
            },
          ),
        ),
      );
    }
    return buttons;
  }

  void _showFeedbackDialog(BuildContext context, PlayerSerife player, bool isCorrect) {
    if (isCorrect) correctAnswersCount++;
    _showCustomDialog(
      context: context,
      player: player,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: Image.asset(imagePath),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCorrect ? 'Richtige Antwort' : 'Falsche Antwort',
                      style: TextStyle(
                        color: isCorrect ? Colors.green : Colors.red,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: isCorrect ? '' : 'Die richtige Antwort ist: ',
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                          TextSpan(
                            text: questions[currentQuestionIndex]['answers'][questions[currentQuestionIndex]['correctAnswerIndex']],
                            style: TextStyle(color: kLightBlueColor, fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                          TextSpan(
                            text: '. ${questions[currentQuestionIndex]['explanation']}',
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          TextButton(
            child: const Text('Weiter', style: TextStyle(color: kLightBlueColor, fontSize: 20)),
            onPressed: () {
              Navigator.of(context).pop();
              currentQuestionIndex++;
              if (currentQuestionIndex < questions.length) {
                _showQuestionDialog(context, player);
              } else {
                _showFinalResultDialog(context, player);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showFinalResultDialog(BuildContext context, PlayerSerife player) {
    _showCustomDialog(
      context: context,
      player: player,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Du hast ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                    TextSpan(
                      text: '$correctAnswersCount',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    TextSpan(
                      text: ' von ${questions.length} Fragen richtig beantwortet!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (correctAnswersCount >= 5) ...[
                Image.asset(
                  badgeImagePath,
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Herzlichen Glückwunsch! Du hast das ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                      TextSpan(
                        text: 'Abzeichen für herausragende Beratung',
                        style: TextStyle(color: kLightBlueColor, fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      TextSpan(
                        text: ' erhalten!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ],
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: TextButton(
              child: const Text('Schließen', style: TextStyle(color: Colors.white, fontSize: 20)),
              onPressed: () {
                Navigator.of(context).pop();
                gameRef.resumeEngine();
                player.resumeMovement();
                isShowingDialog = false;
              },
            ),
          ),
        ],
      ),
    );

    if (correctAnswersCount >= 5) {
      player.badges.add(badgeID);
    }
  }

  void _showCustomDialog({
    required BuildContext context,
    required PlayerSerife player,
    required Widget child,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9, // Cover more of the screen
            height: MediaQuery.of(context).size.height * 0.7, // Cover more of the screen
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(child: child), // Allow scrolling if content is too large
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ).drive(Tween<double>(
              begin: 0.95,
              end: 1.00,
            )),
            child: child,
          ),
        );
      },
    ).then((_) {
      gameRef.resumeEngine();
      player.resumeMovement();
      isShowingDialog = false;
    });
  }

  String get greetingText => 'Guten Tag! Ich bin der Facharzt für Computertomographie. Bereit, Ihr Wissen über CT-Scans zu testen?';
}
