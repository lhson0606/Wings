import 'package:flame/components.dart';
import 'package:wings/game/components/game_progress_point.dart';
import 'package:wings/game/components/player.dart';
import 'package:wings/game/plane_shooter_game.dart';

class GameWorld extends World with HasGameReference<PlaneShooterGame>{
  late final Player player;
  late final GameProgressPoint gameProgressPoint;

  @override
  Future<void> onLoad() async {
    gameProgressPoint = GameProgressPoint();
    gameProgressPoint.anchor = Anchor.center;
    gameProgressPoint.position = Vector2(100, 0);

    player = Player();
    player.setJoystick(game.joystick);
    player.position = Vector2(gameProgressPoint.position.x, gameProgressPoint.position.y + 100);
    player.setProgressVelocity(gameProgressPoint.progressVelocity);

    // Add to this world (not to `game`) so camera can follow properly
    await add(gameProgressPoint);
    await add(player);

    game.camera.follow(gameProgressPoint);
  }
}
