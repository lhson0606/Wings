import 'package:flame/components.dart';
import 'package:wings/configs/plane_stats.dart';
import 'package:wings/enums/e_plane_type.dart';
import 'package:wings/game/components/base_plane.dart';

class Chaser extends BasePlane {
  late final String path;
  bool hasPassedPlayer = false;
  Vector2 lockedDirection = Vector2.zero();

  Chaser({required super.faction}) : super(type: EPlaneType.chaser) {
    PlaneStatsEntry stats = PlaneStats.gI().getStats(EPlaneType.chaser);
    path = stats.imgPath;
    maxHealth = stats.maxHealth;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load(path);
  }

  @override
  void reset() {
    super.reset();
    hasPassedPlayer = false;
    lockedDirection = Vector2.zero();
  }
}
