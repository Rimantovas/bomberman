import 'package:bomberman/game/movement/commands/command.dart';
import 'package:bomberman/game/movement/commands/move_command.dart';
import 'package:bomberman/game/movement/commands/place_command.dart';
import 'package:bomberman/game/movement/moving_state.dart';
import 'package:bomberman/game/player/player.dart';
import 'package:flutter/services.dart';

class AppKeyboardHandler {
  final Player player;

  AppKeyboardHandler(this.player);

  Command? handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
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
      }
    } else if (event is KeyUpEvent) {
      // Check if another key is pressed, if so, do nothing

      if (event.logicalKey == LogicalKeyboardKey.keyW &&
          player.state == MovingState.up) {
        return MoveCommand(MovingState.still);
      }
      if (event.logicalKey == LogicalKeyboardKey.keyS &&
          player.state == MovingState.down) {
        return MoveCommand(MovingState.still);
      }
      if (event.logicalKey == LogicalKeyboardKey.keyA &&
          player.state == MovingState.left) {
        return MoveCommand(MovingState.still);
      }
      if (event.logicalKey == LogicalKeyboardKey.keyD &&
          player.state == MovingState.right) {
        return MoveCommand(MovingState.still);
      }
    }
    return null;
  }
}
