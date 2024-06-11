import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:RadQuest/utilities/jenny_dialog.dart';
import 'package:RadQuest/player/player_serife.dart';


class BaseItem extends SimpleEnemy with BlockMovementCollision {
  final List<Say> initialDialog;
  final List<Say> subsequentDialog;
  final SimpleDirectionAnimation spriteSheet;
  bool dialogFinished = false;

  BaseItem({
    required Vector2 position,
    required this.initialDialog,
    required this.subsequentDialog,
    required this.spriteSheet,
    double life = 100,
    Vector2? size,
  }) : super(
    animation: spriteSheet,
    position: position,
    size: size ?? Vector2(16, 23) * 2,
    life: life,
  );

  @override
  Future<void> onLoad() {
    add(RectangleHitbox(size: size));
    return super.onLoad();
  }
  @override
  void onContact(GameComponent component, bool active) {
    if (component is PlayerSerife) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return GameDialog(
            dialogText: [
              DialogText(
                richText: [
                  TextSpan(
                    text: 'Du hast ',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  TextSpan(
                    text: 'Gadolinium',
                    style: TextStyle(color: Color(0xFF0BD99E), fontSize: 18),
                  ),
                  TextSpan(
                    text: ' gefunden. Es ist ein Seltenerdmetall, das in der medizinischen Bildgebung verwendet wird. Gadolinium verbessert die Qualität von MRT-Bildern und hilft, Krankheiten und Verletzungen besser zu erkennen.',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
                image: Image.asset(
                  'assets/images/objects/Gadolinium-200.png', // Assuming this image exists
                  width: 200,
                  height: 266,
                ),
              ),
            ],
            onFinish: () {
              dialogFinished = true;
              // Close the dialog and resume the game
              Navigator.of(context).pop();
            },
          );
        },
      ).then((_) {
        // This is called when the dialog is dismissed
        gameRef.resumeEngine();
        component.resumeMovement(); // Resume player movement
      });

      removeFromParent();
    }
  }
}
