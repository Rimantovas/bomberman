import 'dart:math';

import 'package:flame/components.dart';

import 'objects/destroyable.dart';
import 'objects/power_up.dart';
import 'objects/wall.dart';

class GameBoard {
  final int width;
  final int height;
  final int tileSize;
  final Random random = Random();

  GameBoard({required this.width, required this.height, this.tileSize = 50});

  // [OPP] Factory Pattern: Creates different game objects based on the type
  PositionComponent createGameObject(String type, Vector2 position) {
    switch (type) {
      case 'wall':
        return Wall(position: position);
      case 'destroyable':
        return Destroyable(position: position);
      case 'powerup':
        return PowerUp(position: position);
      default:
        throw ArgumentError('Invalid game object type');
    }
  }

  List<PositionComponent> generateLevel() {
    List<PositionComponent> gameObjects = [];

    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        if (x == 0 || y == 0 || x == width - 1 || y == height - 1) {
          gameObjects.add(createGameObject('wall',
              Vector2((x * tileSize).toDouble(), (y * tileSize).toDouble())));
        } else if (random.nextDouble() < 0.3) {
          gameObjects.add(createGameObject('destroyable',
              Vector2((x * tileSize).toDouble(), (y * tileSize).toDouble())));
        } else if (random.nextDouble() < 0.05) {
          gameObjects.add(createGameObject('powerup',
              Vector2((x * tileSize).toDouble(), (y * tileSize).toDouble())));
        }
      }
    }

    return gameObjects;
  }
}
