import 'package:flame/camera.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:wings/game/components/input/joystick.dart';
import 'package:wings/game/game_world.dart';
import 'package:wings/game/pages/home_page.dart';
import 'package:wings/routes/app_routes.dart';

class PlaneShooterGame extends FlameGame with TapCallbacks{
  static final double width = 360;
  static final double height = 640;
  late final RouterComponent router;
  late final Joystick joystick;
  late final GameWorld gameWorld;

  PlaneShooterGame({required super.world}) {
    camera.viewport = FixedResolutionViewport(resolution: Vector2(width, height));
  }

  @override
  void onLoad() {
    gameWorld = GameWorld();
    world = gameWorld;

    add(
        router = RouterComponent(
          initialRoute: AppRoutes.home,
          routes: {
            AppRoutes.home: Route(HomePage.new),
          },
        )
    );

    joystick = Joystick();
    joystick.isVisible = false;
    add(joystick);

    gameWorld.player.setJoystick(joystick);
  }

  @override
  void onTapDown(TapDownEvent event) {
    joystick.position = event.localPosition;
    joystick.isVisible = true;
  }

  @override
  void onTapUp(TapUpEvent event) {
    joystick.isVisible = false;
  }

  @override
  void onTapCancel(TapCancelEvent event) {
  }
}