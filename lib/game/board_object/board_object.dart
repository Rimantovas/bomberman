import 'package:bomberman/game.dart';
import 'package:bomberman/game/board_object/board_object_visitor.dart';
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

  bool canBeWalkedOn() {
    return false;
  }

  Vector2 getGridPosition(int tileSize) {
    return Vector2(
      (position.x / tileSize).floor().toDouble(),
      (position.y / tileSize).floor().toDouble(),
    );
  }

  void accept(
      BoardObjectVisitor visitor, BombermanGame gameRef, int gridY, int gridX) {
    visitor.visit(this, gameRef, gridY, gridX);
  }
}
