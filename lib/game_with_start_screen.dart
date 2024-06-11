import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:RadQuest/start_screen_overlay.dart';
import 'package:RadQuest/maps/hospital_map.dart';

class GameWithStartScreen extends StatefulWidget {
  @override
  _GameWithStartScreenState createState() => _GameWithStartScreenState();
}

class _GameWithStartScreenState extends State<GameWithStartScreen> {
  bool _isStartScreenVisible = true;

  void _startGame() {
    setState(() {
      _isStartScreenVisible = false;
    });
    playBackgroundMusic();
    // Start or resume the game here if needed
  }

  void playBackgroundMusic() {
    FlameAudio.bgm.play('bgm.mp3', volume: 0.25).then((_) {
      print("Background music playing");
    }).catchError((error) {
      print("Error playing background music: $error");
    });
  }

  @override
  void dispose() {
    print("Stopping background music");
    FlameAudio.bgm.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        HospitalMap(), // Your game map
        if (_isStartScreenVisible)
          StartScreenOverlay(
            onStartGame: _startGame,
          ),
      ],
    );
  }
}
