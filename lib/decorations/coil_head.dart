import 'package:RadQuest/maps/hospital_map.dart';
import 'package:RadQuest/player/player_sprite.dart';
import 'package:RadQuest/utilities/constants.dart';
import 'package:bonfire/bonfire.dart';
import 'package:RadQuest/player/player_serife.dart';
import 'package:flutter/material.dart';
import 'package:RadQuest/utilities/styles.dart';

class HeadCoilDecoration extends GameDecoration with Sensor {
  bool dialogFinished = false;

  HeadCoilDecoration(Vector2 position)
      : super.withSprite(
    sprite: Sprite.load('objects/CoilHead.png'), // Assuming the sprite is named 'HeadCoil.png'
    position: position,
    size: Vector2(tileSize * 0.75, tileSize * 0.75),
  ) {
    setSensorInterval(100);
  }

  @override
  void onContact(GameComponent component) {
    // When the player contacts the item
    if (component is PlayerSerife) {
      // Add collectible to player's inventory
      component.collectibles.add(kHeadCoilCollectible); // Assuming kHeadCoilCollectible is defined

      // Pause the game and player input
      gameRef.pauseEngine();
      component.stopMovement(); // Stop player movement

      // Show dialog when player touches the item
      showDialog(
        context: gameRef.context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/objects/CoilHead-large.png', // Assuming this image exists
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Du hast ',
                                style: dialogTextStyle,
                              ),
                              TextSpan(
                                text: 'eine Kopfspule',
                                style: highlightTextStyle,
                              ),
                              TextSpan(
                                text: ' gefunden. Diese spezielle Spule wird bei MRT-Untersuchungen des Kopfes verwendet. Sie bietet eine hohe Bildqualität und präzise Detailgenauigkeit für die Diagnose von Kopf- und Hirnproblemen. Die Kopfspule ist speziell geformt, um sich optimal an die Anatomie des Kopfes anzupassen und die bestmöglichen Ergebnisse zu liefern.',
                                style: dialogTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    child: const Text('Schließen', style: dialogTextStyle),
                    onPressed: () {
                      Navigator.of(context).pop();
                      gameRef.resumeEngine();
                      component.resumeMovement();
                      removeFromParent(); // Remove the item here
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
