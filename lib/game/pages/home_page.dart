import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:wings/configs/game_images.dart';
import 'package:wings/game/components/ui/rounded_button.dart';
import 'package:wings/game/plane_shooter_game.dart';
import 'package:wings/game/components/plane_decoy.dart';
import 'package:flutter/rendering.dart';
import 'package:wings/routes/app_routes.dart';

class HomePage extends Component with HasGameReference<PlaneShooterGame> {
  HomePage() {
    addAll([
      _background = SpriteComponent()
        ..anchor = Anchor.topLeft
        ..position = Vector2.zero(),
      _logoOutline = TextComponent(
        text: 'Wings!!!',
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: 64,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 4
              ..color = const Color(0xFF000000),
            fontWeight: FontWeight.w800,
          ),
        ),
      )..anchor = Anchor.center,
      _logo = TextComponent(
        text: 'Wings!!!',
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 64,
            color: Color(0xFFFF6B6B),
            fontWeight: FontWeight.w800,
          ),
        ),
      )..anchor = Anchor.center,
      _btnStart = RoundedButton(
        text: 'Start',
        action: () => {game.router.pushReplacementNamed(AppRoutes.gameplay)},
        color: const Color(0xFFFFD700),
        borderColor: const Color(0xFFFFEB3B),
      )..anchor = Anchor.center,
      // _button2 = RoundedButton(
      //   text: 'Level 2',
      //   action: () => game.router.pushNamed('level2'),
      //   color: const Color(0xffdebe6c),
      //   borderColor: const Color(0xfffff4c7),
      // ),
      _planeDecoy = PlaneDecoy(path: GameImages.player)
        ..position = Vector2(0, 0)
        ..size = Vector2(100, 100),
    ]);
  }

  late final SpriteComponent _background;
  late final TextComponent _logoOutline;
  late final TextComponent _logo;
  late final RoundedButton _btnStart;
  late final PlaneDecoy _planeDecoy;
  // late final RoundedButton _button2;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _background.sprite = await game.loadSprite('backgrounds/bg.png');
    
    // Add pulsing effect to logo
    _logo.add(
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
    _logoOutline.add(
      ScaleEffect.by(
        Vector2.all(1.1),
        EffectController(
          duration: 0.8,
          alternate: true,
          infinite: true,
        ),
      ),
    );
    
    // Add pulsing effect to start button
    _btnStart.add(
      ScaleEffect.by(
        Vector2.all(1.15),
        EffectController(
          duration: 1.0,
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
    
    _logoOutline.position = Vector2(size.x / 2, 80);
    _logo.position = Vector2(size.x / 2, 80);
    _btnStart.position = Vector2(size.x / 2, size.y - 60);
    _planeDecoy.position = Vector2(size.x / 2, size.y / 2);
  }
}