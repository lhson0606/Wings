import 'package:wings/configs/game_images.dart';
import 'package:wings/enums/e_projectile_type.dart';

class ProjectileStatsEntry {
  final double ttl;
  final int damage;
  final String imgPath;

  ProjectileStatsEntry({required this.imgPath, required this.ttl, required this.damage});
}

class ProjectileStats {
  static ProjectileStats? _instance;

  static ProjectileStats gI() {
    _instance ??= ProjectileStats();
    return _instance!;
  }

  final Map<EProjectileType, ProjectileStatsEntry> _stats = {
    EProjectileType.single_shell: ProjectileStatsEntry(imgPath: GameImages.singleShell, ttl: 3.0, damage: 1),
  };

  ProjectileStatsEntry getStats(EProjectileType type) {
    return _stats[type]!;
  }
}

