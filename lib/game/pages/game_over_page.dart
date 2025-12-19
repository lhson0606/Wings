import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:wings/configs/game_images.dart';
import 'package:wings/game/components/ui/rounded_button.dart';
import 'package:wings/game/plane_shooter_game.dart';
import 'package:flutter/rendering.dart';
import 'package:wings/routes/app_routes.dart';

class GameOverPage extends Component with HasGameReference<PlaneShooterGame> {
  GameOverPage() {
    addAll([
      _background = SpriteComponent()
        ..anchor = Anchor.topLeft
        ..position = Vector2.zero(),
      _gameOverOutline = TextComponent(
        text: 'GAME OVER',
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: 48,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 4
              ..color = const Color(0xFF000000),
            fontWeight: FontWeight.w800,
          ),
        ),
      )..anchor = Anchor.center,
      _gameOver = TextComponent(
        text: 'GAME OVER',
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 48,
            color: Color(0xFFFF0000),
            fontWeight: FontWeight.w800,
          ),
        ),
      )..anchor = Anchor.center,
      _btnRestart = RoundedButton(
        text: 'Restart',
        action: () {
          game.soundManager.playButtonClickSound();
          game.router.pushReplacementNamed(AppRoutes.gameplay);
        },
        color: const Color(0xFFFFD700),
        borderColor: const Color(0xFFFFEB3B),
      )..anchor = Anchor.center,
      _btnHome = RoundedButton(
        text: 'Home',
        action: () {
          game.soundManager.playButtonClickSound();
          game.router.pushReplacementNamed(AppRoutes.home);
        },
        color: const Color(0xFF4A90E2),
        borderColor: const Color(0xFF5BA3F5),
      )..anchor = Anchor.center,
    ]);
  }

  late final SpriteComponent _background;
  late final TextComponent _gameOverOutline;
  late final TextComponent _gameOver;
  late final RoundedButton _btnRestart;
  late final RoundedButton _btnHome;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _background.sprite = await game.loadSprite('backgrounds/bg.png');
    
    // Add pulsing effect to game over text
    _gameOver.add(
      ScaleEffect.by(
        Vector2.all(1.1),
        EffectController(
          duration: 0.8,
          alternate: true,
          infinite: true,
        ),
      ),
    );
    
    // Add pulsing effect to outline
    _gameOverOutline.add(
      ScaleEffect.by(
        Vector2.all(1.1),
        EffectController(
          duration: 0.8,
          alternate: true,
          infinite: true,
        ),
      ),
    );
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    
    // Maintain aspect ratio while covering entire screen
    if (_background.sprite != null) {
      final imageSize = _background.sprite!.srcSize;
      final imageAspect = imageSize.x / imageSize.y;
      final screenAspect = size.x / size.y;
      
      if (screenAspect > imageAspect) {
        // Screen is wider than image - fit to width
        _background.size = Vector2(size.x, size.x / imageAspect);
      } else {
        // Screen is taller than image - fit to height
        _background.size = Vector2(size.y * imageAspect, size.y);
      }
      
      // Center the background
      _background.position = Vector2(
        (size.x - _background.size.x) / 2,
        (size.y - _background.size.y) / 2,
      );
    }
    
    _gameOverOutline.position = Vector2(size.x / 2, size.y / 2 - 80);
    _gameOver.position = Vector2(size.x / 2, size.y / 2 - 80);
    _btnRestart.position = Vector2(size.x / 2, size.y / 2 + 40);
    _btnHome.position = Vector2(size.x / 2, size.y / 2 + 100);
  }
}

