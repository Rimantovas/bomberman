import 'package:bomberman/movement/commands/command.dart';
import 'package:bomberman/movement/commands/move_command.dart';
import 'package:bomberman/movement/commands/place_command.dart';
import 'package:bomberman/player/player.dart';
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
      if (event.logicalKey == LogicalKeyboardKey.keyW ||
          event.logicalKey == LogicalKeyboardKey.keyS ||
          event.logicalKey == LogicalKeyboardKey.keyA ||
          event.logicalKey == LogicalKeyboardKey.keyD) {
        return MoveCommand(MovingState.still);
      }
    }
    return null;
  }
}
