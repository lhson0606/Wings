import 'dart:math';

import 'package:flame/camera.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:wings/game/components/input/joystick.dart';
import 'package:wings/game/pages/gameplay_page.dart';
import 'package:wings/game/pages/home_page.dart';
import 'package:wings/managers/enemy_manager.dart';
import 'package:wings/managers/enemy_pool_manager.dart';
import 'package:wings/managers/projectile_pool_manager.dart';
import 'package:wings/routes/app_routes.dart';

class PlaneShooterGame extends FlameGame with HasCollisionDetection {
  static final double width = 360;
  static final double height = 640;
  late final RouterComponent router;
  late final Joystick joystick;

  final ProjectilePoolManager projectilePoolManager = ProjectilePoolManager();
  final EnemyPoolManger enemyPoolManager = EnemyPoolManger();

  final EnemyManager enemyManager = EnemyManager();

  PlaneShooterGame() : super(
    world: World(),
    camera: CameraComponent.withFixedResolution(width: width, height: height)
  ) {
    camera.viewfinder.anchor = Anchor.center;
  }

  final Random random = Random();

  @override
  Future<void> onLoad() async {
    await addManagers();
    
    add(
        router = RouterComponent(
          initialRoute: AppRoutes.home,
          routes: {
            AppRoutes.home: Route(HomePage.new),
            AppRoutes.gameplay: Route(() => GameplayPage(
              resolution: canvasSize,
            )),
          },
        )
    );

    joystick = Joystick();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    camera.viewport = FixedResolutionViewport(resolution: size);
  }

  Future<void> addManagers() async {
    await add(projectilePoolManager);
    await add(enemyPoolManager);
    await add(enemyManager);
  }
}