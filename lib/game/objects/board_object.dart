import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

abstract class BoardObject extends SpriteComponent with CollisionCallbacks {
  BoardObject({required Vector2 position, required Vector2 size})
      : super(position: position, size: size) {
    add(RectangleHitbox());
  }

  bool canBeDestroyed() {
    return false;
  }

  Vector2 getGridPosition(int tileSize) {
    return Vector2(
      (position.x / tileSize).floor().toDouble(),
      (position.y / tileSize).floor().toDouble(),
    );
  }
}
