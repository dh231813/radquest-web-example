
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:bonfire/bonfire.dart';
import 'package:RadQuest/maps/halloween_map_01.dart';
import 'package:RadQuest/player/player_sprite.dart';
import 'package:RadQuest/interface/player_interface.dart';



void main() async {
  // iOSでは横画面にする
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Flame.device.setLandscape();
    await Flame.device.fullScreen();
  }
  //runApp(const MyApp());


  // アセットからSpriteSheetを生成
  await PlayerSpriteSheet.load(); // ←追加


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'RadQuest',
      debugShowCheckedModeBanner: false,
      home: HalloweenMap01(),

    );

  }

}

