import 'package:flame/components.dart';
import 'package:wings/enums/e_faction.dart';

abstract class BasePlane extends SpriteComponent {
  final EFaction faction;

  BasePlane({required this.faction});
}