import 'package:flame/components.dart';
import 'package:flame/game.dart';

class PlaneShooterGame extends FlameGame{
  late final RouterComponent router;

  PlaneShooterGame() {
    add(world);
  }

  @override
  void onLoad() {
    add(
        router = RouterComponent(
          initialRoute: 'mainMenu',
          routes: {
          },
        )
    );
  }
}