import 'package:RadQuest/game_with_start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:bonfire/bonfire.dart';
import 'package:RadQuest/maps/hospital_map.dart';
import 'package:RadQuest/player/player_sprite.dart';
import 'package:flame/flame.dart'; // Added for device settings
import 'package:flame_audio/flame_audio.dart'; // Added for FlameAudio


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Flame.device.setLandscape();
    await Flame.device.fullScreen();
  }

  await PlayerSpriteSheet.load();

  FlameAudio.bgm.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RadQuest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText1: TextStyle(fontFamily: 'VT323', fontSize: 28),
          bodyText2: TextStyle(fontFamily: 'VT323', fontSize: 28),
          button: TextStyle(fontFamily: 'VT323', fontSize: 28),
          caption: TextStyle(fontFamily: 'VT323', fontSize: 28),
          headline1: TextStyle(fontFamily: 'VT323', fontSize: 28),
          headline2: TextStyle(fontFamily: 'VT323', fontSize: 28),
          headline3: TextStyle(fontFamily: 'VT323', fontSize: 28),
          headline4: TextStyle(fontFamily: 'VT323', fontSize: 28),
          headline5: TextStyle(fontFamily: 'VT323', fontSize: 28),
          headline6: TextStyle(fontFamily: 'VT323', fontSize: 28),
          overline: TextStyle(fontFamily: 'VT323', fontSize: 28),
          subtitle1: TextStyle(fontFamily: 'VT323', fontSize: 28),
          subtitle2: TextStyle(fontFamily: 'VT323', fontSize: 28),
        ),
      ),
      home: Scaffold(
        body: GameWithStartScreen(),
      ),
    );
  }
}

