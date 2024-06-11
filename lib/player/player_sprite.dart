import 'package:bonfire/bonfire.dart';

class PlayerSpriteSheet {
  static late SpriteSheet all;

  // ゲーム起動時に実行するメソッド
  static Future<void> load() async {
    // 追加したアセットのパスからSpriteSheetを作成
    all = await _create('characters/spritesheet-mod-v2.png');
  }

  // 画像からSpriteSheetを生成する処理本体
  static Future<SpriteSheet> _create(String path) async {
    // ファイルパスから画像を取得して
    final image = await Flame.images.load(path);
    // 1枚ずつ分割する (横40x縦8)
    return SpriteSheet.fromColumnsAndRows(image: image, columns: 40, rows: 8);
  }
}


class PatientSpriteSheet {
  static Future<SpriteAnimation> get idleRightSingleFrame => SpriteAnimation.load(
    "characters/alex.png",
    SpriteAnimationData.sequenced(
      amount: 1,
      stepTime: 0.4,
      textureSize: Vector2(16, 22),
      texturePosition: Vector2(32, 0),
    ),
  );

  static Future<SpriteAnimation> get runRight => SpriteAnimation.load(
    "characters/alex.png",
    SpriteAnimationData.sequenced(
      amount: 4,
      stepTime: 0.4,
      textureSize: Vector2(16, 22),
    ),
  );

  static Future<SpriteAnimation> get idleFrontSingleFrame => SpriteAnimation.load(
    "characters/alex_front.png",
    SpriteAnimationData.sequenced(
      amount: 1, // Only one frame
      stepTime: 0.4, // Time to display the frame
      textureSize: Vector2(32, 44), // Size of each frame
      texturePosition: Vector2(0, 0), // Position of the first frame in the spritesheet
    ),
  );


}

class DoctorXRaySpriteSheet {
  static Future<SpriteAnimation> get docIdle =>
      SpriteAnimation.load(
        "characters/doctor_xray_sprite.png",
        SpriteAnimationData.sequenced(
          amount: 2,
          stepTime: 0.4,
          textureSize: Vector2(32, 46),
          texturePosition: Vector2(0, 0),
        ),
      );

  static Future<SpriteAnimation> get runRight =>
      SpriteAnimation.load(
        "characters/doctor_xray.png",
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.4,
          textureSize: Vector2(0, 0),
        ),
      );

  static Future<SpriteAnimation> get docFront =>
      SpriteAnimation.load(
        "characters/doctor_xray.png",
        SpriteAnimationData.sequenced(
          amount: 1, // Only one frame
          stepTime: 0.4, // Time to display the frame
          textureSize: Vector2(32, 46), // Size of each frame
          texturePosition: Vector2(
              0, 0), // Position of the first frame in the spritesheet
        ),
      );
}

class DoctorMRTSpriteSheet {
  static Future<SpriteAnimation> get docIdle =>
      SpriteAnimation.load(
        "characters/doctor_mrt_sprite.png",
        SpriteAnimationData.sequenced(
          amount: 2,
          stepTime: 0.4,
          textureSize: Vector2(32, 46),
          texturePosition: Vector2(0, 0),
        ),
      );

  static Future<SpriteAnimation> get runRight =>
      SpriteAnimation.load(
        "characters/doctor_mrt.png",
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.4,
          textureSize: Vector2(0, 0),
        ),
      );

  static Future<SpriteAnimation> get docFront =>
      SpriteAnimation.load(
        "characters/doctor_mrt.png",
        SpriteAnimationData.sequenced(
          amount: 1, // Only one frame
          stepTime: 0.4, // Time to display the frame
          textureSize: Vector2(32, 46), // Size of each frame
          texturePosition: Vector2(
              0, 0), // Position of the first frame in the spritesheet
        ),
      );
}

class DoctorCTSpriteSheet {
  static Future<SpriteAnimation> get docIdle =>
      SpriteAnimation.load(
        "characters/doctor_ct_sprite.png",
        SpriteAnimationData.sequenced(
          amount: 2,
          stepTime: 0.4,
          textureSize: Vector2(32, 46),
          texturePosition: Vector2(0, 0),
        ),
      );

  static Future<SpriteAnimation> get runRight =>
      SpriteAnimation.load(
        "characters/doctor_ct.png",
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.4,
          textureSize: Vector2(0, 0),
        ),
      );

  static Future<SpriteAnimation> get docFront =>
      SpriteAnimation.load(
        "characters/doctor_ct.png",
        SpriteAnimationData.sequenced(
          amount: 1, // Only one frame
          stepTime: 0.4, // Time to display the frame
          textureSize: Vector2(32, 46), // Size of each frame
          texturePosition: Vector2(
              0, 0), // Position of the first frame in the spritesheet
        ),
      );
}

  // Ordinationshilfe

  class OrdiSpriteSheet {

  static Future<SpriteAnimation> get ordiFront => SpriteAnimation.load(
    "characters/ordi.png",
    SpriteAnimationData.sequenced(
      amount: 1, // Only one frame
      stepTime: 0.4, // Time to display the frame
      textureSize: Vector2(32, 46), // Size of each frame
      texturePosition: Vector2(0, 0), // Position of the first frame in the spritesheet
    ),
  );


}

// Schatztruhe
class ChestSpriteSheet {
  static Future<SpriteAnimation> get chestAnimated =>
      SpriteAnimation.load(
        "objects/chest_spritesheet.png",
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2(16, 16),
        ),
      );
}