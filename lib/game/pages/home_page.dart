import 'package:flame/components.dart';
import 'package:wings/game/components/ui/rounded_button.dart';
import 'package:wings/game/plane_shooter_game.dart';
import 'package:flutter/rendering.dart';

class HomePage extends Component with HasGameReference<PlaneShooterGame> {
  HomePage() {
    addAll([
      _logo = TextComponent(
        text: 'Wings!!!',
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 64,
            color: Color(0xFFC8FFF5),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      _btnStart = RoundedButton(
        text: 'Start',
        action: () => {},
        color: const Color(0xffadde6c),
        borderColor: const Color(0xffedffab),
      ),
      // _button2 = RoundedButton(
      //   text: 'Level 2',
      //   action: () => game.router.pushNamed('level2'),
      //   color: const Color(0xffdebe6c),
      //   borderColor: const Color(0xfffff4c7),
      // ),
    ]);
  }

  late final TextComponent _logo;
  late final RoundedButton _btnStart;
  // late final RoundedButton _button2;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _logo.position = Vector2(size.x / 2 - 100, 20);
    _btnStart.position = Vector2(size.x / 2, size.y - 60);
  }
}