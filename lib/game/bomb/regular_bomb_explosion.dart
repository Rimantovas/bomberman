import 'dart:math';

import 'package:bomberman/game/board_object/destroyable.dart';
import 'package:bomberman/game/bomb/explosion.dart';
import 'package:bomberman/game/bomb/explosion_template.dart';
import 'package:bomberman/game/map/game_map.dart';
import 'package:flame/components.dart';

//* TEMPLATE PATTERN
class RegularBombExplosion extends BombExplosionTemplate {
  RegularBombExplosion({
    required super.gameRef,
    required super.position,
    required super.strength,
    required super.branching,
  });

  @override
  List<Vector2> determineExplosionPath() {
    List<Vector2> path = [position];
    int remainingStrength = strength - 1;
    print('Remaining strength: $remainingStrength');
    int remainingBranching = branching;
    List<Vector2> directions = [
      Vector2(1, 0),
      Vector2(-1, 0),
      Vector2(0, 1),
      Vector2(0, -1)
    ];
    directions.shuffle();

    while (remainingStrength > 0 && directions.isNotEmpty) {
      Vector2? nextTile =
          _findNextTile(path.last, directions, remainingBranching > 0);

      if (nextTile != null) {
        path.add(nextTile);
        remainingStrength--;

        if (nextTile !=
            path.last + directions.first * GameMap.tileSize.toDouble()) {
          remainingBranching--;
          directions.shuffle();
        }
      } else {
        directions.removeAt(0);
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
        print('Player hit by explosion!');
      }
    }
  }

  @override
  void cleanup() {
    // No cleanup needed for regular bomb explosion
  }

  Vector2? _findNextTile(
      Vector2 currentTile, List<Vector2> directions, bool canBranch) {
    for (var direction in directions) {
      Vector2 nextTile = currentTile + direction * GameMap.tileSize.toDouble();
      if (_canPlaceExplosionTile(nextTile)) {
        if (_isDestroyableObject(nextTile)) {
          return nextTile;
        }
        if (canBranch && Random().nextInt(3) == 0) {
          Vector2 branchDirection = _getPerpendicularDirection(direction);
          Vector2 branchTile =
              currentTile + branchDirection * GameMap.tileSize.toDouble();
          if (_canPlaceExplosionTile(branchTile)) {
            return branchTile;
          }
        }
        return nextTile;
      }
    }
    return null;
  }

  Vector2 _getPerpendicularDirection(Vector2 direction) {
    return Vector2(-direction.y, direction.x);
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

  bool _canPlaceExplosionTile(Vector2 position) {
    Vector2 gridPos = position / GameMap.tileSize.toDouble();
    int x = gridPos.x.toInt();
    int y = gridPos.y.toInt();

    if (y >= 0 &&
        y < gameRef.gameMap.grid.length &&
        x >= 0 &&
        x < gameRef.gameMap.grid[0].length) {
      final boardObject = gameRef.gameMap.grid[y][x];
      return boardObject == null || boardObject.canBeDestroyed();
    }
    return false;
  }
}
