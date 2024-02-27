import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'map.dart';
import 'player.dart';
import 'types.dart';
import 'state.dart';

late Player player;
late GameMap map;
late GameStat stat;

class MyGame extends FlameGame with TapDetector, HasCollisionDetection {
  @override
  FutureOr<void> onLoad() async {
    // await add(Background());
    // addAll([Background(), map = GameMap(), stat = GameStat(), player = Player()]);
    addAll([Background(), map = GameMap(), stat = GameStat(), player = Player()]);

    return super.onLoad();
  }

  @override
  void onTap() {
    if (Window.gameOver) {
      stat.restart();
    }
    // player.jump();
    // TODO: implement onTap
    super.onTap();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
