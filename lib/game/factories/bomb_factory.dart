import 'package:flame/game.dart';

import '../objects/bomb.dart';
import '../objects/regular_bomb.dart';

class BombFactory {
  static Bomb createBomb(BombType type, {required Vector2 position}) {
    switch (type) {
      case BombType.regular:
        return RegularBomb(position: position);
      case BombType.remote:
      case BombType.laser:
        // Implement these bomb types in the future
        throw UnimplementedError('This bomb type is not yet implemented');
      default:
        throw ArgumentError('Unknown BombType: $type');
    }
  }
}
