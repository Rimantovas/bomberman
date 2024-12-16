import 'package:bomberman/game.dart';
import 'package:bomberman/game/rendering/color_scheme.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

enum BombType { regular, remote, laser }

abstract class Bomb extends SpriteAnimationComponent
    with HasGameRef<BombermanGame> {
  final int primaryModifier;
  final int secondaryModifier;
  final double explosionDelay;
  final ColorScheme colorScheme;

  Bomb({
    required this.primaryModifier,
    required this.secondaryModifier,
    required this.explosionDelay,
    required Vector2 position,
    required this.colorScheme,
  }) : super(position: position, size: Vector2(32, 32)) {
    add(RectangleHitbox());
  }

  String get spritePath;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final spriteSheet = await colorScheme.getSprite(spritePath);
    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.1, to: 3);
  }

  void execute();
}
