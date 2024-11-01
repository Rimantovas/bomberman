import 'dart:math';

import 'package:bomberman/game/bomb/bomb.dart';
import 'package:bomberman/game/bomb/explosion.dart';
import 'package:bomberman/game/map/game_map.dart';
import 'package:bomberman/utils/app_asset.dart';
import 'package:flame/components.dart';

class RegularBomb extends Bomb {
  RegularBomb({
    required super.primaryModifier,
    required super.secondaryModifier,
    required super.colorScheme,
    super.explosionDelay = 3.0,
    required super.position,
  })  : strength = primaryModifier * 3,
        branching = secondaryModifier * 1;

  final int strength;
  final int branching;

  @override
  String get spritePath => AppAsset.bombDynamite;

  @override
  void execute() {
    explode();
  }

  void explode() {
    List<Vector2> explosionTiles = _createExplosionPath();
    for (var tile in explosionTiles) {
      _createExplosion(tile);
    }
    gameRef.remove(this);
  }

  void _createExplosion(Vector2 position) {
    final explosion = Explosion(position: position);
    gameRef.add(explosion);

    Vector2 gridPos = explosion.getGridPosition(GameMap.tileSize);
    int x = gridPos.x.toInt();
    int y = gridPos.y.toInt();

    if (y >= 0 &&
        y < gameRef.gameMap.grid.length &&
        x >= 0 &&
        x < gameRef.gameMap.grid[0].length) {
      if (gameRef.gameMap.grid[y][x] != null &&
          gameRef.gameMap.grid[y][x]!.canBeDestroyed()) {
        gameRef.gameMap.remove(gameRef.gameMap.grid[y][x]!);
        gameRef.gameMap.grid[y][x] = null;
      }
    }

    if (gameRef.playerManager.myPlayer.toRect().overlaps(explosion.toRect())) {
      print('Player hit by explosion!');
    }
  }

  List<Vector2> _createExplosionPath() {
    List<Vector2> path = [position];
    int remainingStrength = strength - 1;
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
          directions.shuffle(); // Reshuffle after branching
        }
      } else {
        directions
            .removeAt(0); // Remove the current direction if we can't move in it
      }
    }

    return path;
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
          // 1/3 chance to branch
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

  Vector2 _getPerpendicularDirection(Vector2 direction) {
    return Vector2(-direction.y, direction.x);
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
