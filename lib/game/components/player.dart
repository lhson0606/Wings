import 'package:flame/components.dart';
import 'package:wings/configs/game_images.dart';
import 'package:wings/game/plane_shooter_game.dart';

class Player extends SpriteComponent with HasGameReference<PlaneShooterGame> {
  late JoystickComponent joystick;
  static const double speed = 400;
  Vector2 _progressVelocity = Vector2.zero();

  Player() : super(
    size: Vector2(64, 64),
    anchor: Anchor.center,
  );

  void setJoystick(JoystickComponent j) {
    joystick = j;
  }

  void setProgressVelocity(Vector2 velocity) {
    _progressVelocity = velocity;
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(GameImages.player);
  }

  @override
  void update(double dt) {
    position += _progressVelocity * dt;

    if (joystick.direction != JoystickDirection.idle) {
      position += joystick.relativeDelta * speed * dt;

      final viewport = game.camera.viewport;
      Vector2 topLeft = game.camera.globalToLocal(Vector2.zero());
      Vector2 bottomRight = game.camera.globalToLocal(viewport.size);
      position.clamp(
        Vector2(topLeft.x + size.x / 2, topLeft.y + size.y / 2),
        Vector2(bottomRight.x - size.x / 2, bottomRight.y - size.y / 2),
      );
    }
  }
}