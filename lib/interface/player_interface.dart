import 'package:RadQuest/player/player_bearded_dude.dart';
import 'package:bonfire/bonfire.dart';

import '../utilities/constants.dart';

class PlayerInterface extends GameInterface{
  late Sprite dartCollectible;

  @override
  Future<void> onLoad() async{
    dartCollectible = await Sprite.load('images/Aqua.png');
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    try {
      // draw collectible
      _drawCollectible(canvas);

    } catch (e) {}
    super.render(canvas);
  }
  void _drawCollectible(Canvas canvas){
    if (gameRef.player!=null && (gameRef.player as PlayerBeardedDude).collectibles.contains(kDartCollectible)){
      dartCollectible.renderRect(canvas, const Rect.fromLTWH(100, 20, 30, 35));
    }
  }
}