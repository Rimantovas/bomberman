import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import '../../utils/app_asset.dart';
import '../board_object/board_object.dart';
import '../bomb/bomb.dart';
import '../bomb/bomb_factory.dart';

enum MovingState { still, up, down, right, left }

class Player extends SpriteAnimationComponent
    with HasGameRef, CollisionCallbacks {
  static const double _speed = 100.0;
  final Vector2 velocity = Vector2.zero();
  late final Map<String, SpriteAnimation> _animations;
  String _currentDirection = 'front';
  MovingState _state = MovingState.still;

  Player({required Vector2 position})
      : super(position: position, size: Vector2(32, 32)) {
    add(RectangleHitbox());
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _animations = {
      'idle_front': await _loadAnimation(AppAsset.playerIdleFront, 4),
      'idle_back': await _loadAnimation(AppAsset.playerIdleBack, 4),
      'idle_left': await _loadAnimation(AppAsset.playerIdleLeft, 4),
      'idle_right': await _loadAnimation(AppAsset.playerIdleRight, 4),
      'walk_front': await _loadAnimation(AppAsset.playerWalkFront, 4),
      'walk_back': await _loadAnimation(AppAsset.playerWalkBack, 4),
      'walk_left': await _loadAnimation(AppAsset.playerWalkLeft, 4),
      'walk_right': await _loadAnimation(AppAsset.playerWalkRight, 4),
      'death': await _loadAnimation(AppAsset.playerDeathFront, 5),
    };
    animation = _animations['idle_front']!;
  }

  Future<SpriteAnimation> _loadAnimation(String asset, int amount) async {
    final spriteSheet = SpriteSheet(
      image: await gameRef.images.load(asset),
      srcSize: Vector2(32, 32),
    );
    return spriteSheet.createAnimation(row: 0, stepTime: 0.1, to: amount);
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
    position.add(velocity * dt);
  }

  void _updateAnimation() {
    final isMoving = !velocity.isZero();
    final prefix = isMoving ? 'walk' : 'idle';

    if (velocity.x < 0) {
      _currentDirection = 'left';
    } else if (velocity.x > 0) {
      _currentDirection = 'right';
    } else if (velocity.y < 0) {
      _currentDirection = 'back';
    } else if (velocity.y > 0) {
      _currentDirection = 'front';
    }

    animation = _animations['${prefix}_$_currentDirection']!;
  }

  void setState(MovingState newState) {
    _state = newState;
  }

  void placeBomb() {
    final bomb =
        BombFactory.createBomb(BombType.regular, position: position.clone());
    gameRef.add(bomb);

    gameRef.add(
      TimerComponent(
        period: bomb.explosionDelay,
        onTick: () {
          bomb.explode();
          gameRef.remove(bomb);
        },
      ),
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is BoardObject) {
      final Vector2 collisionNormal = (position - other.position).normalized();
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
