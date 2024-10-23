import 'package:bomberman/game.dart';
import 'package:bomberman/utils/app_asset.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

enum BombType { regular, remote, laser }

abstract class Bomb extends SpriteAnimationComponent
    with HasGameRef<BombermanGame> {
  final int strength;
  final int branching;
  final double explosionDelay;

  Bomb({
    required this.strength,
    required this.branching,
    required this.explosionDelay,
    required Vector2 position,
  }) : super(position: position, size: Vector2(32, 32));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final spriteSheet = SpriteSheet(
      image: await gameRef.images.load(AppAsset.bombDynamite),
      srcSize: Vector2(32, 32),
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.1, to: 3);
  }

  void execute();
}
