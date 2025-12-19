import 'package:flame/components.dart';
import 'package:wings/configs/game_images.dart';
import 'package:wings/enums/e_faction.dart';
import 'package:wings/enums/e_plane_type.dart';
import 'package:wings/game/components/base_plane.dart';
import 'package:wings/game/components/planes/fighter.dart';
import 'package:wings/game/components/planes/sine_curve.dart';
import 'package:wings/game/components/planes/chaser.dart';
import 'package:wings/game/plane_shooter_game.dart';
import 'package:wings/game/game_world.dart';
import 'package:wings/enums/e_projectile_type.dart';
import 'dart:math' as math;

class Enemy extends Component with HasGameReference<PlaneShooterGame> {
  late BasePlane plane;
  Function()? onEnemyDestroyed;
  double _initialX = 0.0; // Store initial X position for sine curve

  Enemy({EPlaneType planeType = EPlaneType.fighter}) {
    switch (planeType) {
      case EPlaneType.fighter:
        plane = Fighter(faction: EFaction.enemy);
        break;
      case EPlaneType.sineCurve:
        plane = SineCurve(faction: EFaction.enemy);
        break;
      case EPlaneType.chaser:
        plane = Chaser(faction: EFaction.enemy);
        break;
    }

    plane.shoot = shoot;
    plane.reload *= 10; // enemies shoot slower
    plane.onPlaneShootDown = () {
      game.soundManager.playExplosionSound();
    };
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
      case EPlaneType.chaser:
        final chaserPlane = plane as Chaser;
        final gameWorld = game.world;
        
        if (gameWorld is GameWorld) {
          final player = gameWorld.player;
          
          if (!chaserPlane.hasPassedPlayer) {
            // Check if still in front of player (enemy is above player)
            if (plane.position.y < player.plane.position.y) {
              // Chase player - calculate direction to player
              final direction = (player.plane.position - plane.position).normalized();
              chaserPlane.lockedDirection = direction;
              plane.velocity = direction * 150; // Chase speed
            } else {
              // Passed the player, lock direction
              chaserPlane.hasPassedPlayer = true;
              plane.velocity = chaserPlane.lockedDirection * 150;
            }
          } else {
            // Keep moving in locked direction
            plane.velocity = chaserPlane.lockedDirection * 150;
          }
        }
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