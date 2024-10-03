import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import '../game.dart';
import '../utils/app_asset.dart';

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

  void explode() {
    List<Vector2> explosionTiles = _createExplosionTiles();
    for (var tile in explosionTiles) {
      gameRef.createExplosion(tile);
    }
    gameRef.remove(this);
  }

  List<Vector2> _createExplosionTiles() {
    List<Vector2> tiles = [position];
    List<Vector2> directions = [
      Vector2(1, 0),
      Vector2(-1, 0),
      Vector2(0, 1),
      Vector2(0, -1),
    ];

    for (var direction in directions) {
      for (int i = 1; i <= strength; i++) {
        Vector2 newTile =
            position + direction * (i * BombermanGame.tileSize).toDouble();
        tiles.add(newTile);

        // Add branching explosions
        if (i > 1 && branching > 1) {
          Vector2 perpendicularDir = Vector2(-direction.y, direction.x);
          tiles.add(
              newTile + perpendicularDir * BombermanGame.tileSize.toDouble());
          tiles.add(
              newTile - perpendicularDir * BombermanGame.tileSize.toDouble());
        }
      }
    }

    return tiles;
  }
}
