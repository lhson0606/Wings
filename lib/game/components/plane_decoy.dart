import 'package:flame/components.dart';

class PlaneDecoy extends SpriteComponent {
  String path;

  PlaneDecoy({required this.path});

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(path);
    anchor = Anchor.center;
  }
}