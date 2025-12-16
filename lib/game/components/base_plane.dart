import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:wings/enums/e_faction.dart';
import 'package:wings/enums/e_plane_type.dart';
import 'package:wings/game/plane_shooter_game.dart';

abstract class BasePlane extends SpriteComponent with HasGameReference<PlaneShooterGame>, CollisionCallbacks {
  final EFaction faction;
  final EPlaneType type;
  int health = 0;
  int maxHealth = 1;
  Vector2 velocity = Vector2.zero();
  double reload = 0.2;
  double _reloadTimer = 0.0;
  Function()? shoot;
  Function()? onPlaneDestroyed;

  BasePlane({required this.type, required this.faction}) {
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox());
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    
    // Check if plane collided with another plane from opposing faction
    if (other is BasePlane && other.faction != faction) {
      // Take damage equal to opponent's current health
      takeDamage(other.health);
      // Opponent also takes damage equal to this plane's health
      other.takeDamage(health);
    }
  }

  @override
  void update(double dt) {
    handleMovement(dt);
    handleShooting(dt);
  }

  void handleMovement(double dt) {
    position += velocity * dt;
  }

  void handleShooting(double dt) {
    if(null == shoot) return;

    _reloadTimer += dt;
    if (_reloadTimer >= reload) {
      _reloadTimer = 0.0;
      shoot?.call();
    }
  }

  void reset() {
    health = maxHealth;
    _reloadTimer = 0.0;
  }

  void takeDamage(int damage) {
    health -= damage;
    if (health <= 0) {
      if(null != onPlaneDestroyed) {
        onPlaneDestroyed!();
      }
    }
  }
}