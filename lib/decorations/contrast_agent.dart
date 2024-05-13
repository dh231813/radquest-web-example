import 'package:bonfire/bonfire.dart';
import 'package:untitled/player/player_bearded_dude.dart';
import 'package:untitled/model/game_item.dart';

class ContrastAgentDecoration extends GameDecoration with Sensor {
  ContrastAgentDecoration(
      {required this.initPosition, required this.map, required this.id, required this.player})
      : super.withSprite(
          sprite: Sprite.load(gameItem.imagePath),
          position: initPosition,
          size: Vector2(48, 48),
        ) {
    setupSensorArea(areaSensor: [
      CollisionArea.rectangle(size: size, align: Vector2.zero()),
    ]);
  }
  static final gameItem = ContrastAgent(); // アイテムクラス

  final Vector2 initPosition; // 初期
  final Type map; // 配置されているマップ
  final int id; // マップ中のアイテムのID番号
  final PlayerBeardedDude player; // 取得するプレイヤーキャラクター

  @override
  void onContact(GameComponent component) {
    // プレイヤーが接触したら
    if (component is player) {
      // 画面から消える
      removeFromParent();
    }
  }
}

