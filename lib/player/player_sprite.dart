import 'package:bonfire/bonfire.dart';

class PlayerSpriteSheet {
  static late SpriteSheet all;

  // ゲーム起動時に実行するメソッド
  static Future<void> load() async {
    // 追加したアセットのパスからSpriteSheetを作成
    all = await _create('characters/spritesheet.png');
  }

  // 画像からSpriteSheetを生成する処理本体
  static Future<SpriteSheet> _create(String path) async {
    // ファイルパスから画像を取得して
    final image = await Flame.images.load(path);
    // 1枚ずつ分割する (横40x縦8)
    return SpriteSheet.fromColumnsAndRows(image: image, columns: 40, rows: 8);
  }
}

