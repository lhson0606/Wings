import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:wings/configs/game_maps.dart';
import 'package:wings/game/components/game_progress_point.dart';
import 'package:wings/game/components/player.dart';
import 'package:wings/game/plane_shooter_game.dart';

class GameWorld extends World with HasGameReference<PlaneShooterGame>{
  late final Player player;
  late final GameProgressPoint gameProgressPoint;
  late final tiledMap;
  double elapsedTime = 0.0;

  @override
  Future<void> onLoad() async {
    elapsedTime = 0.0;

    tiledMap = await TiledComponent.load(
      GameMaps.default_map,
      Vector2.all(16),
    );

    tiledMap.anchor = Anchor.bottomCenter;
    // resize map to fit map width with our viewport width
    final scaleFactor = game.canvasSize.x / tiledMap.size.x;
    tiledMap.scale = Vector2.all(scaleFactor);
    tiledMap.position = Vector2(0, game.canvasSize.y/2);

    await add(tiledMap);

    gameProgressPoint = GameProgressPoint();
    gameProgressPoint.anchor = Anchor.center;
    gameProgressPoint.position = Vector2(0, 0);

    player = Player();
    player.setJoystick(game.joystick);
    player.plane.position = Vector2(gameProgressPoint.position.x, gameProgressPoint.position.y + 100);
    player.setProgressVelocity(gameProgressPoint.progressVelocity);

    // Add to this world (not to `game`) so camera can follow properly
    await add(gameProgressPoint);
    await add(player);

    game.camera.follow(gameProgressPoint);

    game.soundManager.playBackgroundMusic();
  }

  @override
  void update(double dt) {
    // move the tiled map up to create scrolling effect
    tiledMap.position += gameProgressPoint.progressVelocity * dt *0.95;
    elapsedTime += dt;
  }
}
