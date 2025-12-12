import 'package:flame/components.dart';
import 'package:wings/game/components/player.dart';

class GameWorld extends World {
  late final Player player;

  @override
  Future<void> onLoad() async {
    // Add player
    player = Player();
    add(player);
  }
}
