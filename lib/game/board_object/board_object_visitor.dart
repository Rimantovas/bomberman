import 'package:bomberman/game.dart';
import 'package:bomberman/game/board_object/board_object.dart';

//* [Pattern] Visitor Pattern
abstract class BoardObjectVisitor {
  void visit(BoardObject object, BombermanGame gameRef, int gridY, int gridX);
}
