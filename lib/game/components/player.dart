import 'package:flame/components.dart';
import 'package:wings/configs/game_images.dart';
import 'package:wings/enums/e_faction.dart';
import 'package:wings/game/components/base_plane.dart';
import 'package:wings/game/components/planes/fighter.dart';
import 'package:wings/game/plane_shooter_game.dart';
import 'package:wings/enums/e_projectile_type.dart';

class Player extends Component with HasGameReference<PlaneShooterGame> {
  late JoystickComponent joystick;
  static const double speed = 400;
  Vector2 _progressVelocity = Vector2.zero();

  Player() {
    plane = Fighter(faction: EFaction.player)..path = GameImages.player;
    plane.shoot = shoot;
  }

  late BasePlane plane;

  void setJoystick(JoystickComponent j) {
    joystick = j;
  }

  void setProgressVelocity(Vector2 velocity) {
    _progressVelocity = velocity;
  }

  @override
  Future<void> onLoad() async {
    plane.onPlaneDestroyed = onPlayerDestroyed;
    await add(plane);
  }

  @override
  void update(double dt) {
    super.update(dt);
    handleMovement(dt);
  }

  void handleMovement(double dt) {
    plane.velocity = _progressVelocity;
    if (joystick.direction != JoystickDirection.idle) {
      plane.velocity += joystick.relativeDelta * speed;
    }

    final viewport = game.camera.viewport;
    Vector2 topLeft = game.camera.globalToLocal(Vector2.zero());
    Vector2 bottomRight = game.camera.globalToLocal(viewport.size);
    plane.position.clamp(
      Vector2(topLeft.x + plane.size.x / 2, topLeft.y + plane.size.y / 2),
      Vector2(bottomRight.x - plane.size.x / 2, bottomRight.y - plane.y / 2),
    );
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
      ..owner = plane
      ..velocity = Vector2(0, -1000)
      ..position = Vector2(plane.position.x, plane.position.y);

    game.world.add(shell);
  }

  void onPlayerDestroyed() {
    // game.gameOver();
  }
}