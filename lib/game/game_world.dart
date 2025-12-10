import 'package:flame/components.dart';
import 'package:wings/game/components/player.dart';

class GameWorld extends World {
  @override
  Future<void> onLoad() async {
    add(Player(position: Vector2(0, 0)));
  }
}