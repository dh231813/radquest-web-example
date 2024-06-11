import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:RadQuest/player/player_serife.dart';
import 'package:RadQuest/player/player_sprite.dart';
import 'package:RadQuest/utilities/constants.dart';

const Color kLightBlueColor = Color(0xFF1fbfa2); // Define the light blue color

class PatientNPC_v2 extends SimpleEnemy with BlockMovementCollision {
  bool isPlayerNearby = false;
  bool isShowingDialog = false;

  final String imagePath;
  final String badgeImagePath;
  final String badgeID;

  int currentQuestionIndex = 0;
  int correctAnswersCount = 0;

  @override
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Wie viel Strahlung werde ich abbekommen?',
      'answers': [
        'A. 1-10 mSv',
        'B. 10-50 mSv',
        'C. Weniger als 1 mSv',
        'D. 50-100 mSv'
      ],
      'correctAnswerIndex': 2,
      'explanation': 'Diese Menge an Strahlung ist sehr gering und liegt weit unter den Grenzwerten, die als gefährlich gelten. Daher besteht kein erhöhtes Krebsrisiko durch diese Untersuchung.'
    },
    {
      'question': 'Wie lange dauert die MRT-Untersuchung?',
      'answers': [
        'A. 10-20 Minuten',
        'B. 30-60 Minuten',
        'C. 1-2 Stunden',
        'D. Mehr als 2 Stunden'
      ],
      'correctAnswerIndex': 1,
      'explanation': 'Diese Zeit kann je nach zu untersuchendem Bereich und spezifischen Anforderungen variieren.'
    },
    {
      'question': 'Wie sollte ich mich während der MRT-Untersuchung verhalten?',
      'answers': [
        'A. Ruhig liegen bleiben',
        'B. Tief ein- und ausatmen',
        'C. Sich regelmäßig bewegen',
        'D. Mit dem Arzt sprechen'
      ],
      'correctAnswerIndex': 0,
      'explanation': 'Während einer MRT-Untersuchung ist es wichtig, so still wie möglich zu liegen, um klare Bilder zu erhalten.'
    },
    {
      'question': 'Kann ich während der MRT-Untersuchung essen?',
      'answers': [
        'A. Ja, es ist erlaubt',
        'B. Nein, es ist nicht erlaubt',
        'C. Nur kleine Snacks',
        'D. Nur Wasser trinken'
      ],
      'correctAnswerIndex': 1,
      'explanation': 'Vor einer MRT-Untersuchung sollten Sie normalerweise nichts essen, um die Bildqualität nicht zu beeinträchtigen.'
    },
    {
      'question': 'Was passiert, wenn ich Angst vor engen Räumen habe?',
      'answers': [
        'A. Die Untersuchung wird abgebrochen',
        'B. Es werden Beruhigungsmittel verabreicht',
        'C. Nichts, es geht weiter',
        'D. Sie werden hypnotisiert'
      ],
      'correctAnswerIndex': 1,
      'explanation': 'Wenn Sie unter Klaustrophobie leiden, kann Ihr Arzt Ihnen ein Beruhigungsmittel geben, um Ihnen zu helfen, sich zu entspannen.'
    },
    {
      'question': 'Kann ich während der MRT-Untersuchung Musik hören?',
      'answers': [
        'A. Ja, das ist möglich',
        'B. Nein, das ist nicht möglich',
        'C. Nur klassische Musik',
        'D. Nur über Kopfhörer'
      ],
      'correctAnswerIndex': 0,
      'explanation': 'Viele moderne MRT-Geräte ermöglichen es Ihnen, während der Untersuchung Musik zu hören, um Ihnen zu helfen, sich zu entspannen.'
    },
    {
      'question': 'Welche Kleidung sollte ich zur MRT-Untersuchung tragen?',
      'answers': [
        'A. Bequeme, metallfreie Kleidung',
        'B. Jeans und T-Shirt',
        'C. Sportkleidung',
        'D. Jegliche Kleidung'
      ],
      'correctAnswerIndex': 0,
      'explanation': 'Es ist wichtig, dass Sie keine metallischen Gegenstände tragen, da diese das MRT-Bild stören können.'
    },
    {
      'question': 'Kann ich Schmuck während der MRT-Untersuchung tragen?',
      'answers': [
        'A. Ja, das ist kein Problem',
        'B. Nur kleine Ringe',
        'C. Nein, Schmuck muss entfernt werden',
        'D. Nur Ohrringe'
      ],
      'correctAnswerIndex': 2,
      'explanation': 'Metallischer Schmuck kann das Magnetfeld des MRT stören und sollte daher vor der Untersuchung abgelegt werden.'
    },
  ];

  PatientNPC_v2(Vector2 position)
      : imagePath = 'assets/images/characters/alex_front.png',
        badgeImagePath = 'assets/images/objects/BadgePatient-large.png',
        badgeID = kPatientBadge,
        super(
        position: position,
        animation: SimpleDirectionAnimation(
          idleRight: PatientSpriteSheet.idleRightSingleFrame,
          runRight: PatientSpriteSheet.idleRightSingleFrame,
          idleDown: PatientSpriteSheet.idleFrontSingleFrame,
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
          Text(
            greetingText,
            style: TextStyle(color: Colors.white, fontSize: 24),
            textAlign: TextAlign.center,
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
              Text(
                questions[currentQuestionIndex]['question'],
                style: TextStyle(color: Colors.white, fontSize: 24),
                textAlign: TextAlign.center,
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

  String get greetingText => 'Hallo! Ich warte hier auf meine Untersuchung. Können Sie ein paar Fragen beantworten?';
}
