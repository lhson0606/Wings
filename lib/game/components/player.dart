import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:wings/configs/game_images.dart';
import 'package:wings/game/plane_shooter_game.dart';

class Player extends SpriteComponent with HasGameReference<PlaneShooterGame> {
  late JoystickComponent joystick;
  static const double speed = 200;
  static const double maxTilt = 0.3;

  Player() : super(
    size: Vector2(64, 64),
    anchor: Anchor.center,
  );

  void setJoystick(JoystickComponent j) {
    joystick = j;
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(GameImages.player);
  }

  @override
  void update(double dt) {
    if (joystick.direction != JoystickDirection.idle) {
      position += joystick.relativeDelta * speed * dt;
    }
  }
}