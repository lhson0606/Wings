import 'package:flame/components.dart';
import 'package:wings/enums/e_plane_type.dart';
import 'package:wings/game/components/base_plane.dart';

class Chaser extends BasePlane {
  String path;
  bool hasPassedPlayer = false;
  Vector2 lockedDirection = Vector2.zero();

  Chaser({required super.faction, required this.path}) : super(type: EPlaneType.chaser);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(path);
  }

  @override
  void reset() {
    super.reset();
    hasPassedPlayer = false;
    lockedDirection = Vector2.zero();
  }
}
