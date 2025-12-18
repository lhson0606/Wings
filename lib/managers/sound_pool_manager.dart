import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:wings/configs/game_sounds.dart';

class SoundPoolManager extends Component {
  late final AudioPool explosionPool;
  late final AudioPool buttonClickPool;

  @override
  Future<void> onLoad() async {
    await FlameAudio.audioCache.loadAll([
      GameSounds.buttonClickSound,
      GameSounds.explosionSound,
    ]);

    explosionPool = await FlameAudio.createPool(GameSounds.explosionSound, maxPlayers: 8);
    buttonClickPool = await FlameAudio.createPool(GameSounds.buttonClickSound, maxPlayers: 4);
  }

  void playExplosionSound() {
    explosionPool.start();
  }

  void playButtonClickSound() {
    buttonClickPool.start();
  }

  @override
  void onRemove() {
    FlameAudio.audioCache.clearAll();
  }
}