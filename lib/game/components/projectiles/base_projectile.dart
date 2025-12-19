import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:wings/configs/projectile_stats.dart';
import 'package:wings/game/components/base_plane.dart';
import 'package:wings/enums/e_projectile_type.dart';
import 'package:wings/game/plane_shooter_game.dart';

abstract class BaseProjectile extends SpriteComponent with HasGameReference<PlaneShooterGame>, CollisionCallbacks {
  static const double default_tts = 5.0;

  Vector2 velocity;
  BasePlane? owner;
  final String path;
  final EProjectileType type;
  double ttl = 0.0; // time to live in seconds
  int damage = 1;

  BaseProjectile({
    required this.owner,
    required this.velocity,
    required this.path,
    required super.position,
    required this.type,
    Vector2? size,
  }) : super(
    size: size ?? Vector2(16, 16),
    anchor: Anchor.center,
  ) {
    damage = ProjectileStats.gI().getStats(type).damage;
    ttl = ProjectileStats.gI().getStats(type).ttl;
    reset();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox());
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if(other == owner) {
      return;
    }

    if (other is BasePlane && owner != null && other.faction != owner!.faction) {
      other.takeDamage(damage);
      destroyProjectile();
    } else if(other is BaseProjectile) {
      // destroy both projectiles on collision
      destroyProjectile();
      other.destroyProjectile();
    }
  }

  @override
  void update(double dt) {
    ttl -= dt;

    if (ttl <= 0) {
      destroyProjectile();
      return;
    }
    
    // Update position here to ensure collision detection works properly
    position += velocity * dt;
  }

  void destroyProjectile() {
    removeFromParent();

    if (parent != null) {
      game.projectilePoolManager.returnProjectile(this);
    }
  }

  void reset() {
    // Called when reusing from pool
    ttl = default_tts;
  }
}