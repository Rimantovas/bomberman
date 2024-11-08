import 'package:bomberman/game/movement/commands/command.dart';

class CommandHistory {
  final List<Command> _history = [];

  void push(Command command) {
    _history.add(command);
  }

  Command? pop() {
    if (_history.isNotEmpty) {
      return _history.removeLast();
    }
    return null;
  }

  bool get isEmpty => _history.isEmpty;

  void clear() {
    _history.clear();
  }
}
