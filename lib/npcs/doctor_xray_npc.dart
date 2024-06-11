import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:RadQuest/player/player_serife.dart';
import 'package:RadQuest/player/player_sprite.dart';
import 'package:RadQuest/utilities/constants.dart';

const Color kLightBlueColor = Color(0xFF1fbfa2); // Define the light blue color

class DoctorXRayNPC extends SimpleEnemy with BlockMovementCollision {
  bool isPlayerNearby = false;
  bool isShowingDialog = false;

  final String imagePath = 'assets/images/characters/doctor_xray.png';
  final String badgeImagePath = 'assets/images/objects/BadgeXRay-large.png';
  final String badgeID = kXrayBadge;

  int currentQuestionIndex = 0;
  int correctAnswersCount = 0;

  @override
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Wofür wird ein C-Bogen hauptsächlich in der radiologischen Bildgebung verwendet?',
      'answers': [
        'a) Mammographie',
        'b) Echtzeitorthopädische Eingriffe',
        'c) CT-Scans',
        'd) Ultraschalluntersuchungen'
      ],
      'correctAnswerIndex': 1,
      'explanation': 'Ein C-Bogen wird hauptsächlich für Echtzeitorthopädische Eingriffe verwendet, da er eine kontinuierliche Röntgenbildgebung während der Operation ermöglicht.'
    },
    {
      'question': 'Was ist die Hauptfunktion des C-Bogens?',
      'answers': [
        'a) Erzeugung von Röntgenstrahlen',
        'b) Bewegung der Röntgenquelle und des Detektors um den Patienten',
        'c) Magnetresonanztomographie (MRT)',
        'd) Erzeugung von Ultraschallwellen'
      ],
      'correctAnswerIndex': 1,
      'explanation': 'Die Hauptfunktion des C-Bogens ist die Bewegung der Röntgenquelle und des Detektors um den Patienten, um Bilder aus verschiedenen Winkeln zu erhalten.'
    },
    {
      'question': 'Welche Art von Bildgebung bietet ein C-Bogen in Echtzeit während chirurgischer Eingriffe?',
      'answers': [
        'a) 2D-Röntgenbilder',
        'b) 3D-Ultraschallbilder',
        'c) Fluoroskopiebilder',
        'd) MRT-Bilder'
      ],
      'correctAnswerIndex': 2,
      'explanation': 'Ein C-Bogen bietet Fluoroskopiebilder, die Echtzeit-Röntgenaufnahmen sind und während der Operation verwendet werden.'
    },
    {
      'question': 'Was ist der Zweck eines Kollimators in einem Röntgengerät?',
      'answers': [
        'a) Erhöhung der Intensität des Röntgenstrahls',
        'b) Formung und Begrenzung des Röntgenstrahls',
        'c) Reduzierung der Streustrahlung',
        'd) Verbesserung des Bildkontrasts'
      ],
      'correctAnswerIndex': 1,
      'explanation': 'Der Kollimator formt und begrenzt den Röntgenstrahl, um die Belichtung des gewünschten Bereichs zu optimieren und unnötige Strahlung zu minimieren.'
    },
    {
      'question': 'Wie wird Röntgenstrahlung in einer Röntgenröhre erzeugt?',
      'answers': [
        'a) Durch das Erhitzen eines Filaments zur Elektronenerzeugung, die dann beschleunigt und auf ein Zielmaterial treffen',
        'b) Durch Magnetresonanztomographie (MRT)',
        'c) Durch Aussendung von Schallwellen',
        'd) Durch das Durchleiten von Elektrizität durch eine gasgefüllte Röhre'
      ],
      'correctAnswerIndex': 0,
      'explanation': 'Röntgenstrahlung entsteht, wenn ein erhitztes Filament Elektronen erzeugt, die dann beschleunigt und auf ein Zielmaterial treffen, wodurch Röntgenstrahlen freigesetzt werden.'
    },
    {
      'question': 'Was ist der Zweck der Abschirmung in einer Röntgenröhre?',
      'answers': [
        'a) Fokussierung des Röntgenstrahls',
        'b) Erkennung von Röntgenphotonen',
        'c) Schutz des Bedieners und der Umgebung vor unnötiger Strahlenbelastung',
        'd) Verbesserung des Bildkontrasts'
      ],
      'correctAnswerIndex': 2,
      'explanation': 'Die Abschirmung in einer Röntgenröhre schützt den Bediener und die Umgebung vor unnötiger Strahlenbelastung, indem sie Streustrahlung blockiert.'
    },
    {
      'question': 'Was ist die Rolle der Anode in einer Röntgenröhre?',
      'answers': [
        'a) Aussendung von Röntgenstrahlen',
        'b) Erkennung von Röntgenphotonen',
        'c) Erzeugung des Hauptmagnetfelds',
        'd) Manipulation des Magnetfelds zur räumlichen Kodierung der Signale'
      ],
      'correctAnswerIndex': 0,
      'explanation': 'Die Anode in einer Röntgenröhre dient zur Aussendung von Röntgenstrahlen, wenn sie von beschleunigten Elektronen getroffen wird.'
    },
    {
      'question': 'Was ist die Rolle der Kathode in einer Röntgenröhre?',
      'answers': [
        'a) Aussendung von Röntgenstrahlen',
        'b) Erkennung von Röntgenphotonen',
        'c) Erzeugung des Hauptmagnetfelds',
        'd) Erzeugung eines fokussierten Elektronenstrahls'
      ],
      'correctAnswerIndex': 3,
      'explanation': 'Die Kathode in einer Röntgenröhre erzeugt einen fokussierten Elektronenstrahl, der zur Anode beschleunigt wird, um Röntgenstrahlen zu erzeugen.'
    },
  ];

  DoctorXRayNPC(Vector2 position)
      : super(
    position: position,
    animation: SimpleDirectionAnimation(
      idleRight: DoctorXRaySpriteSheet.docIdle,
      runRight: DoctorXRaySpriteSheet.docFront,
      idleDown: DoctorXRaySpriteSheet.docIdle,
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
                        text: 'Röntgen-Abzeichen',
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

  String get greetingText => 'Hallo! Wir befinden uns hier beim C-Bogen. Lassen Sie uns sehen, wie gut Sie sich mit der Röntgentechnologie auskennen.';
}
