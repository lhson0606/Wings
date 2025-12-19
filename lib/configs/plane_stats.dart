import 'package:wings/enums/e_plane_type.dart';
import 'package:wings/configs/game_images.dart';

class PlaneStatsEntry {
  final int maxHealth;
  final String imgPath;

  PlaneStatsEntry({required this.imgPath, required this.maxHealth});
}

class PlaneStats {
  static PlaneStats? _instance;

  static PlaneStats gI() {
    if(null == _instance) {
      _instance = PlaneStats();
    }
    return _instance!;
  }

  final Map<EPlaneType, PlaneStatsEntry> _stats = {
    EPlaneType.fighter : PlaneStatsEntry(imgPath: GameImages.fighter, maxHealth: 3),
    EPlaneType.chaser: PlaneStatsEntry(imgPath: GameImages.chaser, maxHealth: 4),
    EPlaneType.sineCurve: PlaneStatsEntry(imgPath: GameImages.sinCurve, maxHealth: 5),
  };

  PlaneStatsEntry getStats(EPlaneType type) {
    return _stats[type]!;
  }
}