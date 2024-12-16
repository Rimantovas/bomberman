import 'package:bomberman/game.dart';
import 'package:bomberman/game/board_object/board_object.dart';
import 'package:bomberman/game/bomb/bomb.dart';
import 'package:bomberman/game/bomb/explosion.dart';
import 'package:bomberman/game/collision/collision_visitor.dart';
import 'package:bomberman/game/mediator/game_mediator.dart';
import 'package:bomberman/game/movement/moving_state.dart';
import 'package:bomberman/game/player/player.dart';
import 'package:bomberman/game/useless/objects/power_up.dart';
import 'package:flame/components.dart';

//* CHAIN OF RESPONSIBILITY PATTERN
abstract class CollisionHandler extends Component
    with HasGameRef<BombermanGame> {
  CollisionHandler? next;
  CollisionSoundVisitor soundVisitor = CollisionSoundVisitor();

  void handleCollision(
      Player player, Set<Vector2> intersectionPoints, PositionComponent other) {
    if (canHandle(player, intersectionPoints, other)) {
      process(player, intersectionPoints, other);
    } else {
      next?.handleCollision(player, intersectionPoints, other);
    }
  }

  bool canHandle(
      Player player, Set<Vector2> intersectionPoints, PositionComponent other);
  void process(
      Player player, Set<Vector2> intersectionPoints, PositionComponent other);
}

class WallCollisionHandler extends CollisionHandler {
  @override
  bool canHandle(
      Player player, Set<Vector2> intersectionPoints, PositionComponent other) {
    return other is BoardObject && !other.canBeWalkedOn();
  }

  @override
  void process(
      Player player, Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is BoardObject) {
      soundVisitor.visitWall(player, other);
      final Vector2 collisionNormal =
          (player.position - other.position).normalized();

      // Update last collision position based on movement direction
      if (player.state == MovingState.down &&
          other.position.y > player.position.y &&
          other.position.x == player.position.x) {
        player.lastCollisionPosition = other.position.clone();
      } else if (player.state == MovingState.up &&
          other.position.y < player.position.y &&
          other.position.x == player.position.x) {
        player.lastCollisionPosition = other.position.clone();
      } else if (player.state == MovingState.left &&
          other.position.x < player.position.x &&
          other.position.y == player.position.y) {
        player.lastCollisionPosition = other.position.clone();
      } else if (player.state == MovingState.right &&
          other.position.x > player.position.x &&
          other.position.y == player.position.y) {
        player.lastCollisionPosition = other.position.clone();
      }

      // Handle collision response
      if (collisionNormal.y.abs() > collisionNormal.x.abs()) {
        player.velocity.y = 0;
        if (collisionNormal.y < 0) {
          player.position.y = other.position.y - player.size.y;
        } else {
          player.position.y = other.position.y + other.size.y;
        }
      } else {
        player.velocity.x = 0;
        if (collisionNormal.x < 0) {
          player.position.x = other.position.x - player.size.x;
        } else {
          player.position.x = other.position.x + other.size.x;
        }
      }
    }
  }
}

class BombCollisionHandler extends CollisionHandler {
  @override
  bool canHandle(
      Player player, Set<Vector2> intersectionPoints, PositionComponent other) {
    return other is Bomb;
  }

  @override
  void process(
      Player player, Set<Vector2> intersectionPoints, PositionComponent other) {
    soundVisitor.visitBomb(player, other as Bomb);
    // For now, bombs can be walked through
    // In the future, we might want to add logic for player-specific bomb collision
  }
}

class ExplosionCollisionHandler extends CollisionHandler {
  @override
  bool canHandle(
      Player player, Set<Vector2> intersectionPoints, PositionComponent other) {
    return other is Explosion;
  }

  @override
  void process(
      Player player, Set<Vector2> intersectionPoints, PositionComponent other) {
    print('Player hit by explosion!');
    soundVisitor.visitExplosion(player, other as Explosion);
    gameRef.remove(other);
    GameMediator(player, other, null).notify(GameEvent.explosion);

    // TODO: Add damage/death logic
  }
}

class PowerUpCollisionHandler extends CollisionHandler {
  @override
  bool canHandle(
      Player player, Set<Vector2> intersectionPoints, PositionComponent other) {
    return other is PowerUp;
  }

  @override
  void process(
      Player player, Set<Vector2> intersectionPoints, PositionComponent other) {
    print('Player collected a power-up!');
    soundVisitor.visitPowerUp(player, other as PowerUp);
    gameRef.remove(other);
    GameMediator(player, null, other).notify(GameEvent.powerupCollect);

    // TODO: Add power-up collection logic
  }
}
