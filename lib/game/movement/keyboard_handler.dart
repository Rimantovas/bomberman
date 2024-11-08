import 'package:bomberman/game/movement/commands/command.dart';
import 'package:bomberman/game/movement/commands/command_history.dart';
import 'package:bomberman/game/movement/commands/move_command.dart';
import 'package:bomberman/game/movement/commands/place_command.dart';
import 'package:bomberman/game/movement/moving_state.dart';
import 'package:bomberman/game/player/player.dart';
import 'package:flutter/services.dart';

class AppKeyboardHandler {
  final Player player;
  final CommandHistory _history = CommandHistory();

  AppKeyboardHandler(this.player);

  Command? handleKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      final command = _createCommand(event, keysPressed);
      if (command != null) {
        command.execute(player);
        _history.push(command);
        return command;
      }
    } else if (event is KeyUpEvent) {
      return _handleKeyUp(event);
    }
    return null;
  }

  Command? _createCommand(
      KeyDownEvent event, Set<LogicalKeyboardKey> keysPressed) {
    switch (event.logicalKey) {
      case LogicalKeyboardKey.keyW:
        return MoveCommand(MovingState.up);
      case LogicalKeyboardKey.keyS:
        return MoveCommand(MovingState.down);
      case LogicalKeyboardKey.keyA:
        return MoveCommand(MovingState.left);
      case LogicalKeyboardKey.keyD:
        return MoveCommand(MovingState.right);
      case LogicalKeyboardKey.space:
        return PlaceBombCommand();
      case LogicalKeyboardKey.keyZ:
        if (keysPressed.contains(LogicalKeyboardKey.control)) {
          return _undoLastCommand();
        }
        return null;
      default:
        return null;
    }
  }

  Command? _handleKeyUp(KeyUpEvent event) {
    if (_shouldReturnToStillState(event)) {
      final command = MoveCommand(MovingState.still);
      command.execute(player);
      _history.push(command);
      return command;
    }
    return null;
  }

  bool _shouldReturnToStillState(KeyUpEvent event) {
    return (event.logicalKey == LogicalKeyboardKey.keyW &&
            player.state == MovingState.up) ||
        (event.logicalKey == LogicalKeyboardKey.keyS &&
            player.state == MovingState.down) ||
        (event.logicalKey == LogicalKeyboardKey.keyA &&
            player.state == MovingState.left) ||
        (event.logicalKey == LogicalKeyboardKey.keyD &&
            player.state == MovingState.right);
  }

  Command? _undoLastCommand() {
    final lastCommand = _history.pop();
    if (lastCommand != null) {
      lastCommand.undo(player);
    }
    return null;
  }
}

extension on KeyDownEvent {
  bool get isControlPressed => logicalKey == LogicalKeyboardKey.control;
}
