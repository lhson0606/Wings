import 'package:flame/components.dart';
import 'package:wings/configs/game_images.dart';
import 'package:wings/enums/e_projectile_type.dart';
import 'package:wings/game/components/projectiles/base_projectile.dart';
import 'package:wings/game/components/projectiles/single_shell.dart';
import 'package:wings/game/plane_shooter_game.dart';

class ProjectilePoolManager extends Component with HasGameReference<PlaneShooterGame>{
  final Map<EProjectileType, List<dynamic>> _pool = {};
  static const int initialPoolSize = 20;

  @override
  Future<void> onLoad() async {
    await _initializePool();
  }

  Future<void> _initializePool() async {
    // Initialize pool for single_shell
    _pool[EProjectileType.single_shell] = [];
    for (int i = 0; i < initialPoolSize; i++) {
      final projectile = await _createProjectile(EProjectileType.single_shell);
      _pool[EProjectileType.single_shell]!.add(projectile);
    }
  }

  Future<BaseProjectile> _createProjectile(EProjectileType type) async {
    BaseProjectile projectile;
    
    switch (type) {
      case EProjectileType.single_shell:
        projectile = SingleShell(
          owner: null as dynamic, // Will be set when retrieved
          velocity: Vector2.zero(),
          path: GameImages.singleShell,
          position: Vector2.zero(),
          type: type,
        );
        break;
    }
    
    // Pre-load the sprite
    await projectile.onLoad();
    
    return projectile;
  }

  BaseProjectile get(EProjectileType type) {
    final pool = _pool[type];
    
    if (pool == null) {
      throw Exception('No pool exists for projectile type: $type');
    }
    
    BaseProjectile projectile;
    
    if (pool.isNotEmpty) {
      // Reuse from pool
      projectile = pool.removeLast();
      projectile.reset();
    } else {
      // Create new if pool is empty (expand pool dynamically)
      projectile = _createProjectileSync(type);
    }
    
    return projectile;
  }

  BaseProjectile _createProjectileSync(EProjectileType type) {
    // Create projectile synchronously (sprite should already be cached)
    switch (type) {
      case EProjectileType.single_shell:
        return SingleShell(
          owner: null as dynamic,
          velocity: Vector2.zero(),
          path: GameImages.singleShell,
          position: Vector2.zero(),
          type: type,
        );
    }
  }

  void returnProjectile(dynamic projectile) {
    final pool = _pool[projectile.type];
    
    if (pool != null) {
      pool.add(projectile);
    }
  }
}