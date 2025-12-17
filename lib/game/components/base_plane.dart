import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:wings/enums/e_faction.dart';
import 'package:wings/enums/e_plane_type.dart';
import 'package:wings/game/plane_shooter_game.dart';

import '../../configs/game_images.dart';

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
  late SpriteAnimation destroyAnimation;
  bool isDestroying = false;
  Sprite? _originalSprite;
  SpriteAnimationComponent? _destroyAnimationComponent;

  BasePlane({required this.type, required this.faction}) {
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox());
    
    // Load destroy animation from individual frames
    final sprites = await Future.wait([
      Sprite.load(GameImages.die_01),
      Sprite.load(GameImages.die_02),
      Sprite.load(GameImages.die_03),
      Sprite.load(GameImages.die_04),
      Sprite.load(GameImages.die_05),
    ]);
    
    destroyAnimation = SpriteAnimation.spriteList(
      sprites,
      stepTime: 0.1,
      loop: false,
    );
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
    if (!isDestroying) {
      handleMovement(dt);
      handleShooting(dt);
    }
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
    isDestroying = false;
    
    // Remove animation component if it exists
    if (_destroyAnimationComponent != null) {
      _destroyAnimationComponent!.removeFromParent();
      _destroyAnimationComponent = null;
    }
    
    // Restore original sprite
    if (_originalSprite != null) {
      sprite = _originalSprite;
    }
  }

  void takeDamage(int damage) {
    health -= damage;
    if (health <= 0 && !isDestroying) {
      playDestroyAnimation();
    }
  }

  void playDestroyAnimation() {
    isDestroying = true;
    velocity = Vector2.zero();
    
    // Store original sprite before removing it
    _originalSprite = sprite;
    
    // Create animation component
    _destroyAnimationComponent = SpriteAnimationComponent(
      animation: destroyAnimation,
      size: size,
      anchor: Anchor.center,
    );
    
    // Remove the original sprite
    sprite = null;
    
    add(_destroyAnimationComponent!);
    
    // Remove plane after animation completes
    Future.delayed(Duration(milliseconds: (5 * 0.1 * 1000).toInt()), () {
      if(null != onPlaneDestroyed) {
        onPlaneDestroyed!();
      }
    });
  }
}