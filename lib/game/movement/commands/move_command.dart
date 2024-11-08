import 'package:bomberman/game/movement/commands/command.dart';
import 'package:bomberman/game/movement/moving_state.dart';
import 'package:bomberman/game/player/player.dart';

class MoveCommand implements Command {
  final MovingState newState;
  late MovingState previousState;

  MoveCommand(this.newState);

  @override
  void execute(Player player) {
    previousState = player.state;
    player.setState(newState);
  }

  @override
  void undo(Player player) {
    player.setState(previousState);
  }
}
