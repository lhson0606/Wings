import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:wings/configs/game_sounds.dart';
import 'package:wings/game/plane_shooter_game.dart';

class SoundManager extends Component with HasGameReference<PlaneShooterGame>{
  @override
  Future<void> onLoad() async {
    FlameAudio.bgm.initialize();
  }

  void playBackgroundMusic() {
    FlameAudio.bgm.play(GameSounds.gameBackgroundMusic, volume: 0.5);
  }

  void playBossBackgroundMusic() {
    FlameAudio.bgm.play(GameSounds.bossBackgroundMusic, volume: 0.5);
  }

  void playExplosionSound() {
    game.soundPoolManager.playExplosionSound();
  }

  void playButtonClickSound() {
    game.soundPoolManager.playButtonClickSound();
  }

  @override
  void onRemove() {
    FlameAudio.bgm.dispose();
  }
}