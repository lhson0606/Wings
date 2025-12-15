import 'package:flame/components.dart';
import 'package:wings/game/components/base_plane.dart';
import 'package:wings/game/components/enemy.dart';
import 'package:wings/game/game_world.dart';
import 'package:wings/game/plane_shooter_game.dart';

class EnemyManager extends Component with HasGameReference<PlaneShooterGame>{
  final double spawnInterval = 2.0;
  double _spawnTimer = 0.0;

  EnemyManager() {
    // disable initially

  }

  @override
  void update(double dt) {
    if(false == isInGame()) {
      return;
    }

    handleSpawning(dt);
  }

  bool isInGame() {
    return game.world is GameWorld;
  }

  void handleSpawning(double dt) {
    _spawnTimer += dt;

    if (_spawnTimer >= spawnInterval) {
      _spawnTimer = 0.0;
      spawnEnemy();
    }
  }

  Vector2 getSpawnPosition() {
    final viewport = game.camera.viewport;
    Vector2 topLeft = game.camera.globalToLocal(Vector2.zero());
    Vector2 topRight = game.camera.globalToLocal(Vector2(viewport.size.x, 0));

    double spawnX = topLeft.x + (topRight.x - topLeft.x) * game.random.nextDouble();
    double spawnY = topLeft.y - 50; // Spawn slightly above the visible area

    return Vector2(spawnX, spawnY);
  }

  void spawnEnemy() {
    Enemy enemy = game.enemyPoolManager.getRandomEnemy();
    enemy.plane.position = getSpawnPosition();
    game.world.add(enemy);
  }
}