import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'background.dart';
import 'map.dart';
import 'player.dart';
import '../types.dart';
import 'state.dart';

late Player player;
late GameMap map;
late GameStat stat;
late Background bg;


class MyGame extends FlameGame with TapDetector, HasCollisionDetection {
  @override
  FutureOr<void> onLoad() async {
    await addAll([bg = Background(), map = GameMap(), player = Player(), stat = GameStat()]);
    stat.updateScore(AppConfig.score.toString());
    return super.onLoad();
  }

  @override
  void onDispose() {
    // TODO: implement onDispose
    super.onDispose();
  }

  @override
  void onTap() {
    if (AppConfig.gameOver) {
      stat.restart();
    }
    // TODO: implement onTap
    super.onTap();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
