import 'package:flame/components.dart';
import 'package:wings/enums/e_plane_type.dart';
import 'package:wings/game/components/base_plane.dart';

class SineCurve extends BasePlane {
  String path;
  double _time = 0.0;
  double amplitude = 50.0; // How wide the sine curve is
  double frequency = 2.0; // How fast it oscillates

  SineCurve({required super.faction, required this.path}) : super(type: EPlaneType.sineCurve);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(path);
  }

  @override
  void update(double dt) {
    _time += dt;
    super.update(dt);
  }

  double get timeOffset => _time;
}