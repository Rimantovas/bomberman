import 'package:bomberman/game/movement/commands/command.dart';
import 'package:bomberman/game/player/player.dart';

class PlaceBombCommand implements Command {
  @override
  void execute(Player player) {
    player.placeBomb();
  }

  @override
  void undo(Player player) {
    // TODO: implement undo
  }
}
