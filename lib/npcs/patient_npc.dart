import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:RadQuest/player/player_serife.dart';
import 'package:RadQuest/player/player_sprite.dart';

const String kPatientBadge = 'PatientBadge';

class PatientNPC extends SimpleEnemy with BlockMovementCollision, Sensor {
  bool npcDialogFinished = false;
  int currentQuestionIndex = 0;
  int correctAnswersCount = 0;

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

  PatientNPC(Vector2 position)
      : super(
    animation: SimpleDirectionAnimation(
      idleRight: PatientSpriteSheet.idleRightSingleFrame,
      runRight: PatientSpriteSheet.idleRightSingleFrame,
    ),
    position: position,
    size: Vector2(16, 23) * 2,
    speed: 0,
  ) {
    setSensorInterval(50);
  }

  @override
  void onContact(GameComponent component) {
    if (component is PlayerSerife) {
      gameRef.pauseEngine();
      component.stopMovement();
      _resetQuiz();
      _showQuizDialog(gameRef.context, component);
    }
  }

  void _resetQuiz() {
    currentQuestionIndex = 0;
    correctAnswersCount = 0;
  }

  void _showQuizDialog(BuildContext context, PlayerSerife player) {
    if (currentQuestionIndex < questions.length) {
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
                  child: PatientSpriteSheet.idleFrontSingleFrame.asWidget(),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    questions[currentQuestionIndex]['question'],
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ..._buildAnswerButtons(context, player)
          ],
        ),
      );
    } else {
      _showFinalResultDialog(context, player);
    }
  }

  List<Widget> _buildAnswerButtons(BuildContext context, PlayerSerife player) {
    List<Widget> buttons = [];
    List<String> answers = questions[currentQuestionIndex]['answers'];
    for (int i = 0; i < answers.length; i++) {
      buttons.add(_buildAnswerButton(context, player, answers[i], i == questions[currentQuestionIndex]['correctAnswerIndex']));
    }
    return buttons;
  }

  Widget _buildAnswerButton(BuildContext context, PlayerSerife player, String answerText, bool isCorrect) {
    return TextButton(
      child: Text(answerText, style: const TextStyle(color: Colors.white)),
      onPressed: () {
        Navigator.of(context).pop();
        _showFeedbackDialog(context, player, isCorrect);
      },
    );
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
                child: PatientSpriteSheet.idleFrontSingleFrame.asWidget(),
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
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: isCorrect ? '' : 'Die richtige Antwort ist: ',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          TextSpan(
                            text: questions[currentQuestionIndex]['answers'][questions[currentQuestionIndex]['correctAnswerIndex']],
                            style: TextStyle(color: Color(0xFF1fbfa2), fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          TextSpan(
                            text: '. ${questions[currentQuestionIndex]['explanation']}',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextButton(
            child: const Text('Weiter', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.of(context).pop();
              currentQuestionIndex++;
              _showQuizDialog(context, player);
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
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Du hast ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                TextSpan(
                  text: '$correctAnswersCount',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                TextSpan(
                  text: ' von ${questions.length} Fragen richtig beantwortet!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (correctAnswersCount >= 5) ...[
            Image.asset(
              'assets/images/objects/BadgePatient-large.png', // Path to the badge image
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
                      fontSize: 18,
                    ),
                  ),
                  TextSpan(
                    text: 'Badge für herausragende Beratung',
                    style: TextStyle(
                      color: Color(0xFF1fbfa2),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  TextSpan(
                    text: ' erhalten!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
          TextButton(
            child: const Text('Schließen', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.of(context).pop();
              gameRef.resumeEngine();
              player.resumeMovement();
            },
          ),
        ],
      ),
    );

    if (correctAnswersCount >= 5) {
      player.badges.add(kPatientBadge);
    }
  }

  void _showCustomDialog({required BuildContext context, required PlayerSerife player, required Widget child}) {
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
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(16),
            child: child,
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
    });
  }
}
