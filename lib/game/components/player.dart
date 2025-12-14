import 'package:flame/components.dart';
import 'package:wings/configs/game_images.dart';
import 'package:wings/enums/e_faction.dart';
import 'package:wings/game/components/base_plane.dart';
import 'package:wings/game/components/projectiles/single_shell.dart';
import 'package:wings/game/plane_shooter_game.dart';
import 'package:wings/enums/e_projectile_type.dart';

class Player extends BasePlane with HasGameReference<PlaneShooterGame> {
  late JoystickComponent joystick;
  static const double speed = 400;
  Vector2 _progressVelocity = Vector2.zero();
  final double _reload = 0.2;
  double _reloadTimer = 0.0;

  Player() : super(faction: EFaction.player) {
    size = Vector2(64, 64);
    anchor = Anchor.center;
  }

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
    handleMovement(dt);
    handleShooting(dt);
  }

  void handleMovement(double dt) {
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

  void handleShooting(double dt) {
    _reloadTimer += dt;
    if (_reloadTimer >= _reload) {
      _reloadTimer = 0.0;
      shoot();
    }
  }

  void shoot() {
    // old
    // final shell = SingleShell(
    //   owner: this,
    //   velocity: Vector2(0, -1000),
    //   path: GameImages.singleShell,
    //   position: Vector2(position.x, position.y),
    //   type: EProjectileType.single_shell,
    // );

    // new, use pooling
    final shell = game.projectilePoolManager.get(EProjectileType.single_shell)
      ..owner = this
      ..velocity = Vector2(0, -1000)
      ..position = Vector2(position.x, position.y);

    game.world.add(shell);
  }
}