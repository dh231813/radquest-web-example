import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:RadQuest/player/player_serife.dart';
import 'package:RadQuest/utilities/constants.dart';

class PlayerInterface extends GameInterface {
  late Sprite gadoliniumCollectible;
  late Sprite bariumCollectible;
  late Sprite primovistCollectible;
  late Sprite jodCollectible;

  late Sprite headcoilCollectible;
  late Sprite footcoilCollectible;
  late Sprite handcoilCollectible;
  late Sprite kneecoilCollectible;

  late Sprite contrastagentBadge;
  late Sprite coilBadge;

  late Sprite patientBadge;
  late Sprite ultrasoundBadge;
  late Sprite xrayBadge;
  late Sprite ctBadge;
  late Sprite mrtBadge;

  @override
  Future<void> onLoad() async {
    gadoliniumCollectible = await Sprite.load('objects/Gadolinium.png');
    bariumCollectible = await Sprite.load('objects/Barium.png');
    primovistCollectible = await Sprite.load('objects/Primovist.png');
    jodCollectible = await Sprite.load('objects/Jod.png');

    headcoilCollectible = await Sprite.load('objects/CoilHead.png');
    handcoilCollectible = await Sprite.load('objects/CoilHand.png');
    footcoilCollectible = await Sprite.load('objects/CoilFoot.png');
    kneecoilCollectible = await Sprite.load('objects/CoilKnee.png');

    contrastagentBadge = await Sprite.load('objects/BadgeContrastAgent.png');
    coilBadge = await Sprite.load('objects/BadgeCoil.png');

    patientBadge = await Sprite.load('objects/BadgePatient.png');
    ultrasoundBadge = await Sprite.load('objects/BadgeUltrasound.png');
    xrayBadge = await Sprite.load('objects/BadgeXRay.png');
    ctBadge = await Sprite.load('objects/BadgeCT.png');
    mrtBadge = await Sprite.load('objects/BadgeMRT.png');

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    try {
      // Draw background for collectibles and badges area
      _drawBackground(canvas);

      // Draw labels
      _drawLabels(canvas);

      // Draw collectibles
      _drawCollectibles(canvas);

      // Draw badges
      _drawBadges(canvas);
    } catch (e) {}
    super.render(canvas);
  }

  void _drawBackground(Canvas canvas) {
    final Paint paint = Paint()..color = Colors.black.withOpacity(0.5);
    final Rect rect = Rect.fromLTWH(0, 0, gameRef.size.x, 80);
    canvas.drawRect(rect, paint);
  }

  void _drawLabels(Canvas canvas) {
    final TextPainter itemsLabel = TextPainter(
      text: const TextSpan(
        text: 'Items:',
        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontFamily: 'VT323', // Pixel style font
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    itemsLabel.layout();
    itemsLabel.paint(canvas, const Offset(20, 5));

    final TextPainter badgesLabel = TextPainter(
      text: const TextSpan(
        text: 'Abzeichen:',
        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontFamily: 'VT323', // Pixel style font
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    badgesLabel.layout();
    badgesLabel.paint(canvas, Offset(gameRef.size.x - badgesLabel.width - 20, 5));
  }

  void _drawCollectibles(Canvas canvas) {
    final player = gameRef.player as PlayerSerife;
    double xPosition = 100;
    const double yPosition = 25;
    const double itemHeight = 35;
    const double itemSpacing = 10; // Base spacing between items

    double drawItem(Sprite sprite, double xPos) {
      final double aspectRatio = sprite.srcSize.x / sprite.srcSize.y;
      final double itemWidth = itemHeight * aspectRatio;
      sprite.renderRect(canvas, Rect.fromLTWH(xPos, yPosition, itemWidth, itemHeight));
      return itemWidth;
    }

    if (player.collectibles.contains(kGadoliniumCollectible)) {
      xPosition += drawItem(gadoliniumCollectible, xPosition) + itemSpacing;
    }
    if (player.collectibles.contains(kBariumCollectible)) {
      xPosition += drawItem(bariumCollectible, xPosition) + itemSpacing;
    }
    if (player.collectibles.contains(kJodCollectible)) {
      xPosition += drawItem(jodCollectible, xPosition) + itemSpacing;
    }
    if (player.collectibles.contains(kPrimovistCollectible)) {
      xPosition += drawItem(primovistCollectible, xPosition) + itemSpacing;
    }

    if (player.collectibles.contains(kHeadCoilCollectible)) {
      xPosition += drawItem(headcoilCollectible, xPosition) + itemSpacing;
    }
    if (player.collectibles.contains(kKneeCoilCollectible)) {
      xPosition += drawItem(kneecoilCollectible, xPosition) + itemSpacing;
    }
    if (player.collectibles.contains(kFootCoilCollectible)) {
      xPosition += drawItem(footcoilCollectible, xPosition) + itemSpacing;
    }
    if (player.collectibles.contains(kHandCoilCollectible)) {
      xPosition += drawItem(handcoilCollectible, xPosition) + itemSpacing;
    }
  }

  void _drawBadges(Canvas canvas) {
    final player = gameRef.player as PlayerSerife;
    double xPosition = gameRef.size.x - 60; // Start from the right side
    const double yPosition = 25;
    const double itemWidth = 50;
    const double itemHeight = 50;
    const double itemSpacing = 60;

    void drawBadge(Sprite sprite, double xPos) {
      sprite.renderRect(canvas, Rect.fromLTWH(xPos, yPosition, itemWidth, itemHeight));
    }

    if (player.badges.contains(kPatientBadge)) {
      drawBadge(patientBadge, xPosition);
      xPosition -= itemSpacing;
    }
    if (player.badges.contains(kUltraSoundBadge)) {
      drawBadge(ultrasoundBadge, xPosition);
      xPosition -= itemSpacing;
    }
    if (player.badges.contains(kContrastAgentBadge)) {
      drawBadge(contrastagentBadge, xPosition);
      xPosition -= itemSpacing;
    }
    if (player.badges.contains(kXrayBadge)) {
      drawBadge(xrayBadge, xPosition);
      xPosition -= itemSpacing;
    }
    if (player.badges.contains(kCTBadge)) {
      drawBadge(ctBadge, xPosition);
      xPosition -= itemSpacing;
    }
    if (player.badges.contains(kMRTBadge)) {
      drawBadge(mrtBadge, xPosition);
      xPosition -= itemSpacing;
    }
    if (player.badges.contains(kCoilBadge)) {
      drawBadge(coilBadge, xPosition);
    }
  }
}
