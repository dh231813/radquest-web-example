import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:RadQuest/player/player_serife.dart';
import 'package:RadQuest/utilities/constants.dart';
import 'package:RadQuest/player/player_sprite.dart';

const Color kLightBlueColor = Color(0xFF1fbfa2); // Define the light blue color
const String kCoilBadge = 'CoilBadge'; // Define the badge ID

class DoctorCoilNPC extends SimpleEnemy with BlockMovementCollision {
  bool hasInteracted = false;
  bool isShowingDialog = false;
  bool hasReceivedBadge = false; // New flag to track if the badge has been received
  bool isPlayerNearby = false; // Flag to track if the player is nearby
  final String imagePath;
  final String badgeImagePath;
  final String badgeID;
  final List<String> allCoils = ['Kopfspule', 'Handspule', 'Kniespule', 'Fußspule'];

  DoctorCoilNPC({
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
    add(RectangleHitbox(size: size * 2));
    HardwareKeyboard.instance.addHandler(_handleKey);
  }

  @override
  void update(double dt) {
    super.update(dt);
    speed = 0;
    _checkPlayerProximity();
  }

  void _checkPlayerProximity() {
    final player = gameRef.player;
    if (player != null && player is PlayerSerife) {
      final distance = player.position.distanceTo(position);
      isPlayerNearby = distance < size.x + player.size.x; // Adjust distance threshold as needed
    }
  }

  @override
  void onRemove() {
    HardwareKeyboard.instance.removeHandler(_handleKey);
    super.onRemove();
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
    if (hasReceivedBadge) {
      _showThankYouDialogue(context, player);
    } else if (!hasInteracted) {
      hasInteracted = true;
      _showInitialDialogue(context, player);
    } else {
      _showSecondDialogue(context, player);
    }
  }

  void _showInitialDialogue(BuildContext context, PlayerSerife player) {
    _showCustomDialog(
      context: context,
      player: player,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                  'Hallo! Wir haben einen Patienten, der eine Untersuchung des Ellenbogens benötigt. Ich brauche die richtige Spule für das MRT-Gerät. Können Sie sie bitte holen? Achten Sie darauf, dass es die richtige Spule für diese Untersuchung ist!',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextButton(
            child: const Text('Ok, verstanden', style: TextStyle(color: kLightBlueColor, fontSize: 20)),
            onPressed: () {
              Navigator.of(context).pop();
              _resumeGame(player);
            },
          ),
        ],
      ),
    );
  }

  void _showSecondDialogue(BuildContext context, PlayerSerife player) {
    List<String> inventory = player.collectibles;
    List<String> availableCoils = allCoils.where((coil) => inventory.contains(coil)).toList();

    if (availableCoils.isEmpty) {
      _showNoCoilsDialogue(context, player);
      return;
    }

    _showCoilsSelectionDialogue(context, player, availableCoils);
  }

  void _showNoCoilsDialogue(BuildContext context, PlayerSerife player) {
    _showCustomDialog(
      context: context,
      player: player,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                  'Ohne die richtige Spule können wir die Untersuchung nicht durchführen. Bitte gehen Sie und besorgen Sie sie so schnell wie möglich.',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextButton(
            child: const Text('Ok', style: TextStyle(color: kLightBlueColor, fontSize: 20)),
            onPressed: () {
              Navigator.of(context).pop();
              _resumeGame(player);
            },
          ),
        ],
      ),
    );
  }

  void _showCoilsSelectionDialogue(BuildContext context, PlayerSerife player, List<String> availableCoils) {
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
                      'Ah, Sie sind zurück. Ich sehe, Sie haben einige Spulen gefunden. Welche davon möchten Sie mir für die MRT-Untersuchung des Ellenbogens geben?',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ..._buildAnswerButtons(context, player, availableCoils),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  List<Widget> _buildAnswerButtons(BuildContext context, PlayerSerife player, List<String> availableCoils) {
    List<Widget> buttons = [];
    for (String coil in availableCoils) {
      buttons.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: TextButton(
            child: Text(coil, style: TextStyle(color: Colors.white, fontSize: 20)),
            onPressed: () {
              Navigator.of(context).pop();
              _checkAnswer(context, player, coil);
            },
          ),
        ),
      );
    }
    return buttons;
  }

  void _checkAnswer(BuildContext context, PlayerSerife player, String coil) {
    if (coil == 'Kniespule') { // Ensure 'Kniespule' is the correct answer
      player.removeCollectible(coil);
      player.addBadge(badgeID);
      hasReceivedBadge = true; // Set flag when the correct item is delivered
      _showCorrectAnswerDialogue(context, player);
    } else {
      player.removeCollectible(coil);
      _showIncorrectAnswerDialogue(context, player);
    }
  }

  void _showCorrectAnswerDialogue(BuildContext context, PlayerSerife player) {
    _showCustomDialog(
      context: context,
      player: player,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                  'Hervorragend! Genau das, was wir brauchen. Gute Arbeit, das wird uns sehr weiterhelfen.',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
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
                  text: 'Spulen-Abzeichen',
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
          TextButton(
            child: const Text('Ok', style: TextStyle(color: kLightBlueColor, fontSize: 20)),
            onPressed: () {
              Navigator.of(context).pop();
              _showThankYouDialogue(context, player); // Show thank you dialog after badge dialog
            },
          ),
        ],
      ),
    );
  }

  void _showIncorrectAnswerDialogue(BuildContext context, PlayerSerife player) {
    _showCustomDialog(
      context: context,
      player: player,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                  'Moment mal... Das ist nicht die richtige Spule. Bitte bringen Sie mir die richtige Spule für eine MRT-Untersuchung des Ellenbogens.',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextButton(
            child: const Text('Ok', style: TextStyle(color: kLightBlueColor, fontSize: 20)),
            onPressed: () {
              Navigator.of(context).pop();
              _resumeGame(player);
            },
          ),
        ],
      ),
    );
  }

  void _showThankYouDialogue(BuildContext context, PlayerSerife player) {
    _showCustomDialog(
      context: context,
      player: player,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                  'Vielen Dank für Ihre Hilfe!',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextButton(
            child: const Text('Ok', style: TextStyle(color: kLightBlueColor, fontSize: 20)),
            onPressed: () {
              Navigator.of(context).pop();
              _resumeGame(player);
            },
          ),
        ],
      ),
    );
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
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(child: child),
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
      _resumeGame(player); // Resume game when dialog is dismissed
    });
  }

  void _resumeGame(PlayerSerife player) {
    isShowingDialog = false;
    gameRef.resumeEngine();
    player.resumeMovement();
  }
}

// Usage example
DoctorCoilNPC createDoctorCoilNPC(Vector2 position) {
  return DoctorCoilNPC(
    position: position,
    animation: SimpleDirectionAnimation(
      idleRight: DoctorXRaySpriteSheet.docIdle,
      runRight: DoctorXRaySpriteSheet.docFront,
      idleDown: DoctorXRaySpriteSheet.docIdle,
    ),
    imagePath: 'assets/images/characters/doctor_coil.png', // Provide the image path here
    badgeImagePath: 'assets/images/objects/BadgeCoil-large.png', // Provide the image path here
    badgeID: kCoilBadge,
  );
}
