import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:RadQuest/player/player_serife.dart';
import 'package:RadQuest/utilities/constants.dart';

const Color kLightBlueColor = Color(0xFF1fbfa2); // Define the light blue color

// Superclass for NPCs with quiz functionality
abstract class QuizNPC extends SimpleEnemy with BlockMovementCollision, Sensor {
  bool npcDialogFinished = false;
  int currentQuestionIndex = 0;
  int correctAnswersCount = 0;
  bool greetingShown = false;

  final String imagePath;
  final String badgeImagePath;
  final String badgeID;

  List<Map<String, dynamic>> get questions;

  // Abstract getter for greeting text
  String get greetingText;

  QuizNPC({
    required Vector2 position,
    required SimpleDirectionAnimation animation,
    required this.imagePath,
    required this.badgeImagePath,
    required this.badgeID,
    double sizeMultiplier = 2.0,
  }) : super(
    animation: animation,
    position: position,
    size: Vector2(16, 23) * sizeMultiplier,
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
      _showGreetingDialog(gameRef.context, component);
    }
  }

  void _resetQuiz() {
    currentQuestionIndex = 0;
    correctAnswersCount = 0;
    greetingShown = false;
  }

  void _showGreetingDialog(BuildContext context, PlayerSerife player) {
    showCustomDialog(
      context: context,
      player: player,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
              greetingShown = true;
              _showQuizDialog(context, player);
            },
          ),
        ],
      ),
    );
  }

  void _showQuizDialog(BuildContext context, PlayerSerife player) {
    if (!greetingShown) {
      _showGreetingDialog(context, player);
      return;
    }

    if (currentQuestionIndex < questions.length) {
      showCustomDialog(
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
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 24), // Increased font size
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ..._buildAnswerButtons(context, player),
              ],
            ),
            const SizedBox(height: 40), // Increased spacing between answers and button
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildContinueButton(context, player),
            ),
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
      buttons.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: _buildAnswerButton(
            context,
            player,
            answers[i],
            i == questions[currentQuestionIndex]['correctAnswerIndex'],
          ),
        ),
      );
    }
    return buttons;
  }

  Widget _buildAnswerButton(BuildContext context, PlayerSerife player, String answerText, bool isCorrect) {
    return TextButton(
      child: Text(answerText, style: TextStyle(color: Colors.white, fontSize: 20)), // Increased font size and light blue color
      onPressed: () {
        Navigator.of(context).pop();
        _showFeedbackDialog(context, player, isCorrect);
      },
    );
  }

  Widget _buildContinueButton(BuildContext context, PlayerSerife player) {
    return TextButton(
      child: const Text('Weiter', style: TextStyle(color: kLightBlueColor, fontSize: 20)), // Increased font size
      onPressed: () {
        Navigator.of(context).pop();
        currentQuestionIndex++;
        _showQuizDialog(context, player);
      },
    );
  }

  void _showFeedbackDialog(BuildContext context, PlayerSerife player, bool isCorrect) {
    if (isCorrect) {
      correctAnswersCount++;
      _handleCorrectAnswer(player);
    } else {
      _handleIncorrectAnswer(player);
    }

    showCustomDialog(
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
                        fontSize: 28, // Increased font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: isCorrect ? '' : 'Die richtige Antwort ist: ',
                            style: TextStyle(color: Colors.white, fontSize: 22), // Increased font size
                          ),
                          TextSpan(
                            text: questions[currentQuestionIndex]['answers'][questions[currentQuestionIndex]['correctAnswerIndex']],
                            style: TextStyle(color: kLightBlueColor, fontWeight: FontWeight.bold, fontSize: 22), // Increased font size and light blue color
                          ),
                          TextSpan(
                            text: '. ${questions[currentQuestionIndex]['explanation']}',
                            style: TextStyle(color: Colors.white, fontSize: 22), // Increased font size
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
            child: const Text('Weiter', style: TextStyle(color: kLightBlueColor, fontSize: 20)), // Increased font size
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

  void _handleCorrectAnswer(PlayerSerife player) {
    // This method can be overridden by subclasses to handle correct answers
  }

  void _handleIncorrectAnswer(PlayerSerife player) {
    // This method can be overridden by subclasses to handle incorrect answers
  }

  void _showFinalResultDialog(BuildContext context, PlayerSerife player) {
    showCustomDialog(
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
                        fontSize: 22, // Increased font size
                      ),
                    ),
                    TextSpan(
                      text: '$correctAnswersCount',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 22, // Increased font size
                      ),
                    ),
                    TextSpan(
                      text: ' von ${questions.length} Fragen richtig beantwortet!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22, // Increased font size
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (correctAnswersCount >= 5) ...[
                Image.asset(
                  badgeImagePath, // Path to the badge image
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
                          fontSize: 22, // Increased font size
                        ),
                      ),
                      TextSpan(
                        text: 'Abzeichen für herausragende Beratung',
                        style: TextStyle(
                            color: kLightBlueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 22), // Increased font size and light blue color
                      ),
                      TextSpan(
                        text: ' erhalten!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22, // Increased font size
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ],
          ),
          const SizedBox(height: 40), // Increased spacing between answers and button
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: TextButton(
              child: const Text('Schließen', style: TextStyle(color: Colors.white, fontSize: 20)), // Increased font size
              onPressed: () {
                Navigator.of(context).pop();
                gameRef.resumeEngine();
                player.resumeMovement();
              },
            ),
          ),
        ],
      ),
    );

    if (correctAnswersCount >= 5) {
      player.addBadge(badgeID);
    }
  }

  void showCustomDialog({required BuildContext context, required PlayerSerife player, required Widget child}) {
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
    });
  }
}
