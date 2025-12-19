import 'package:flame/components.dart';
import 'package:wings/configs/plane_stats.dart';
import 'package:wings/enums/e_plane_type.dart';
import 'package:wings/game/components/base_plane.dart';

class SineCurve extends BasePlane {
  late final String path;
  double _time = 0.0;
  double amplitude = 50.0; // How wide the sine curve is
  double frequency = 2.0; // How fast it oscillates

  SineCurve({required super.faction}) : super(type: EPlaneType.sineCurve) {
    PlaneStatsEntry stats = PlaneStats.gI().getStats(EPlaneType.sineCurve);
    path = stats.imgPath;
    maxHealth = stats.maxHealth;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load(path);
  }

  @override
  void update(double dt) {
    _time += dt;
    super.update(dt);
  }

  double get timeOffset => _time;
}