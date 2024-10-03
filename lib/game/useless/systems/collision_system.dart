import 'package:flame/components.dart';

class CollisionSystem {
  // [OPP] Singleton Pattern: Ensures only one instance of CollisionSystem exists
  static final CollisionSystem _instance = CollisionSystem._internal();

  factory CollisionSystem() {
    return _instance;
  }

  CollisionSystem._internal();

  bool checkCollision(PositionComponent a, PositionComponent b) {
    return a.toRect().overlaps(b.toRect());
  }

  bool isCollidingWithAny(
      PositionComponent component, List<PositionComponent> others) {
    return others.any((other) => checkCollision(component, other));
  }
}
