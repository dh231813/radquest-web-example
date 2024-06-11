import 'package:RadQuest/maps/hospital_map.dart';
import 'package:RadQuest/player/player_sprite.dart';
import 'package:bonfire/bonfire.dart';
import 'package:RadQuest/player/player_serife.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:RadQuest/utilities/styles.dart';
import 'package:RadQuest/utilities/constants.dart';
import 'package:flame_audio/flame_audio.dart';

class Chest extends GameDecoration {
  bool isPlayerNearby = false;
  bool isShowingDialog = false;

  Chest(Vector2 position)
      : super.withAnimation(
    animation: ChestSpriteSheet.chestAnimated,
    size: Vector2(tileSize * 0.75, tileSize * 0.75),
    position: position,
  ) {
    HardwareKeyboard.instance.addHandler(_handleKey);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _checkPlayerProximity();
  }

  void _checkPlayerProximity() {
    final player = gameRef.player;
    if (player != null && player is PlayerSerife) {
      final distance = player.position.distanceTo(position);
      isPlayerNearby = distance < size.x + player.size.x; // Adjust distance threshold as needed
    }
  }

  bool _handleKey(KeyEvent event) {
    if (isPlayerNearby && !isShowingDialog && event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.space) {
      _triggerDialog(gameRef.context, gameRef.player as PlayerSerife);
      return true;
    }
    return false;
  }

  void _triggerDialog(BuildContext context, PlayerSerife player) {
    isShowingDialog = true;
    gameRef.pauseEngine();
    player.stopMovement();
    if (_hasAllBadges(player)) {
      _showOpenChestDialog(context, player);
    } else {
      _showChestHintDialog(context, player);
    }
  }

  bool _hasAllBadges(PlayerSerife player) {
    return player.badges.contains(kUltraSoundBadge) &&
        player.badges.contains(kContrastAgentBadge) &&
        player.badges.contains(kXrayBadge) &&
        player.badges.contains(kCTBadge) &&
        player.badges.contains(kMRTBadge) &&
        player.badges.contains(kCoilBadge) &&
        player.badges.contains(kPatientBadge);
  }

  void _showChestHintDialog(BuildContext context, PlayerSerife player) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    Image.asset(
                      'assets/images/objects/chest-large.png', // Assuming this image exists
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Du siehst hier eine geheimnisvolle Truhe. Was könnte sich wohl darin befinden? Du musst alle 7 Abzeichen im Krankenhaus sammeln, um die Truhe zu öffnen.',
                        style: dialogTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextButton(
                  child: const Text('Schließen', style: dialogTextStyle),
                  onPressed: () {
                    Navigator.of(context).pop();
                    gameRef.resumeEngine();
                    player.resumeMovement();
                    isShowingDialog = false;
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showOpenChestDialog(BuildContext context, PlayerSerife player) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    Image.asset(
                      'assets/images/objects/chest-large.png', // Assuming this image exists
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Du scheinst es geschafft zu haben, alle sieben Abzeichen zu sammeln. Möchtest du die Truhe öffnen?',
                        style: dialogTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      child: const Text('Ja', style: dialogTextStyle),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showXRayGogglesDialog(context, player);
                      },
                    ),
                    TextButton(
                      child: const Text('Nein', style: dialogTextStyle),
                      onPressed: () {
                        Navigator.of(context).pop();
                        gameRef.resumeEngine();
                        player.resumeMovement();
                        isShowingDialog = false;
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showXRayGogglesDialog(BuildContext context, PlayerSerife player) async {
    // Stop the background music and play the victory sound using Flame's audio
    FlameAudio.bgm.stop();
    FlameAudio.play('victory.mp3');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    Image.asset(
                      'assets/images/objects/xray_goggles.png', // Assuming this image exists
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Herzlichen Glückwunsch!\n\n', // Added extra newline for spacing
                              style: highlightTextStyle,
                            ),
                            TextSpan(
                              text: 'Du hast die ',
                              style: dialogTextStyle,
                            ),
                            TextSpan(
                              text: 'Legendären Röntgenbrillen',
                              style: highlightTextStyle,
                            ),
                            TextSpan(
                              text: ' gefunden. Diese High-Tech-Brillen sind ein wahres Wunderwerk der Technologie. Mit ihrer Hilfe kannst du durch Wände sehen und versteckte Objekte sowie geheime Wege entdecken, die sonst im Verborgenen bleiben würden. Möge dein Weg mit diesen legendären Röntgenbrillen noch aufregender und voller Entdeckungen sein!',
                              style: dialogTextStyle,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextButton(
                  child: const Text('Schließen', style: dialogTextStyle),
                  onPressed: () {
                    Navigator.of(context).pop();
                    gameRef.resumeEngine();
                    player.resumeMovement();
                    isShowingDialog = false;
                    // Start the background music again
                    FlameAudio.bgm.play('assets/bgm.mp3', volume: 0.25);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void onRemove() {
    HardwareKeyboard.instance.removeHandler(_handleKey);
    super.onRemove();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
