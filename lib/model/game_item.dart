// アイテムクラス
abstract class GameItem {
  GameItem({required this.imagePath, required this.jpName, required this.price});
  String imagePath;
  String jpName; // 日本語名
  int price; // 値段
}

// アイテムクラスを継承したキノコ
class ContrastAgent extends GameItem {
  ContrastAgent()
      : super(
          imagePath: 'objects/Aqua.png',
          jpName: 'Kontrastmittel',
          price: 180,
        );
}

