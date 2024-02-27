import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:game/game.dart';
import 'package:game/types.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Player extends SpriteComponent with HasGameRef<MyGame>, CollisionCallbacks {
  int directionStrength = 0;
  String playerDirection = "center";
  bool up = false;
  @override
  FutureOr<void> onLoad() async {
    position.x = Window.width / 2;
    position.y = Window.height / 2;
    final playerImage = await Flame.images.load('char.png');
    sprite = Sprite(playerImage);
    size = Vector2.all(Window.tileWidth * 2);

    add(RectangleHitbox(
      isSolid: true,
      size: Vector2.all(Window.tileWidth * 2),
    ));

    accelerometerEventStream().listen(
      (AccelerometerEvent event) {
        if (event.x < 1.5 && event.x > -1.5) {
          directionStrength = 0;
          playerDirection = "center";
        } else if (event.x < 0) {
          directionStrength = event.x.abs().round();
          playerDirection = "right";
        } else {
          directionStrength = event.x.abs().round();
          playerDirection = "left";
        }
      },
      onError: (error) {},
      cancelOnError: true,
    );
    return super.onLoad();
  }

  reset() {
    position.x = Window.width / 2;
    position.y = Window.height / 2;
  }

  jump() async {
    if (!up) {
      up = true;
      add(MoveByEffect(
          Vector2(0, ((Window.height / 2.5) - position.y) + 50), EffectController(duration: 0.8, curve: Curves.easeIn),
          onComplete: () {
        // await Future.delayed(const Duration(milliseconds: 300));
      }));

      await map.jump(8);
      up = false;
    }
  }

  @override
  void update(double dt) {
    if (Window.height < position.y) {
      if (!Window.gameOver) {
        print("gameOver");
        stat.gameOver();
      }
    } else {
      if (!up) {
        position.y += (dt * 240);
      }
      if (playerDirection == "left") {
        position.x -= directionStrength * 1.2;
      } else if (playerDirection == "right") {
        position.x += directionStrength * 1.2;
      }
      if (position.x < 0) {
        position.x = Window.width;
        print("left bound");
      } else if (position.x > Window.width) {
        position.x = 0;
      }
    }

    // TODO: implement update
    super.update(dt);
  }
}
