import 'package:flame/components.dart';
import 'package:wings/configs/game_images.dart';
import 'package:wings/enums/e_faction.dart';
import 'package:wings/enums/e_plane_type.dart';
import 'package:wings/game/components/base_plane.dart';
import 'package:wings/game/components/planes/fighter.dart';
import 'package:wings/game/components/planes/sine_curve.dart';
import 'package:wings/game/plane_shooter_game.dart';
import 'package:wings/enums/e_projectile_type.dart';
import 'dart:math' as math;

class Enemy extends Component with HasGameReference<PlaneShooterGame> {
  late BasePlane plane;
  Function()? onEnemyDestroyed;
  double _initialX = 0.0; // Store initial X position for sine curve

  Enemy({EPlaneType planeType = EPlaneType.fighter}) {
    switch (planeType) {
      case EPlaneType.fighter:
        plane = Fighter(faction: EFaction.enemy, path: GameImages.fighter)..maxHealth = 2;
        break;
      case EPlaneType.sineCurve:
        plane = SineCurve(faction: EFaction.enemy, path: GameImages.sinCurve)..maxHealth = 2;
        break;
    }

    plane.shoot = shoot;
    plane.reload *= 10; // enemies shoot slower
  }

  void onPlaneDestroyed() {
    destroyEnemy();
  }

  void reset() {
    // Reset enemy state for pooling
    plane.reset();
    plane.angle = 3.14; // face downwards
    _initialX = plane.position.x; // Update initial X position
  }

  @override
  Future<void> onLoad() async {
    // rotate to face downwards
    plane.angle = 3.14;
    _initialX = plane.position.x; // Store initial X position
    plane.onPlaneDestroyed = onPlaneDestroyed;
    await add(plane);
  }

  @override
  void update(double dt) {
    super.update(dt);
    handleMovement(dt);
  }

  void handleMovement(double dt) {
    switch (plane.type) {
      case EPlaneType.fighter:
        plane.velocity = Vector2(0, 100); // move straight down
        break;
      case EPlaneType.sineCurve:
        // Move in sine curve pattern
        final sineCurvePlane = plane as SineCurve;
        final sineValue = math.sin(sineCurvePlane.timeOffset * sineCurvePlane.frequency);
        final targetX = _initialX + sineValue * sineCurvePlane.amplitude;
        
        // Calculate horizontal velocity to reach target X position
        final currentX = plane.position.x;
        final horizontalVelocity = (targetX - currentX) * 5.0; // Adjust multiplier for smoothness
        
        plane.velocity = Vector2(horizontalVelocity, 100); // move down with sine curve
        break;
    }

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