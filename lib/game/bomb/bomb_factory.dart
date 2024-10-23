import 'package:bomberman/game/map/game_map.dart';
import 'package:flame/game.dart';

import 'bomb.dart';
import 'regular_bomb.dart';

class BombFactory {
  static Bomb createBomb(BombType type, {required Vector2 position}) {
    // Align position to the grid
    final perfectPosition = Vector2(
      (position.x / GameMap.tileSize).floor() * GameMap.tileSize.toDouble(),
      (position.y / GameMap.tileSize).floor() * GameMap.tileSize.toDouble(),
    );

    switch (type) {
      case BombType.regular:
        return RegularBomb(position: perfectPosition);
      case BombType.remote:
      case BombType.laser:
        // Implement these bomb types in the future
        throw UnimplementedError('This bomb type is not yet implemented');
      default:
        throw ArgumentError('Unknown BombType: $type');
    }
  }
}
