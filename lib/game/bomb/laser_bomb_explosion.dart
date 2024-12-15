import 'package:bomberman/game/board_object/destroyable.dart';
import 'package:bomberman/game/bomb/explosion.dart';
import 'package:bomberman/game/bomb/explosion_template.dart';
import 'package:bomberman/game/map/game_map.dart';
import 'package:flame/components.dart';

class LaserBombExplosion extends BombExplosionTemplate {
  LaserBombExplosion({
    required super.gameRef,
    required super.position,
    required super.primary,
    required super.secondary,
  });

  @override
  List<Vector2> determineExplosionPath() {
    List<Vector2> path = [position];
    final directions = [
      Vector2(1, 0), // right
      Vector2(-1, 0), // left
      Vector2(0, 1), // down
      Vector2(0, -1) // up
    ];

    // Find the direction that gives the longest path
    List<Vector2>? longestPath;
    int maxLength = 0;

    for (var direction in directions) {
      final currentPath = _computePathInDirection(direction);
      if (currentPath.length > maxLength) {
        maxLength = currentPath.length;
        longestPath = currentPath;
      }
    }

    return longestPath ?? path;
  }

  List<Vector2> _computePathInDirection(Vector2 direction) {
    List<Vector2> path = [position];
    int remainingprimary = primary - 1;

    while (remainingprimary > 0) {
      final nextTile = path.last + direction * GameMap.tileSize.toDouble();

      if (!_canPlaceExplosionTile(nextTile)) {
        break;
      }

      path.add(nextTile);
      remainingprimary--;

      // Stop if we hit a destroyable object
      if (_isDestroyableObject(nextTile)) {
        break;
      }
    }

    return path;
  }

  @override
  void createExplosions(List<Vector2> explosionTiles) {
    for (var tile in explosionTiles) {
      final explosion = Explosion(position: tile);
      gameRef.add(explosion);
    }
  }

  @override
  void applyDamage(List<Vector2> explosionTiles) {
    for (var tile in explosionTiles) {
      Vector2 gridPos = tile / GameMap.tileSize.toDouble();
      int x = gridPos.x.toInt();
      int y = gridPos.y.toInt();

      if (y >= 0 &&
          y < gameRef.gameMap.grid.length &&
          x >= 0 &&
          x < gameRef.gameMap.grid[0].length) {
        final boardObject = gameRef.gameMap.grid[y][x];
        if (boardObject != null && boardObject.canBeDestroyed()) {
          if (boardObject is Destroyable) {
            boardObject.executeDestruction(gameRef, y, x);
          } else {
            gameRef.gameMap.remove(gameRef.gameMap.grid[y][x]!);
            gameRef.gameMap.grid[y][x] = null;
          }
        }
      }

      if (gameRef.playerManager.myPlayer.toRect().overlaps(
            Explosion(position: tile).toRect(),
          )) {
        print('Player hit by laser!');
      }
    }
  }

  @override
  void cleanup() {
    // No cleanup needed for laser bomb explosion
  }

  bool _canPlaceExplosionTile(Vector2 position) {
    Vector2 gridPos = position / GameMap.tileSize.toDouble();
    int x = gridPos.x.toInt();
    int y = gridPos.y.toInt();

    if (y >= 0 &&
        y < gameRef.gameMap.grid.length &&
        x >= 0 &&
        x < gameRef.gameMap.grid[0].length) {
      final boardObject = gameRef.gameMap.grid[y][x];
      return boardObject == null ||
          boardObject.canBeDestroyed() ||
          boardObject.canBeWalkedOn();
    }
    return false;
  }

  bool _isDestroyableObject(Vector2 position) {
    Vector2 gridPos = position / GameMap.tileSize.toDouble();
    int x = gridPos.x.toInt();
    int y = gridPos.y.toInt();

    if (y >= 0 &&
        y < gameRef.gameMap.grid.length &&
        x >= 0 &&
        x < gameRef.gameMap.grid[0].length) {
      final boardObject = gameRef.gameMap.grid[y][x];
      return boardObject != null && boardObject.canBeDestroyed();
    }
    return false;
  }
}
