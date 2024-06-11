// barium_decoration.dart

import 'package:RadQuest/maps/hospital_map.dart';
import 'package:RadQuest/player/player_sprite.dart';
import 'package:RadQuest/utilities/constants.dart';
import 'package:bonfire/bonfire.dart';
import 'package:RadQuest/player/player_serife.dart';
import 'package:flutter/material.dart';
import 'package:RadQuest/utilities/jenny_dialog.dart';

class BariumDecoration extends GameDecoration with Sensor {
  bool dialogFinished = false;

  BariumDecoration(Vector2 position)
      : super.withSprite(
    sprite: Sprite.load('objects/Barium.png'), // Assuming the sprite is named 'Barium.png'
    position: position,
    size: Vector2(tileSize / 2, tileSize / 2),
  ) {
    setSensorInterval(100);
  }

  @override
  void onContact(GameComponent component) {
    // プレイヤーが接触したら
    if (component is PlayerSerife) {
      // display collectible on the screen
      component.collectibles.add(kBariumCollectible); // Assuming kBariumCollectible is defined

      // Pause the game and player input
      gameRef.pauseEngine();
      component.stopMovement(); // Stop player movement

      // Show dialog when player touches the item using Jenny
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return GameDialog(
            dialogText: [
              DialogText(
                richText: [
                  TextSpan(
                    text: 'Du hast ',
                    style: TextStyle(color: Colors.white, fontSize:22),
                  ),
                  TextSpan(
                    text: 'ein Kontrastmittel auf Basis von Bariumsulfat',
                    style: TextStyle(color: Color(0xFF0BD99E), fontSize: 22),
                  ),
                  TextSpan(
                    text: ' gefunden. Bariumsulfat verbessert die Darstellung der Speiseröhre, des Magens und des Darms, sodass Ärzte Strukturen und mögliche Anomalien besser erkennen können.',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ],
                image: Image.asset(
                  'assets/images/objects/Barium-200.png', // Assuming this image exists
                  width: 50,
                  height: 50,
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
