import 'dart:ui';

import 'package:flame/components.dart';
import 'package:wings/game/components/base_plane.dart';
import 'package:wings/game/components/projectiles/base_projectile.dart';

class SingleShell extends BaseProjectile {

  SingleShell({
    required super.owner,
    required super.velocity,
    required super.path,
    required super.position,
    required super.type,
    Vector2? size,
  });

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(path);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }
  
  @override
  void reset() {
    super.reset();
    // Reset any shell-specific state here if needed
  }
}