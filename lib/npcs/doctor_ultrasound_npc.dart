import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:RadQuest/player/player_serife.dart';
import 'package:RadQuest/player/player_sprite.dart';
import 'package:RadQuest/utilities/constants.dart';

const Color kLightBlueColor = Color(0xFF1fbfa2); // Define the light blue color
const String kUltraSoundBadge = 'UltrasoundBadge';

class DoctorUltrasoundNPC extends SimpleEnemy with BlockMovementCollision {
  bool isPlayerNearby = false;
  bool isShowingDialog = false;

  final String imagePath = 'assets/images/characters/doctor_xray.png';
  final String badgeImagePath = 'assets/images/objects/BadgeUltrasound-large.png';
  final String badgeID = kUltraSoundBadge;

  int currentQuestionIndex = 0;
  int correctAnswersCount = 0;

  @override
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Welche Art von Wellen werden im Ultraschall verwendet?',
      'answers': [
        'a) Radiowellen',
        'b) Mikrowellen',
        'c) Schallwellen',
        'd) Röntgenstrahlen'
      ],
      'correctAnswerIndex': 2,
      'explanation': 'Ultraschall verwendet Schallwellen, um Bilder aus dem Inneren des Körpers zu erzeugen.'
    },
    {
      'question': 'Welche Art von Bildgebung erzeugt ein Ultraschallgerät?',
      'answers': [
        'a) Röntgenaufnahmen',
        'b) Magnetresonanztomographie (MRT)',
        'c) Sonogramme',
        'd) Computertomographie (CT)'
      ],
      'correctAnswerIndex': 2,
      'explanation': 'Ultraschallgeräte erzeugen Sonogramme, das sind Bilder, die mithilfe von Schallwellen erstellt werden.'
    },
    {
      'question': 'Was ist der Zweck des Gels, das vor Ultraschalluntersuchungen auf die Haut aufgetragen wird?',
      'answers': [
        'a) Desinfektion',
        'b) Schmerzlinderung',
        'c) Verbesserung der Bildqualität',
        'd) Erzeugung von Schallwellen'
      ],
      'correctAnswerIndex': 2,
      'explanation': 'Das Gel verbessert die Bildqualität, indem es hilft, die Schallwellen besser durch die Haut zu leiten.'
    },
    {
      'question': 'Welches Organ ist am besten für eine transvaginale Ultraschalluntersuchung zugänglich?',
      'answers': [
        'a) Niere',
        'b) Leber',
        'c) Gebärmutter',
        'd) Lunge'
      ],
      'correctAnswerIndex': 2,
      'explanation': 'Die Gebärmutter ist am besten für eine transvaginale Ultraschalluntersuchung zugänglich.'
    },
    {
      'question': 'Welches Artefakt kann bei der Ultraschallbildgebung auftreten, wenn Schallwellen an hochreflektierenden Oberflächen reflektiert werden?',
      'answers': [
        'a) Absorption',
        'b) Nachhall',
        'c) Brechung',
        'd) Schattierung'
      ],
      'correctAnswerIndex': 3,
      'explanation': 'Schattierung ist ein Artefakt, das auftritt, wenn Schallwellen an hochreflektierenden Oberflächen reflektiert werden.'
    },
    {
      'question': 'Was zeigt der A-Modus-Ultraschall hauptsächlich an?',
      'answers': [
        'a) Querschnittsbilder',
        'b) Echtzeitbewegungsbilder',
        'c) Amplitude der Echos über die Tiefe',
        'd) Geschwindigkeit des Blutflusses'
      ],
      'correctAnswerIndex': 2,
      'explanation': 'Der A-Modus-Ultraschall zeigt hauptsächlich die Amplitude der Echos über die Tiefe an.'
    },
    {
      'question': 'Welche der folgenden Anwendungen ist typisch für den Doppler-Ultraschall?',
      'answers': [
        'a) Messung der Knochendichte',
        'b) Bewertung des Blutflusses',
        'c) Visualisierung der Gehirnaktivität',
        'd) Bewertung der Lungenfunktion'
      ],
      'correctAnswerIndex': 1,
      'explanation': 'Doppler-Ultraschall wird häufig zur Bewertung des Blutflusses verwendet.'
    },
  ];

  DoctorUltrasoundNPC(Vector2 position)
      : super(
    position: position,
    animation: SimpleDirectionAnimation(
      idleRight: DoctorXRaySpriteSheet.docIdle,
      runRight: DoctorXRaySpriteSheet.docFront,
      idleDown: DoctorXRaySpriteSheet.docIdle,
    ),
    size: Vector2(32, 32),
    speed: 0,
  ) {
    add(RectangleHitbox(size: size));
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

  String get greetingText => 'Hallo! Ich bin der Facharzt für Sonografie. Sind Sie bereit für ein paar Fragen zum Thema Ultraschall?';
}
