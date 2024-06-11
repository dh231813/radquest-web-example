import 'package:RadQuest/utilities/constants.dart';
import 'package:bonfire/bonfire.dart';
import 'package:RadQuest/player/player_bearded_dude.dart';

//das hier nimmt er
class ContrastAgentDecoration extends GameDecoration with Sensor{
  ContrastAgentDecoration(Vector2 position)
      : super.withSprite(
          sprite: Sprite.load('objects/Gadolinium.png'),
          position: position,
          size: Vector2(32, 32),
      ){
        
    setSensorInterval(100);
  }
    
  @override
  void onContact(GameComponent component) {
    // プレイヤーが接触したら
    if (component is PlayerBeardedDude) {
      // display collectible on the screen
      component.collectibles.add(kDartCollectible);
      add(OpacityEffect.fadeOut(LinearEffectController(0.3)));
      removeFromParent();
    }
  }

}