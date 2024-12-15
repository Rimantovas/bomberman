import 'package:bomberman/game/movement/commands/command.dart';
import 'package:bomberman/game/player/player.dart';
import 'package:flame/components.dart';

class PlaceBombCommand implements Command {
  late Vector2 bombPosition;

  @override
  void execute(Player player) {
    print('PlaceBombCommand: execute');
    bombPosition = player.position.clone();
    player.placeBomb();
  }

  @override
  void undo(Player player) {
    // Remove the last placed bomb at bombPosition
    player.removeBombAt(bombPosition);
  }
}
