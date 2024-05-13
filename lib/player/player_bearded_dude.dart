import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlayerBeardedDude extends SimplePlayer with BlockMovementCollision {
  PlayerBeardedDude(
    position, {
    required this.spriteSheet,
    Direction initDirection = Direction.down,
  }) : super(
          // SpriteSheetからアニメーションを設定
   animation: SimpleDirectionAnimation(
            idleDown: spriteSheet.createAnimation(row: 0, stepTime: 0.4, from: 1, to: 3).asFuture(),
            idleLeft: spriteSheet.createAnimation(row: 1, stepTime: 0.4, from: 1, to: 3).asFuture(),
            idleRight:
                spriteSheet.createAnimation(row: 2, stepTime: 0.4, from: 1, to: 3).asFuture(),
            idleUp: spriteSheet.createAnimation(row: 3, stepTime: 0.4, from: 1, to: 3).asFuture(),
            runDown: spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 4, to: 8).asFuture(),
            runLeft: spriteSheet.createAnimation(row: 1, stepTime: 0.1, from: 4, to: 8).asFuture(),
            runRight: spriteSheet.createAnimation(row: 2, stepTime: 0.1, from: 4, to: 8).asFuture(),
            runUp: spriteSheet.createAnimation(row: 3, stepTime: 0.1, from: 4, to: 8).asFuture(),
          ),
          // 画面上の表示サイズ
          size: Vector2(16, 24) * 3,
          // 移動速度
          speed: 80 * 3,
          position: position,
          initDirection: initDirection,
        ) {
    // 当たり判定の設定
   /* setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            // 首から足下までの矩形を指定
            size: Vector2(size.x * 12 / 16, size.y * 7 / 24),
            align: Vector2(size.x * 2 / 16, size.y * 16 / 24),
          ),
        ],
      ),
    );*/
  }
    @override
  Future<void> onLoad() {
    add(RectangleHitbox(size:size));
    return super.onLoad();
  }
  final SpriteSheet spriteSheet;
}
