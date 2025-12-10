import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:wings/game/game_world.dart';

void main() {
  runApp(
    GameWidget(
      game: FlameGame(world: GameWorld()),
    ),
  );
}