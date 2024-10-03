import 'package:bomberman/movement/commands/command.dart';
import 'package:bomberman/player/player.dart';

class MoveCommand implements Command {
  final MovingState state;

  MoveCommand(this.state);

  @override
  void execute(Player player) {
    player.setState(state);
  }
}
