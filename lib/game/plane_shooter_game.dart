import 'package:flame/camera.dart';
import 'package:flame/game.dart';
import 'package:wings/game/components/input/joystick.dart';
import 'package:wings/game/pages/gameplay_page.dart';
import 'package:wings/game/pages/home_page.dart';
import 'package:wings/routes/app_routes.dart';

class PlaneShooterGame extends FlameGame {
  static final double width = 360;
  static final double height = 640;
  late final RouterComponent router;
  late final Joystick joystick;

  PlaneShooterGame() {
    camera.viewport = FixedResolutionViewport(resolution: Vector2(width, height));
  }

  @override
  void onLoad() {
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
}