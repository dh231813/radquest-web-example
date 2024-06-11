import 'package:RadQuest/maps/hospital_map.dart';
import 'package:RadQuest/player/player_sprite.dart';
import 'package:RadQuest/utilities/constants.dart';
import 'package:bonfire/bonfire.dart';
import 'package:RadQuest/player/player_serife.dart';
import 'package:flutter/material.dart';

class KneeCoilDecoration extends GameDecoration with Sensor {
  bool dialogFinished = false;

  KneeCoilDecoration(Vector2 position)
      : super.withSprite(
    sprite: Sprite.load('objects/CoilKnee.png'), // Assuming the sprite is named 'CoilKnee.png'
    position: position,
    size: Vector2(tileSize*0.75, tileSize*0.75),
  ) {
    setSensorInterval(100);
  }

  @override
  void onContact(GameComponent component) {
    // When the player contacts the item
    if (component is PlayerSerife) {
      // Add collectible to player's inventory
      component.collectibles.add(kKneeCoilCollectible); // Assuming kKneeCoilCollectible is defined

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
                        'assets/images/objects/CoilKnee-large.png', // Assuming this image exists
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
                                style: TextStyle(color: Colors.white, fontSize: 22),
                              ),
                              TextSpan(
                                text: 'eine Kniespule',
                                style: TextStyle(color: Color(0xFF1fbfa2), fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                              TextSpan(
                                text: 'gefunden. Diese spezielle MRT-Spule ist darauf ausgelegt, das Knie zu umschließen und hochauflösende Bilder zu liefern. Diese Bilder sind entscheidend für die Diagnose von Bänderrissen, Knorpelschäden und anderen Knieerkrankungen. Dank ihrer präzisen Passform wird der Signalempfang verbessert, was zu einer detaillierten Visualisierung der komplexen Knie-Strukturen führt. Dies ist für die Planung von chirurgischen Eingriffen oder Rehabilitationsstrategien äußerst wichtig.',
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
