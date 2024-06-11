import 'package:RadQuest/maps/hospital_map.dart';
import 'package:RadQuest/player/player_sprite.dart';
import 'package:RadQuest/utilities/constants.dart';
import 'package:bonfire/bonfire.dart';
import 'package:RadQuest/player/player_serife.dart';
import 'package:flutter/material.dart';

class PrimovistDecoration extends GameDecoration with Sensor {
  bool dialogFinished = false;

  PrimovistDecoration(Vector2 position)
      : super.withSprite(
    sprite: Sprite.load('objects/Primovist.png'), // Assuming the sprite is named 'Gadolinium.png'
    position: position,
    size: Vector2(tileSize / 2, tileSize / 2),
  ) {
    setSensorInterval(100);
  }

  @override
  void onContact(GameComponent component) {
    // When the player contacts the item
    if (component is PlayerSerife) {
      // Add collectible to player's inventory
      component.collectibles.add(kPrimovistCollectible); // Assuming kGadoliniumCollectible is defined

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
                        'assets/images/objects/Primovist-200.png', // Assuming this image exists
                        width: 50,
                        height: 50,
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Du hast ',
                                style: TextStyle(color: Colors.white, fontSize: 22),
                              ),
                              TextSpan(
                                text: 'Primovist',
                                style: TextStyle(color: Color(0xFF1fbfa2), fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                              TextSpan(
                                text: ' gefunden. Primovist wird intravenös verabreicht und reichert sich in gesunden Zellen an, wodurch die Unterscheidung zwischen gesundem und krankhaftem Gewebe verbessert wird.',
                                style: TextStyle(color: Colors.white, fontSize: 22),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    child: const Text('Schließen', style: TextStyle(color: Colors.white)),
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
