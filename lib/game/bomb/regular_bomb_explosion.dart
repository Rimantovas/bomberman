import 'dart:ui';

import 'package:bomberman/game/board_object/destroyable.dart';
import 'package:bomberman/game/board_object/explosion_damage_visitor.dart';
import 'package:bomberman/game/board_object/explosion_sound_visitor.dart';
import 'package:bomberman/game/bomb/explosion.dart';
import 'package:bomberman/game/bomb/explosion_template.dart';
import 'package:bomberman/game/map/game_map.dart';
import 'package:flame/components.dart';

//* TEMPLATE PATTERN
class RegularBombExplosion extends BombExplosionTemplate {
  RegularBombExplosion({
    required super.gameRef,
    required super.position,
    required super.primary,
    required super.secondary,
  });

  @override
  List<Vector2> determineExplosionPath() {
    List<Vector2> path = [position];
    Set<String> visitedPositions = {
      _positionKey(position)
    }; // Track visited positions
    int remainingPrimary = primary - 1;
    int remainingSecondary = secondary - 1;
    List<Vector2> directions = [
      Vector2(1, 0),
      Vector2(-1, 0),
      Vector2(0, 1),
      Vector2(0, -1)
    ];
    directions.shuffle();
    Vector2 currentDirection = directions.first;

    print('Remaining primary: $remainingPrimary');
    print('Remaining secondary: $remainingSecondary');
    print('Initial path: $path');
    print('----------------------------');

    while (remainingPrimary > 0 && directions.isNotEmpty) {
      Vector2? nextTile = _findNextTile(
        path.last,
        currentDirection,
        remainingSecondary > 0,
        visitedPositions,
      );

      print('Computed next tile: $nextTile');

      if (nextTile != null) {
        path.add(nextTile);
        visitedPositions.add(_positionKey(nextTile));
        remainingPrimary--;

        Vector2 actualDirection =
            (nextTile - path[path.length - 2]) / GameMap.tileSize.toDouble();
        if (actualDirection != currentDirection) {
          currentDirection = actualDirection;
          remainingSecondary--;
        }
      } else {
        directions.remove(currentDirection);
        if (directions.isNotEmpty) {
          currentDirection = directions.first;
        }
      }
    }

    return path;
  }

  @override
  void createExplosions(List<Vector2> explosionTiles) {
    for (var tile in explosionTiles) {
      final explosion = Explosion(position: tile, damage: 15);
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
        final damageVisitor = ExplosionDamageVisitor();
        final soundVisitor = ExplosionSoundVisitor();
        boardObject?.accept(damageVisitor, gameRef, y, x);
        boardObject?.accept(soundVisitor, gameRef, y, x);
      }

      if (gameRef.playerManager.myPlayer.toRect().overlaps(
            Explosion(position: tile, damage: 15).toRect(),
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
    Vector2 currentTile,
    Vector2 currentDirection,
    bool canBranch,
    Set<String> visitedPositions,
  ) {
    // Helper function to check if a position has been visited
    bool isUnvisited(Vector2 pos) =>
        !visitedPositions.contains(_positionKey(pos));

    // First, check if we can continue in the current direction
    Vector2 nextTile =
        currentTile + currentDirection * GameMap.tileSize.toDouble();

    print('Next tile: $nextTile');
    print('Can place explosion tile: ${_canPlaceExplosionTile(nextTile)}');
    print('Is unvisited: ${isUnvisited(nextTile)}');
    print('Has player at: ${_hasPlayerAt(nextTile)}');
    print('Is destroyable object: ${_isDestroyableObject(nextTile)}');
    print('Can branch: $canBranch');
    print('----------------------------');

    // Priority 1: Check for players in current direction
    if (_canPlaceExplosionTile(nextTile) &&
        isUnvisited(nextTile) &&
        _hasPlayerAt(nextTile)) {
      print('Priority 1: Returning next tile: $nextTile');
      return nextTile;
    }

    // Priority 2: Check for destroyable objects in current direction
    if (_canPlaceExplosionTile(nextTile) &&
        isUnvisited(nextTile) &&
        _isDestroyableObject(nextTile)) {
      print('Priority 2: Returning next tile: $nextTile');
      return nextTile;
    }

    // Priority 3: If can branch, check perpendicular directions for players
    if (canBranch) {
      Vector2 perpendicularDir = _getPerpendicularDirection(currentDirection);
      for (var dir in [perpendicularDir, perpendicularDir * -1]) {
        Vector2 branchTile = currentTile + dir * GameMap.tileSize.toDouble();
        if (_canPlaceExplosionTile(branchTile) &&
            isUnvisited(branchTile) &&
            _hasPlayerAt(branchTile)) {
          print('Priority 3: Returning next tile: $branchTile');
          return branchTile;
        }
      }
    }

    // Priority 4: If can branch, check perpendicular directions for destroyables
    if (canBranch) {
      Vector2 perpendicularDir = _getPerpendicularDirection(currentDirection);
      for (var dir in [perpendicularDir, perpendicularDir * -1]) {
        Vector2 branchTile = currentTile + dir * GameMap.tileSize.toDouble();
        if (_canPlaceExplosionTile(branchTile) &&
            isUnvisited(branchTile) &&
            _isDestroyableObject(branchTile)) {
          print('Priority 4: Returning next tile: $branchTile');
          return branchTile;
        }
      }
    }

    // Priority 5: Continue in current direction if possible
    if (_canPlaceExplosionTile(nextTile) && isUnvisited(nextTile)) {
      print('Priority 5: Returning next tile: $nextTile');
      return nextTile;
    }

    // Priority 6: If can branch, try perpendicular directions
    if (canBranch) {
      Vector2 perpendicularDir = _getPerpendicularDirection(currentDirection);
      for (var dir in [perpendicularDir, perpendicularDir * -1]) {
        Vector2 branchTile = currentTile + dir * GameMap.tileSize.toDouble();
        if (_canPlaceExplosionTile(branchTile) && isUnvisited(branchTile)) {
          print('Priority 6: Returning next tile: $branchTile');
          return branchTile;
        }
      }
    }

    return null;
  }

  // Helper method to create a unique key for a position
  String _positionKey(Vector2 position) => '${position.x},${position.y}';

  bool _hasPlayerAt(Vector2 position) {
    return gameRef.playerManager.myPlayer.toRect().overlaps(
          Rect.fromLTWH(position.x, position.y, GameMap.tileSize.toDouble(),
              GameMap.tileSize.toDouble()),
        );
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
      return boardObject == null ||
          boardObject.canBeDestroyed() ||
          boardObject.canBeWalkedOn();
    }
    return false;
  }
}
