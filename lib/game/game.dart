import 'dart:async';

import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'background.dart';
import 'map.dart';
import 'player.dart';
import '../types.dart';
import 'state.dart';

late Player player;
late GameMap map;
late GameStat stat;
late Background bg;

class MyGame extends FlameGame with TapDetector, HasCollisionDetection, KeyboardEvents {
  bool completed = true;

  @override
  Color backgroundColor() => Color(0xFF48a4d3);

  @override
  FutureOr<void> onLoad() async {
    await addAll([bg = Background(), map = GameMap(), player = Player(), stat = GameStat()]);
    stat.updateScore(AppConfig.score.toString());
    return super.onLoad();
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDown = event is KeyDownEvent;

    // final isSpace = keysPressed.contains(LogicalKeyboardKey.space);

    if (completed) {
      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        completed = false;
        Future.delayed(const Duration(milliseconds: 200)).then((value) {
          completed = true;
        });
        player
            .add(MoveByEffect(Vector2(-80.0, 0), EffectController(duration: 0.4, curve: Curves.linear), onComplete: () {
          // completed = true;
        }));
        return KeyEventResult.handled;
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        completed = false;
        Future.delayed(const Duration(milliseconds: 200)).then((value) {
          completed = true;
        });
        player.add(
            MoveByEffect(Vector2(80.0, 0), EffectController(duration: 0.4, curve: Curves.linear), onComplete: () {}));
        return KeyEventResult.handled;
      }
    } else {
      print("false");
    }
    if (isKeyDown && keysPressed.contains(LogicalKeyboardKey.space)) {
      if (AppConfig.gameOver) {
        stat.restart();
      }
    }
    // }
    return KeyEventResult.ignored;
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
