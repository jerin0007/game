import 'game.dart';
import 'types.dart';
import 'package:flame/components.dart';
import 'player.dart';
import 'map.dart';

class GameStat extends TextBoxComponent with HasGameRef<MyGame> {
  TextComponent? overText;

  gameOver() {
    if (overText == null) {
      add(overText = TextComponent(text: 'Game Over')
        ..anchor = Anchor.topCenter
        ..x = Window.width / 2 // size is a property from game
        ..y = (Window.height / 2) - 50);
      Window.gameOver = true;
    }
  }

  restart() {
    print("restart");
    if (overText != null) {
      remove(overText!);
      overText = null;
    }
    player.reset();
    map.reset();
    Window.gameOver = false;
  }
}
