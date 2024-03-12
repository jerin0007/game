import 'dart:async';
import 'dart:math';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

String userId = "***";

StreamController<LogicalKeyboardKey> keyboard = StreamController<LogicalKeyboardKey>();
StreamSink keyboardSink = keyboard.sink;
Stream keyboardStream = keyboard.stream;

class AppConfig {
  static double width = 0;
  static double tileWidth = 0;
  static double height = 0;
  static bool gameOver = false;
  static int score = 0;
  static BuildContext? mainContext;
  static String issuerId = "***";
  static String issuerEmail = "***";
}

class Window {}

int random(int min, int max) {
  var _rand = Random();
  return min + _rand.nextInt(max - min);
}

showSnackBar(BuildContext context, String message) {
  final snack = SnackBar(
    content: Text(message),
    backgroundColor: Colors.green,
    elevation: 10,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.all(5),
  );
  ScaffoldMessenger.of(context).showSnackBar(snack);
}
