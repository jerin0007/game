import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'game.dart';
import '../types.dart';

class Background extends PositionComponent with HasGameRef<MyGame> {
  double len = 0;
  double traveled = 0;

  @override
  FutureOr<void> onLoad() async {
    add(BackgroundTile(name: "green.jpg", y: 0));

    return super.onLoad();
  }

  jump(double gap) async {
    gap = gap / 6;
    traveled = traveled - gap;

    if (traveled < len) {
      len = len - (AppConfig.width * 1.5);
      await add(BackgroundTile(name: "green_sky_${random(1, 2)}.jpg", y: len));
    }

    add(MoveByEffect(Vector2(0, gap), EffectController(duration: 2, curve: Curves.easeIn), onComplete: () {}));
  }

  reset() {
    position.y = 0;
  }
}

class BackgroundTile extends SpriteComponent with HasGameRef<MyGame> {
  BackgroundTile({required this.name, required this.y});
  final String name;
  final double y;

  @override
  FutureOr<void> onLoad() async {
    final image = await Flame.images.load(name);
    sprite = Sprite(image);
    if (name.contains("sky")) {
      size = Vector2(AppConfig.width, AppConfig.height);
      size = Vector2(AppConfig.width, AppConfig.width * 1.5);
    }
    position.y = y;
    return super.onLoad();
  }
}
