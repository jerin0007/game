import 'dart:math';

class Window {
  static double mapSpeed = 2;
  static double con = 1;
  static double width = 0;
  static double tileWidth = 0;
  static double height = 0;
  static String playerDirection = "center";
  static bool gameOver = false;
}


int random(int min, int max) {
  var _rand = Random();
  return min + _rand.nextInt(max - min);
}