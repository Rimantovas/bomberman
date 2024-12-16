import 'package:bomberman/game.dart';
import 'package:bomberman/game/collision/collision_handler.dart';
import 'package:bomberman/game/map/game_map.dart';
import 'package:bomberman/game/movement/moving_state.dart';
import 'package:bomberman/game/player/player_animation_strategy.dart';
import 'package:bomberman/game/rendering/color_scheme.dart';
import 'package:bomberman/game/useless/objects/power_up.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../bomb/bomb.dart';
import '../bomb/bomb_factory.dart';

class Player extends SpriteAnimationComponent
    with HasGameRef<BombermanGame>, CollisionCallbacks {
  final String id;
  final ColorImplementor colorImplementor;
  static const double _speed = 100.0;
  final Vector2 velocity = Vector2.zero();
  late final PlayerAnimationStrategy animationStrategy;
  String _currentDirection = 'front';
  String _currentAnimationName = 'idle_front';
  MovingState _state = MovingState.still;

  Vector2? lastCollisionPosition;

  late final CollisionHandler _collisionHandler;
  var health = 100;
  var laserBombsCount = 0;

  Player({
    required Vector2 position,
    required this.id,
    required this.colorImplementor,
  }) : super(position: position, size: Vector2(32, 32)) {
    add(RectangleHitbox());
    animationStrategy = PlayerAnimationStrategy(
      colorScheme: PlayerColorScheme(colorImplementor),
    );

    //* CHAIN OF RESPONSIBILITY PATTERN
    final wallHandler = WallCollisionHandler();
    final bombHandler = BombCollisionHandler();
    final explosionHandler = ExplosionCollisionHandler();
    final powerUpHandler = PowerUpCollisionHandler();
    add(wallHandler);
    add(bombHandler);
    add(explosionHandler);
    add(powerUpHandler);

    wallHandler.next = bombHandler;
    bombHandler.next = explosionHandler;
    explosionHandler.next = powerUpHandler;

    _collisionHandler = wallHandler;
  }

  void takeDamage(int damage) {
    print('Player $id took $damage damage');
    health -= damage;
    if (health <= 0) {
      //todo
    }
    gameRef.updatePlayerHealth(id, health);
  }

  void collectPowerup(PowerUp powerup) {
    print('Player $id collected powerup');
    laserBombsCount++;
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

/*************  ✨ Codeium Command ⭐  *************/
  /// Updates the animation of the player, based on the velocity.
  ///
  /// This checks if the player is moving or not, and in which direction.
  /// It then sets the correct animation accordingly.
  /// ****  d90d217c-b786-43e7-8731-e8d9c3d104c5  ******
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
    final bomb = BombFactory.createBomb(
      laserBombsCount > 0 ? BombType.laser : BombType.regular,
      position: position.clone(),
      colorScheme: BombColorScheme(colorImplementor),
      primaryModifier: 2,
      secondaryModifier: 1,
    );
    if (laserBombsCount > 0) {
      laserBombsCount--;
    }
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
    _collisionHandler.handleCollision(this, intersectionPoints, other);
  }

  void removeBombAt(Vector2 position) {
    // Find and remove the bomb at the given position
    // This is a simplified example - you'll need to implement the actual bomb removal logic
    // based on your game's implementation
    final bombsToRemove =
        children.whereType<Bomb>().where((bomb) => bomb.position == position);

    for (final bomb in bombsToRemove) {
      remove(bomb);
    }
  }
}
