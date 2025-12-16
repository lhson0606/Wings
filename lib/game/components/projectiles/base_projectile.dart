import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
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
    
    // Check if projectile hit a plane from opposing faction
    if (other is BasePlane && owner != null && other.faction != owner!.faction) {
      other.takeDamage(damage);
      destroyProjectile();
    }
  }

  @override
  void update(double dt) {
    ttl -= dt;

    if (ttl <= 0) {
      destroyProjectile();
    }
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