import 'package:flame/components.dart';
import 'package:wings/configs/game_images.dart';
import 'package:wings/enums/e_faction.dart';
import 'package:wings/enums/e_plane_type.dart';
import 'package:wings/game/components/base_plane.dart';
import 'package:wings/game/components/enemy.dart';
import 'package:wings/game/components/planes/fighter.dart';
import 'package:wings/game/plane_shooter_game.dart';

class EnemyPoolManger extends Component with HasGameReference<PlaneShooterGame>{
  final Map<EPlaneType, List<dynamic>> _pool = {};
  static const int initialPoolSize = 10;

  @override
  Future<void> onLoad() async {
    await _initializePool();
  }

  Future<void> _initializePool() async {
    // Initialize pool for fighter
    _pool[EPlaneType.fighter] = [];
    for (int i = 0; i < initialPoolSize; i++) {
      final enemy = await _createEnemy(EPlaneType.fighter);
      _pool[EPlaneType.fighter]!.add(enemy);
    }
  }

  Future<Enemy> _createEnemy(EPlaneType type) async {
    Enemy enemy;
    
    switch (type) {
      case EPlaneType.fighter:
        enemy = Enemy();
        enemy.onEnemyDestroyed = () => returnEnemy(enemy);
        break;
    }
    
    // Pre-load the enemy
    await enemy.onLoad();
    
    return enemy;
  }

  Enemy get(EPlaneType type) {
    final pool = _pool[type];
    
    if (pool == null) {
      throw Exception('No pool exists for enemy type: $type');
    }
    
    Enemy enemy;
    
    if (pool.isNotEmpty) {
      // Reuse from pool
      enemy = pool.removeLast();
      enemy.reset();
    } else {
      // Create new if pool is empty (expand pool dynamically)
      enemy = _createEnemySync(type);
    }
    
    return enemy;
  }

  Enemy _createEnemySync(EPlaneType type) {
    // Create enemy synchronously (sprite should already be cached)
    Enemy enemy;
    
    switch (type) {
      case EPlaneType.fighter:
        enemy = Enemy();
        enemy.onEnemyDestroyed = () => returnEnemy(enemy);
        break;
    }
    
    return enemy;
  }

  void returnEnemy(dynamic enemy) {
    if (enemy is! Enemy) return;
    
    final pool = _pool[enemy.plane.type];
    
    if (pool != null) {
      pool.add(enemy);
    }
  }

  Enemy getRandomEnemy() {
    // For testing - currently only fighter type exists
    return get(EPlaneType.fighter);
  }
}