import 'package:bomberman/game.dart';
import 'package:bomberman/game/map/game_map.dart';
import 'package:bomberman/game/movement/moving_state.dart';
import 'package:bomberman/game/player/player_animation_strategy.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../board_object/board_object.dart';
import '../bomb/bomb.dart';
import '../bomb/bomb_factory.dart';

class Player extends SpriteAnimationComponent
    with HasGameRef<BombermanGame>, CollisionCallbacks {
  final String id;
  static const double _speed = 100.0;
  final Vector2 velocity = Vector2.zero();
  late final PlayerAnimationStrategy animationStrategy;
  String _currentDirection = 'front';
  String _currentAnimationName = 'idle_front';
  MovingState _state = MovingState.still;

  Vector2? lastCollisionPosition;

  Player({required Vector2 position, required this.id})
      : super(position: position, size: Vector2(32, 32)) {
    add(RectangleHitbox());
    animationStrategy = PlayerAnimationStrategy();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await animationStrategy.loadAnimations();
    animation = animationStrategy.getAnimation(_currentAnimationName);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _updateMovement(dt);
    _updateAnimation();
  }

  void _updateMovement(double dt) {
    // print('position: ${position.x} ${position.y}');
    velocity.setZero();
    switch (_state) {
      case MovingState.up:
        velocity.y = -_speed;
        break;
      case MovingState.down:
        velocity.y = _speed;
        break;
      case MovingState.left:
        velocity.x = -_speed;
        break;
      case MovingState.right:
        velocity.x = _speed;
        break;
      case MovingState.still:
        break;
    }

    // Check if position is perfect
    bool isPerfectX = (position.x % GameMap.tileSize).abs() < 0.1;
    bool isPerfectY = (position.y % GameMap.tileSize).abs() < 0.1;

    if ((!isPerfectX || !isPerfectY) && lastCollisionPosition != null) {
      // Adjust position if not perfect and there's a collision
      if (_state == MovingState.right || _state == MovingState.left) {
        if (!isPerfectY) {
          // Use the actual colliding object's position
          double collidingTileY = lastCollisionPosition!.y;

          if (position.y < collidingTileY) {
            velocity.y = -_speed; // Move up
          } else {
            velocity.y = _speed; // Move down
          }
        }
      } else if (_state == MovingState.up || _state == MovingState.down) {
        if (!isPerfectX) {
          // Use the actual colliding object's position
          double collidingTileX = lastCollisionPosition!.x;
          if (position.x < collidingTileX) {
            velocity.x = -_speed; // Move left
          } else {
            velocity.x = _speed; // Move right
          }
        }
      }
    }

    position.add(velocity * dt);
    final newPos = position.clone()..add(velocity * dt);
    if (newPos != position) {
      gameRef.updateMyPosition(newPos);
    }
  }

  void _updateAnimation() {
    String newDirection = _currentDirection;

    if (velocity.x < 0) {
      newDirection = 'left';
    } else if (velocity.x > 0) {
      newDirection = 'right';
    } else if (velocity.y < 0) {
      newDirection = 'back';
    } else if (velocity.y > 0) {
      newDirection = 'front';
    }

    final isMoving = !velocity.isZero();
    final prefix = isMoving ? 'walk' : 'idle';
    final newAnimationName = '${prefix}_$newDirection';

    if (newAnimationName != _currentAnimationName) {
      _currentDirection = newDirection;
      _currentAnimationName = newAnimationName;
      animation = animationStrategy.getAnimation(_currentAnimationName);
    }
  }

  void setState(MovingState newState) {
    _state = newState;
  }

  MovingState get state => _state;

  void placeBomb() {
    final bomb =
        BombFactory.createBomb(BombType.regular, position: position.clone());
    gameRef.add(bomb);

    gameRef.add(
      TimerComponent(
        period: bomb.explosionDelay,
        onTick: () {
          bomb.execute();
          gameRef.remove(bomb);
        },
      ),
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is BoardObject) {
      /// Before setting the last collision position, check if it is in the direction of where the player is moving
      /// For the logic, check if other.position.y is for example more than player position.y and moving state is down
      /// Then we don't want to set the last collision position
      final Vector2 collisionNormal = (position - other.position).normalized();
      if (_state == MovingState.down &&
          other.position.y > position.y &&
          other.position.x == position.x) {
        lastCollisionPosition = other.position.clone();
      } else if (_state == MovingState.up &&
          other.position.y < position.y &&
          other.position.x == position.x) {
        lastCollisionPosition = other.position.clone();
      } else if (_state == MovingState.left &&
          other.position.x < position.x &&
          other.position.y == position.y) {
        lastCollisionPosition = other.position.clone();
      } else if (_state == MovingState.right &&
          other.position.x > position.x &&
          other.position.y == position.y) {
        lastCollisionPosition = other.position.clone();
      }

      if (collisionNormal.y.abs() > collisionNormal.x.abs()) {
        velocity.y = 0;
        if (collisionNormal.y < 0) {
          position.y = other.position.y - size.y;
        } else {
          position.y = other.position.y + other.size.y;
        }
      } else {
        velocity.x = 0;
        if (collisionNormal.x < 0) {
          position.x = other.position.x - size.x;
        } else {
          position.x = other.position.x + other.size.x;
        }
      }
    }
  }
}
