import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:wings/game/components/ui/simple_button.dart';
import 'package:wings/game/plane_shooter_game.dart';

class PauseButton extends SimpleButton with HasGameReference<PlaneShooterGame> {
  PauseButton()
      : super(
    Path()
      ..moveTo(14, 10)
      ..lineTo(14, 30)
      ..moveTo(26, 10)
      ..lineTo(26, 30),
    position: Vector2(60, 10),
  );

  bool isPaused = false;

  @override
  void action() {
    if (isPaused) {
      game.router.pop();
    } else {
      game.router.pushNamed('pause');
    }
    isPaused = !isPaused;
  }
}