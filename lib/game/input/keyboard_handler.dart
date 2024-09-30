import 'package:flutter/services.dart';

import '../objects/player.dart';

abstract class Command {
  void execute(Player player);
}

class MoveCommand implements Command {
  final MovingState state;

  MoveCommand(this.state);

  @override
  void execute(Player player) {
    player.setState(state);
  }
}

class PlaceBombCommand implements Command {
  @override
  void execute(Player player) {
    player.placeBomb();
  }
}

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
