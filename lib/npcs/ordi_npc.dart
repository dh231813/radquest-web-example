import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:RadQuest/player/player_serife.dart';
import 'package:RadQuest/player/player_sprite.dart';
import 'package:RadQuest/npcs/base_npc.dart';
import 'package:RadQuest/utilities/constants.dart';
import 'package:RadQuest/utilities/styles.dart'; // Import the styles file

const Color kLightBlueColor = Color(0xFF1fbfa2); // Define the light blue color

class OrdiNPC extends SimpleEnemy with BlockMovementCollision {
  bool isPlayerNearby = false;
  bool isShowingDialog = false;

  OrdiNPC(Vector2 position)
      : super(
    position: position,
    animation: SimpleDirectionAnimation(
      idleRight: OrdiSpriteSheet.ordiFront,
      runRight: OrdiSpriteSheet.ordiFront,
      idleDown: OrdiSpriteSheet.ordiFront,
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
    showGameExplanationDialog(context, player);
  }

  void showGameExplanationDialog(BuildContext context, PlayerSerife player) {
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
                    child: Image.asset('assets/images/characters/ordi.png'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Willkommen bei RadQuest!\n\n'
                          'Dein Ziel ist es, alle sieben Abzeichen zu sammeln, um die geheimnisvolle Box im Krankenhaus zu öffnen. Sprich mit den Personen im Krankenhaus und beantworte ihre Fragen, um Abzeichen zu erhalten.',
                      style: dialogTextStyle, // Use the global TextStyle
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 80),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TextButton(
              child: const Text('Ok, verstanden!', style: TextStyle(color: kLightBlueColor, fontSize: 24)),
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
}
