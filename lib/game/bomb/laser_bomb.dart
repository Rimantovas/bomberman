import 'package:bomberman/game/bomb/bomb.dart';
import 'package:bomberman/game/bomb/laser_bomb_explosion.dart';
import 'package:bomberman/utils/app_asset.dart';

class LaserBomb extends Bomb {
  LaserBomb({
    required super.primaryModifier,
    required super.secondaryModifier,
    required super.colorScheme,
    required super.position,
  })  : strength = primaryModifier * 4, // Longer range for laser
        super(
            damage: 20,
            explosionDelay: secondaryModifier
                .toDouble()); // Duration based on secondary modifier

  final int strength;

  @override
  String get spritePath => AppAsset.bombLaser; // You'll need to add this asset

  @override
  void execute() {
    final explosion = LaserBombExplosion(
      gameRef: gameRef,
      position: position,
      primary: strength,
      secondary: 0, // Laser doesn't branch
    );
    explosion.execute();
    gameRef.remove(this);
  }
}
