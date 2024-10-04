import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

import '../../utils/app_asset.dart';

class PlayerAnimationStrategy {
  late final Map<String, SpriteAnimation> animations;

  Future<void> loadAnimations() async {
    animations = {
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
  }

  Future<SpriteAnimation> _loadAnimation(String asset, int amount) async {
    final spriteSheet = SpriteSheet(
      image: await Flame.images.load(asset),
      srcSize: Vector2(32, 32),
    );
    return spriteSheet.createAnimation(row: 0, stepTime: 0.1, to: amount);
  }

  SpriteAnimation getAnimation(String animationKey) {
    return animations[animationKey]!;
  }

  SpriteAnimation? updateAnimation(Vector2 velocity, String currentDirection) {
    final isMoving = !velocity.isZero();
    final prefix = isMoving ? 'walk' : 'idle';
    return animations['${prefix}_$currentDirection'];
  }
}
