import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';
import 'package:flame/rendering.dart';
import 'package:wings/configs/game_images.dart';
import 'package:wings/game/plane_shooter_game.dart';

class Player extends PositionComponent with HasGameReference<PlaneShooterGame> {
  late JoystickComponent joystick;
  late Sprite playerSprite;
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
  void render(Canvas canvas) {
    playerSprite.render(canvas, size: size);
  }

  @override
  Future<void> onLoad() async {
    playerSprite = await game.loadSprite(GameImages.player);
    position = Vector2(50, 100);
  }

  @override
  void update(double dt) {
    if (joystick.direction != JoystickDirection.idle) {
      position += joystick.relativeDelta * speed * dt;
    }
  }
}