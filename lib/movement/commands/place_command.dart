import 'package:bomberman/movement/commands/command.dart';
import 'package:bomberman/player/player.dart';

class PlaceBombCommand implements Command {
  @override
  void execute(Player player) {
    player.placeBomb();
  }
}
