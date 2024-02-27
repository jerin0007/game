import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/widgets.dart';
import 'package:game/game.dart';

import 'types.dart';
import 'package:flame/components.dart';
import 'package:mutex/mutex.dart';

class Background extends SpriteComponent with HasGameRef<MyGame> {
  @override
  FutureOr<void> onLoad() async {
    final image = await Flame.images.load('green.jpg');
    sprite = Sprite(image);

    // TODO: implement onLoad
    return super.onLoad();
  }
}

class Tile extends SpriteComponent with HasGameRef<MyGame>, CollisionCallbacks {
  Tile({required this.type, required this.x, required this.y});

  @override
  final String type;
  final double x;
  final double y;

  Map spriteSize = {
    "can": {"width": Window.tileWidth * 2, "height": Window.tileWidth * 3.5},
    "glass": {"width": Window.tileWidth * 2, "height": Window.tileWidth * 3.5},
    "bag": {"width": Window.tileWidth * 2, "height": Window.tileWidth * 3},
    "plastic_bag": {"width": Window.tileWidth * 2, "height": Window.tileWidth * 3},
    "bus": {"width": Window.tileWidth * 4, "height": Window.tileWidth * 2.5},
    "plane": {"width": Window.tileWidth * 4, "height": Window.tileWidth * 2.5},
    "switch": {"width": Window.tileWidth * 1.5, "height": Window.tileWidth * 2.5},
  };

  @override
  FutureOr<void> onLoad() async {
    final playerImage = await Flame.images.load('${type}.png');
    sprite = Sprite(playerImage);
    size = Vector2(spriteSize[type]["width"], spriteSize[type]["height"]);

    position.y = y;
    if (type == "switch") {
      position.x = 0;
    } else {
      position.x = x;
    }

    add(RectangleHitbox(isSolid: true, size: size));
    // TODO: implement onLoad
    return super.onLoad();
  }

  String direction = "left";
  @override
  void update(double dt) {
    if (type == "bus" || type == "plane") {
      if (direction == "left") {
        if (position.x > 0) {
          position.x -= 2;
        } else {
          direction = "right";
          flipHorizontally();
        }
      } else if (direction == "right") {
        if (position.x < Window.width - (Window.tileWidth * 2)) {
          position.x += 2;
        } else {
          direction = "left";
          flipHorizontally();
        }
      }
    }
    // TODO: implement update
    super.update(dt);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (type == "plastic_bag" || type == "glass") {
      if (!player.up) {
        stat.gameOver();
      }
    } else {
      if (!Window.gameOver) {
        player.jump();
      }
    }

    // TODO: implement onCollisionStart
    super.onCollisionStart(intersectionPoints, other);
  }
}

class GameMap extends PositionComponent with HasGameRef<MyGame> {
  double dist = 0;
  int count = 0;
  double gap = 120;
  int maxTiles = 0;
  TextComponent? overText;
  final locker = Mutex();
  lock() async {
    await locker.acquire();
  }

  release() {
    if (locker.isLocked) {
      locker.release();
    }
  }

  List<Tile> pastTiles = [];

  @override
  FutureOr<void> onLoad() {
    maxTiles = (Window.height / gap).toInt() + 1;
    print(maxTiles);
    for (var i = 0; i < maxTiles; i++) {
      pastTiles.add(Tile(type: getTileType((i == maxTiles - 1)), x: getX(), y: (i * gap)));
      add(pastTiles.last);
    }
    return super.onLoad();
  }

  reset() {
    position.y = 0;
    count = 0;
    for (var tile in pastTiles) {
      remove(tile);
    }
    pastTiles.clear();

    for (var i = 0; i < maxTiles; i++) {
      pastTiles.add(Tile(type: getTileType((i == maxTiles - 1)), x: getX(), y: (i * gap)));
      add(pastTiles.last);
    }
  }

  jump(int max) async {
    for (var i = 0; i < maxTiles; i++) {
      count += 1;

      // print("removing");
      pastTiles.first.removeFromParent();
      pastTiles.removeAt(0);

      pastTiles.add(Tile(type: getTileType((i == 0)), x: getX(), y: count * gap * -1));
      add(pastTiles.last);

      await add(
          MoveByEffect(Vector2(0, gap), EffectController(duration: 0.3, curve: Curves.linear), onComplete: () async {
        await release();
      }));

      await lock();
    }
  }

  @override
  void update(double dt) {
    // position.y += dt + 2;
    super.update(dt);
  }
}

int last = 0;

List<Map> allTiles = [
  {"type": "can", "probability": 18},
  {"type": "glass", "probability": 15},
  {"type": "bag", "probability": 18},
  {"type": "plastic_bag", "probability": 15},
  {"type": "bus", "probability": 15},
  {"type": "plane", "probability": 15},
  {"type": "switch", "probability": 4},
];
List<Map> safeTiles = [
  {"type": "can"},
  {"type": "bag"},
  {"type": "bus"},
];

getTileType(bool safe) {
  var _rand = Random();
  String type = "switch";

  if (safe) {
    type = safeTiles[_rand.nextInt(2)]["type"];
    print("safeee " + type);
    return type;
  }
  int cn = _rand.nextInt(100), ul = 0, ll = 0;

  for (var tile in allTiles) {
    ul = ul + int.parse(tile["probability"].toString());
    if (cn > ll && cn < ul) {
      type = tile["type"];
    }
    ll = ul;
  }

  return type;
}

_getX(int min, int max) {
  int n = random(min, max);
  // if (maps.isNotEmpty) {
  if (n == last) {
    if (n == 0) {
      n = n + 2;
    } else {
      n = n - 2;
    }
  }
  return n;
}

double getX() {
  int p = random(0, 10);
  int p2 = random(0, 20);
  int n = 0;
  if (p == 4) {
    // left 1 - 6
    n = _getX(1, 6);
    // maps.add(random(0, 6));
  } else if (p == 5) {
    // right 18 - 24
    n = _getX(18, 22);
    // maps.add(random(18, 22));
  } else {
    // 6 - 18
    n = _getX(6, 18);
    // maps.add(random(6, 18));
  }
  if (p2 == 18) {
    print("swiiitch");
    n = 0;
  }

  return n * Window.tileWidth;
}
