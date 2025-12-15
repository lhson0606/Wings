import 'package:flame/components.dart';
import 'package:wings/enums/e_plane_type.dart';
import 'package:wings/enums/e_projectile_type.dart';
import 'package:wings/game/components/base_plane.dart';
import 'package:wings/game/plane_shooter_game.dart';

class Fighter extends BasePlane {
  String path;

  Fighter({required super.faction, required this.path}) : super(type: EPlaneType.fighter);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(path);
  }
}