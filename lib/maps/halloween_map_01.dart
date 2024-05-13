import 'package:flutter/material.dart';
import 'package:bonfire/bonfire.dart';
import 'package:flutter/services.dart';
import 'package:untitled/player/player_bearded_dude.dart';
import 'package:untitled/player/player_sprite.dart';


class HalloweenMap01 extends StatefulWidget {
  const HalloweenMap01({Key? key}) : super(key: key);
  @override
  State<HalloweenMap01> createState() => _HalloweenMap01State();
}

class _HalloweenMap01State extends State<HalloweenMap01> {
  final tileSize = 48.0; // タイルのサイズ定義

  @override
  Widget build(BuildContext context) {
    // ゲーム画面Widget
    return BonfireWidget(
      // マップ用jsonファイル読み込み
      map: 
      WorldMapByTiled(TiledReader.asset('tiled/radquest_map.json'),
      
    forceTileSize: Vector2(tileSize, tileSize),
      ),      

       // ---------- ここから追加 ----------
      // プレイヤーキャラクター
              //showCollisionArea:false,

      player: PlayerBeardedDude(
        Vector2(tileSize * 7.5, tileSize * 4),
        spriteSheet: PlayerSpriteSheet.all,
        initDirection: Direction.down,
      ),
      // カメラ設定
      /*cameraConfig: CameraConfig(
        moveOnlyMapArea: true,
        sizeMovementWindow: Vector2.zero(),
        smoothCameraEnabled: true,
        smoothCameraSpeed: 10,
      ),*/
      // ---------- ここまで追加 ----------






      // 入力インターフェースの設定
      joystick: Joystick(
        // 画面上のジョイスティック追加
        directional: JoystickDirectional(
          color: Colors.white,
        ),
        actions: [
          // 画面上のアクションボタン追加
          JoystickAction(
            color: Colors.white,
            actionId: 1,
            margin: const EdgeInsets.all(65),
          ),
        ],
        // キーボード用入力の設定
       /* keyboardConfig: KeyboardConfig(
          keyboardDirectionalType: KeyboardDirectionalType.wasdAndArrows, // キーボードの矢印とWASDを有効化
          acceptedKeys: [LogicalKeyboardKey.space], // キーボードのスペースバーを有効化
        ),*/
      ),
      // ロード中の画面の設定
      /*progress: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        color: Colors.black,
      ),*/
    );
  }
}

