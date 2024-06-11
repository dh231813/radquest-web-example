import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:RadQuest/player/player_serife.dart';
import 'package:RadQuest/player/player_sprite.dart';
import 'package:RadQuest/utilities/constants.dart';

const Color kLightBlueColor = Color(0xFF1fbfa2); // Define the light blue color

class DoctorMRTNPC extends SimpleEnemy with BlockMovementCollision {
  bool isPlayerNearby = false;
  bool isShowingDialog = false;

  final String imagePath = 'assets/images/characters/doctor_mrt.png';
  final String badgeImagePath = 'assets/images/objects/BadgeMRT-large.png';
  final String badgeID = kMRTBadge;

  int currentQuestionIndex = 0;
  int correctAnswersCount = 0;

  @override
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Wie erzeugt ein MRT-Gerät Bilder des Körpers?',
      'answers': [
        'a) Durch Aussendung von Röntgenstrahlen und Messung ihrer Absorption',
        'b) Durch Verwendung von Magnetfeldern und Radiowellen zur Bilderzeugung',
        'c) Durch Aussendung von Gammastrahlen und Messung ihrer Streuung',
        'd) Durch Aussendung von sichtbarem Licht und Messung seiner Brechung'
      ],
      'correctAnswerIndex': 1,
      'explanation': 'Ein MRT-Gerät erzeugt Bilder durch die Verwendung von Magnetfeldern und Radiowellen, die detaillierte Querschnittsbilder des Körpers liefern.'
    },
    {
      'question': 'Welche Eigenschaft der Wasserstoffatome wird in der Magnetresonanztomographie (MRT) genutzt?',
      'answers': [
        'a) Elektronendichte',
        'b) Spin',
        'c) Masse',
        'd) Ladung'
      ],
      'correctAnswerIndex': 1,
      'explanation': 'In der MRT wird der Spin der Wasserstoffatome genutzt, um Bilder des Körpers zu erzeugen.'
    },
    {
      'question': 'Was ist der Zweck der RF-Spule in einem MRT-Gerät?',
      'answers': [
        'a) Erzeugung von Magnetfeldern',
        'b) Erkennung von vom Patienten ausgesendeten Hochfrequenzsignalen',
        'c) Erzeugung von Röntgenstrahlen',
        'd) Verbesserung des Bildkontrasts'
      ],
      'correctAnswerIndex': 1,
      'explanation': 'Die RF-Spule erkennt die Hochfrequenzsignale, die vom Patienten ausgesendet werden, und wandelt sie in Bilder um.'
    },
    {
      'question': 'Was ist die Rolle der Gradienten in einem MRT-Gerät?',
      'answers': [
        'a) Erzeugung des Hauptmagnetfelds',
        'b) Erkennung von vom Patienten ausgesendeten Gammastrahlen',
        'c) Manipulation des Magnetfelds zur räumlichen Kodierung der Signale',
        'd) Reduzierung der Hintergrundstrahlung'
      ],
      'correctAnswerIndex': 2,
      'explanation': 'Die Gradienten in einem MRT-Gerät manipulieren das Magnetfeld, um die räumliche Kodierung der Signale zu ermöglichen.'
    },
    {
      'question': 'Welche Einheit wird verwendet, um die Stärke des Hauptmagnetfelds in einem MRT-Gerät zu messen?',
      'answers': [
        'a) Watt',
        'b) Tesla',
        'c) Hertz',
        'd) Newton'
      ],
      'correctAnswerIndex': 1,
      'explanation': 'Die Stärke des Hauptmagnetfelds in einem MRT-Gerät wird in Tesla gemessen.'
    },
    {
      'question': 'Welche Eigenschaft von Geweben beeinflusst deren Signalintensität in MRT-Bildern?',
      'answers': [
        'a) Dichte',
        'b) Elastizität',
        'c) Relaxationszeiten',
        'd) Leitfähigkeit'
      ],
      'correctAnswerIndex': 2,
      'explanation': 'Die Signalintensität in MRT-Bildern wird durch die Relaxationszeiten der Gewebe beeinflusst, die unterschiedliche Signale erzeugen.'
    },
    {
      'question': 'Was ist der Zweck von Kontrastmitteln in der MRT-Bildgebung?',
      'answers': [
        'a) Verbesserung der Sichtbarkeit von Geweben und Strukturen',
        'b) Reduzierung von Bewegungsartefakten',
        'c) Verkürzung der Scan-Zeit',
        'd) Erhöhung des Patientenkomforts'
      ],
      'correctAnswerIndex': 0,
      'explanation': 'Kontrastmittel verbessern die Sichtbarkeit von Geweben und Strukturen, indem sie die Signalintensität in bestimmten Bereichen erhöhen.'
    },
  ];

  DoctorMRTNPC(Vector2 position)
      : super(
    position: position,
    animation: SimpleDirectionAnimation(
      idleRight: DoctorMRTSpriteSheet.docIdle,
      runRight: DoctorMRTSpriteSheet.docFront,
      idleDown: DoctorMRTSpriteSheet.docIdle,
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

  String get greetingText => 'Guten Tag! Ich bin hier für die Magnetresonanztomographie zuständig. Lassen Sie uns doch testen, wie gut Sie sich mit MRT auskennen.';
}
