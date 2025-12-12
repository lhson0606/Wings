import 'dart:ui';

import 'package:flame/components.dart';
import 'package:wings/game/components/player.dart';
import 'package:wings/game/plane_shooter_game.dart';
import 'package:flutter/rendering.dart';

class GameWorld extends World with HasGameReference<PlaneShooterGame>{
  late final Player player;

  @override
  Future<void> onLoad() async {
    // Add player
    player = Player();
    player.setJoystick(game.joystick);
    add(TextComponent(
      text: 'Test!!!',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 64,
          color: Color(0xFFC8FFF5),
          fontWeight: FontWeight.w800,
        ),
      ),
    ));
    await game.add(player);
    player.position = game.canvasSize/2;

    game.camera.follow(player);
  }
}
