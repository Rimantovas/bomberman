import 'package:bomberman/game/bomb/laser_bomb.dart';
import 'package:bomberman/game/map/game_map.dart';
import 'package:bomberman/game/rendering/color_scheme.dart';
import 'package:flame/game.dart';

import 'bomb.dart';
import 'regular_bomb.dart';

class BombFactory {
  static Bomb createBomb(
    BombType type, {
    required Vector2 position,
    required ColorScheme colorScheme,
    required int primaryModifier,
    required int secondaryModifier,
  }) {
    // Align position to the grid
    final perfectPosition = Vector2(
      (position.x / GameMap.tileSize).floor() * GameMap.tileSize.toDouble(),
      (position.y / GameMap.tileSize).floor() * GameMap.tileSize.toDouble(),
    );

    switch (type) {
      case BombType.regular:
        return RegularBomb(
          position: perfectPosition,
          primaryModifier: primaryModifier,
          secondaryModifier: secondaryModifier,
          colorScheme: colorScheme,
        );
      case BombType.remote:
      case BombType.laser:
        return LaserBomb(
            primaryModifier: primaryModifier,
            secondaryModifier: secondaryModifier,
            colorScheme: colorScheme,
            position: position);

      default:
        throw ArgumentError('Unknown BombType: $type');
    }
  }
}
