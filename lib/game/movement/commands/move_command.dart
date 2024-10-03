import 'package:bomberman/game/movement/commands/command.dart';
import 'package:bomberman/game/player/player.dart';

class MoveCommand implements Command {
  final MovingState state;

  MoveCommand(this.state);

  @override
  void execute(Player player) {
    player.setState(state);
  }
}
