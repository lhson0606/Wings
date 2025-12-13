import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:wings/game/components/input/joystick.dart';
import 'package:wings/game/game_world.dart';
import 'package:wings/game/plane_shooter_game.dart';

class GameplayPage extends PositionComponent with HasGameReference<PlaneShooterGame>, TapCallbacks {
  late final Joystick joystick = game.joystick;

  GameplayPage({required Vector2 resolution}) : super(size: resolution);

  @override
  Future<void> onLoad() async {
    final gameWorld = GameWorld();
    await game.add(gameWorld);
    game.camera.world = gameWorld;
    joystick.isVisible = false;
    await add(joystick);
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

  @override
  void onRemove() {
    joystick.removeFromParent();
    super.onRemove();
  }
}
