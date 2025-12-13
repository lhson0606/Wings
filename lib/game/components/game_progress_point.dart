import 'package:flame/components.dart';

class GameProgressPoint extends PositionComponent {
  Vector2 _progressVelocity = Vector2(0, -256);

  Vector2 get progressVelocity => _progressVelocity;

  @override
  Future<void> onLoad() async {

  }

  @override
  void update(double dt) {
    position += _progressVelocity * dt;
  }
}