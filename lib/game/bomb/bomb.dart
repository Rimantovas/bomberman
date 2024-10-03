import 'package:bomberman/game/bomb/explosion.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import '../../game.dart';
import '../../utils/app_asset.dart';

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
      _createExplosion(tile);
    }
    gameRef.remove(this);
  }

  void _createExplosion(Vector2 position) {
    final explosion = Explosion(position: position);
    add(explosion);

    Vector2 gridPos = explosion.getGridPosition(BombermanGame.tileSize);
    int x = gridPos.x.toInt();
    int y = gridPos.y.toInt();

    if (y >= 0 &&
        y < gameRef.grid.length &&
        x >= 0 &&
        x < gameRef.grid[0].length) {
      if (gameRef.grid[y][x] != null && gameRef.grid[y][x]!.canBeDestroyed()) {
        remove(gameRef.grid[y][x]!);
        gameRef.grid[y][x] = null;
      }
    }

    if (gameRef.player.toRect().overlaps(explosion.toRect())) {
      print('Player hit by explosion!');
    }
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
