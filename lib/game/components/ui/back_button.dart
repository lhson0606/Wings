import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:wings/game/components/ui/simple_button.dart';
import 'package:wings/game/plane_shooter_game.dart';

class BackButton extends SimpleButton with HasGameReference<PlaneShooterGame> {
  BackButton()
      : super(
    Path()
      ..moveTo(22, 8)
      ..lineTo(10, 20)
      ..lineTo(22, 32)
      ..moveTo(12, 20)
      ..lineTo(34, 20),
    position: Vector2.all(10),
  );

  @override
  void action() => game.router.pop();
}