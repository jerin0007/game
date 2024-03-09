import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'game.dart';
import '../types.dart';
import 'package:flame/components.dart';

class GameStat extends TextBoxComponent with HasGameRef<MyGame> {
  TextComponent? overText;
  TextComponent? overReason;
  TextComponent? scoreText;

  updateScore(String score, {Color? color}) async {
    if (scoreText != null) {
      remove(scoreText!);
    }
    add(scoreText = TextComponent(
        text: score,
        textRenderer: TextPaint(
          style: GoogleFonts.pressStart2p(fontSize: 20, color: color ?? Colors.black),
        ))
      ..anchor = Anchor.topCenter
      ..x = AppConfig.width - (10 + (10 * score.length))
      ..y = 20);

    if (color != null) {
      await Future.delayed(const Duration(milliseconds: 500));
      remove(scoreText!);
      add(scoreText = TextComponent(
          text: score,
          textRenderer: TextPaint(
            style: GoogleFonts.pressStart2p(fontSize: 20, color: Colors.black),
          ))
        ..anchor = Anchor.topCenter
        ..x = AppConfig.width - (10 + (10 * score.length))
        ..y = 20);
    }
  }

  gameOver(String type) {
    if (overText == null) {
      add(overText = TextComponent(
          text: 'Game Over',
          textRenderer: TextPaint(
            style: GoogleFonts.pressStart2p(fontSize: 30, color: Colors.black),
          ))
        ..anchor = Anchor.topCenter
        ..x = AppConfig.width / 2 // size is a property from game
        ..y = (AppConfig.height / 2) - 50);

      add(overReason = TextComponent(
          text: (type == "fell") ? 'fell on void' : "used plastic",
          textRenderer: TextPaint(
            style: GoogleFonts.pressStart2p(fontSize: 18, color: Colors.black),
          ))
        ..anchor = Anchor.topCenter
        ..x = AppConfig.width / 2 // size is a property from game
        ..y = (AppConfig.height / 2) + 15);
      AppConfig.gameOver = true;
    }
  }

  restart() {
    if (overText != null) {
      remove(overText!);
      remove(overReason!);
      overText = null;
      overReason = null;
    }
    AppConfig.score = 0;
    updateScore(AppConfig.score.toString());
    player.reset();
    map.reset();
    bg.reset();
    AppConfig.gameOver = false;
  }

}

