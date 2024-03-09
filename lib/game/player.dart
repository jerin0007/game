import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:game/game/game.dart';
import 'package:game/types.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../miner.dart';

class Player extends SpriteComponent with HasGameRef<MyGame>, CollisionCallbacks {
  int directionStrength = 0;
  String playerDirection = "center";
  bool up = false;
  @override
  FutureOr<void> onLoad() async {
    position.x = AppConfig.width / 2;
    position.y = AppConfig.height / 2;
    final playerImage = await Flame.images.load('char.png');
    sprite = Sprite(playerImage);
    size = Vector2.all(AppConfig.tileWidth * 2);

    add(RectangleHitbox(
      isSolid: true,
      size: Vector2.all(AppConfig.tileWidth * 2),
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
    position.x = AppConfig.width / 2;
    position.y = AppConfig.height / 2;
  }

  jump(String type) async {
    if (!up) {
      mine();
      // audio
      if (type == "bus") {
        FlameAudio.play("bus.wav", volume: 0.8);
        AppConfig.score += 100;
        stat.updateScore(AppConfig.score.toString(), color: Colors.green);
      } else if (type == "plane") {
        if ((AppConfig.score - 100) > 0) {
          AppConfig.score -= 100;
        }else{
          AppConfig.score = 0;
        }
        FlameAudio.play("plane.wav");
        stat.updateScore(AppConfig.score.toString(), color: Colors.red);
      } else {
        FlameAudio.play("jump.wav", volume: 0.6);
        AppConfig.score += 20;
        stat.updateScore(AppConfig.score.toString());
      }

      up = true;
      add(MoveByEffect(
          Vector2(0, ((AppConfig.height / 2.5) - position.y) + 50), EffectController(duration: 0.8, curve: Curves.easeIn),
          onComplete: () {
        // await Future.delayed(const Duration(milliseconds: 300));
      }));

      bg.jump(8 * 120);
      await map.jump(8);
      up = false;
    }
  }

  @override
  void update(double dt) {
    if (AppConfig.height < position.y) {
      if (!AppConfig.gameOver) {
        stat.gameOver("fell");
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
        position.x = AppConfig.width;
      } else if (position.x > AppConfig.width) {
        position.x = 0;
      }
    }

    // TODO: implement update
    super.update(dt);
  }
}
