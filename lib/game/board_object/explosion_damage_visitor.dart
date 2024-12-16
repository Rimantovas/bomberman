import 'package:bomberman/game.dart';
import 'package:bomberman/game/board_object/board_object.dart';
import 'package:bomberman/game/board_object/board_object_visitor.dart';
import 'package:bomberman/game/board_object/destroyable.dart';

//* [Pattern] Visitor Pattern
class ExplosionDamageVisitor implements BoardObjectVisitor {
  @override
  void visit(BoardObject object, BombermanGame gameRef, int gridY, int gridX) {
    if (object.canBeDestroyed()) {
      if (object is Destroyable) {
        object.executeDestruction(gameRef, gridY, gridX);
      } else {
        gameRef.gameMap.remove(gameRef.gameMap.grid[gridY][gridX]!);
        gameRef.gameMap.grid[gridY][gridX] = null;
      }
    } else {
      print('Exploded on ${object.runtimeType}');
    }
  }
}
