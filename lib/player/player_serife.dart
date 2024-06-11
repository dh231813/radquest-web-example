import 'package:RadQuest/maps/hospital_map.dart';
import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import'package:RadQuest/utilities/constants.dart';

class PlayerSerife extends SimplePlayer with BlockMovementCollision {
  final List<String> collectibles = [];
  final List<String> badges = [
    kUltraSoundBadge,
    kContrastAgentBadge,
    kXrayBadge,
    kCTBadge,
    kMRTBadge,
    kCoilBadge,
    kPatientBadge,
  ]; // Adding all badges initially for testing purposes
  bool movementPaused = false;

  PlayerSerife(
      Vector2 position, {
        required this.spriteSheet,
        Direction initDirection = Direction.down,
      }) : super(
    animation: SimpleDirectionAnimation(
      idleDown: spriteSheet.createAnimation(row: 0, stepTime: 0.4, from: 1, to: 3).asFuture(),
      idleLeft: spriteSheet.createAnimation(row: 1, stepTime: 0.4, from: 1, to: 3).asFuture(),
      idleRight: spriteSheet.createAnimation(row: 2, stepTime: 0.4, from: 1, to: 3).asFuture(),
      idleUp: spriteSheet.createAnimation(row: 3, stepTime: 0.4, from: 1, to: 3).asFuture(),
      runDown: spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 4, to: 8).asFuture(),
      runLeft: spriteSheet.createAnimation(row: 1, stepTime: 0.1, from: 4, to: 8).asFuture(),
      runRight: spriteSheet.createAnimation(row: 2, stepTime: 0.1, from: 4, to: 8).asFuture(),
      runUp: spriteSheet.createAnimation(row: 3, stepTime: 0.1, from: 4, to: 8).asFuture(),
    ),
    size: Vector2(16, 24) * 3,
    speed: tileSize / 0.25,
    position: position,
    initDirection: initDirection,
  );

  @override
  Future<void> onLoad() {
    add(RectangleHitbox(size: size));
    return super.onLoad();
  }

  final SpriteSheet spriteSheet;

  void stopMovement() {
    movementPaused = true;
    idle();
  }

  void resumeMovement() {
    movementPaused = false;
  }

  @override
  void update(double dt) {
    if (!movementPaused) {
      super.update(dt);
    }
  }

  void addCollectible(String item) {
    collectibles.add(item);
  }

  void removeCollectible(String item) {
    collectibles.remove(item);
  }

  bool hasCollectible(String item) {
    return collectibles.contains(item);
  }

  void addBadge(String badge) {
    badges.add(badge);
  }
}
