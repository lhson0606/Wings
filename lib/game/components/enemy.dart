import 'package:flame/components.dart';
import 'package:wings/configs/game_images.dart';
import 'package:wings/enums/e_faction.dart';
import 'package:wings/game/components/base_plane.dart';
import 'package:wings/game/components/planes/fighter.dart';
import 'package:wings/game/plane_shooter_game.dart';
import 'package:wings/enums/e_projectile_type.dart';

class Enemy extends Component with HasGameReference<PlaneShooterGame> {
  late BasePlane plane;
  Function()? onEnemyDestroyed;

  Enemy() {
    plane = Fighter(faction: EFaction.enemy, path: GameImages.fighter);
    plane.shoot = shoot;
    plane.onPlaneDestroyed = () => onPlaneDestroyed;
    plane.reload *= 10; // enemies shoot slower
  }

  void onPlaneDestroyed() {
    destroyEnemy();
  }

  void reset() {
    // Reset enemy state for pooling
    plane.reset();
    plane.angle = 3.14; // face downwards
  }

  @override
  Future<void> onLoad() async {
    // rotate to face downwards
    plane.angle = 3.14;
    await add(plane);
  }

  @override
  void update(double dt) {
    super.update(dt);
    handleMovement(dt);
  }

  void handleMovement(double dt) {
    plane.velocity = Vector2(0, 100); // move downwards

    Vector2 bottomRight = game.camera.globalToLocal(game.camera.viewport.size);
    if (plane.position.y > bottomRight.y + plane.size.y / 2) {
      destroyEnemy();
    }
  }

  void shoot() {
    // new, use pooling
    final shell = game.projectilePoolManager.get(EProjectileType.single_shell)
      ..owner = plane
      ..velocity = Vector2(0, 500)
      ..position = Vector2(plane.position.x, plane.position.y);

    game.world.add(shell);
  }

  void destroyEnemy() {
    removeFromParent();
    if (null != onEnemyDestroyed) {
      onEnemyDestroyed!();
    }
  }
}