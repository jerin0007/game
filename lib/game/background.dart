import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';
import 'game.dart';
import '../types.dart';

class Background extends PositionComponent with HasGameRef<MyGame> {
  double len = 0;
  double traveled = 0;
  String lastBaseDirection = "left";
  // int max = 0;

  @override
  FutureOr<void> onLoad() async {
    double width = AppConfig.width;
    double height = width * 1.05;
    double x = -50;
    double y = (AppConfig.height - (height * 1.5));
    add(BackgroundTile(name: "mt_2.png", siz: Vector2(width, height), pos: Vector2(x, y)));

    width = AppConfig.width;
    height = width * 1.05;
    x = -(width / 3);
    y = (AppConfig.height - (height * 1.4));
    add(BackgroundTile(name: "mt_1.png", siz: Vector2(width, height), pos: Vector2(x, y)));

    width = AppConfig.width;
    height = width * 1.05;
    x = (width / 3);
    y = (AppConfig.height - (height * 1.4));
    add(BackgroundTile(name: "mt_1.png", siz: Vector2(width, height), pos: Vector2(x, y)));

    width = AppConfig.width;
    height = width * 1.05;
    y = (AppConfig.height - (height * 1.4));
    height = (AppConfig.height - (y + height)) * 1.1;
    y = AppConfig.height - height;
    x = 0;

    add(RectangleComponent(
        paint: Paint()..color = Color(0XFF0e242b), size: Vector2(width, height), position: Vector2(x, y)));

    width = AppConfig.width - 40;
    height = width * 1.3;
    x = 0;
    y = (AppConfig.height - height);
    add(BackgroundTile(name: "green_base.png", siz: Vector2(width, height), pos: Vector2(x, y)));

    return super.onLoad();
  }

  jump(double gap) async {
    gap = gap / 6;
    traveled = traveled - gap;

    if (traveled < (len + 100)) {
      if (random(1, 4) != 1) {
        print("hearr");

        int id = random(1, 4);

        len = len - (AppConfig.width / 2);

        double width = AppConfig.tileWidth * 4.5;
        double height = 50;
        if (id == 1) {
          width = height * 1.8;
        } else if (id == 2) {
          width = height * 2.2;
        } else if (id == 3) {
          width = height * 1.7;
        }

        int max = (AppConfig.width / width).toInt();
        double x = width * random(0, max);
        double y = len;

        await add(BackgroundTile(name: "cloud$id.png", siz: Vector2(width, height), pos: Vector2(x, y)));
      } else {
        len = len - (AppConfig.width / 2);

        int id = random(1, 3);

        double width = AppConfig.tileWidth * 6;
        double height = width * 1.7;
        if (id == 1) {
          height = width * 1.7;
        } else {
          height = width * 1.3;
        }

        double x = 20;

        if (lastBaseDirection == "left") {
          print("hoooiiii");
          x = (AppConfig.width - width) - 20;
          lastBaseDirection = "right";
        } else {
          x = 20;
          lastBaseDirection = "left";
        }

        double y = len;

        await add(BackgroundTile(name: "mini_base_$id.png", siz: Vector2(width, height), pos: Vector2(x, y)));
      }
    }

    add(MoveByEffect(Vector2(0, gap), EffectController(duration: 2, curve: Curves.easeIn), onComplete: () {}));
  }

  reset() {
    position.y = 0;
  }
}

class BackgroundTile extends SpriteComponent with HasGameRef<MyGame> {
  BackgroundTile({required this.name, required this.pos, required this.siz});
  final String name;
  final Vector2 pos;
  final Vector2 siz;

  @override
  FutureOr<void> onLoad() async {
    final image = await Flame.images.load(name);
    sprite = Sprite(image);
    size = siz;
    position = pos;
    // if (name.contains("sky")) {
    //   size = Vector2(AppConfig.width, AppConfig.width);
    // } else {
    //   size = Vector2(AppConfig.width - 40, (AppConfig.width - 40) * 1.3);
    // }
    position.y = y;
    return super.onLoad();
  }
}
