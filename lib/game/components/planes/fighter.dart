import 'package:flame/components.dart';
import 'package:wings/configs/plane_stats.dart';
import 'package:wings/enums/e_plane_type.dart';
import 'package:wings/game/components/base_plane.dart';

class Fighter extends BasePlane {
  String? path;

  Fighter({
    required super.faction,
  }) : super(
      type: EPlaneType.fighter,
      maxHealth: PlaneStats.gI().getStats(EPlaneType.fighter).maxHealth,
  ) {
    path = PlaneStats.gI().getStats(EPlaneType.fighter).imgPath;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load(path!);
  }
}