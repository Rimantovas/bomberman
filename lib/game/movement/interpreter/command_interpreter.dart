// Tokenizer class to break down the command string into individual tokens
import 'package:bomberman/game/movement/commands/move_command.dart';
import 'package:bomberman/game/movement/moving_state.dart';
import 'package:bomberman/game/player/player.dart';

//* [PATTERN] Interpreter Pattern
class CommandInterpreter {
  CommandParser parser;

  CommandInterpreter(this.parser);

  void interpret(String command, Player player) {
    parser.tokenizer.tokenize(command);

    Expression? expression = parser.parse();
    if (expression != null) {
      expression.execute(player);
    }
  }
}

class Tokenizer {
  List<String> tokens = [];

  void tokenize(String command) {
    tokens = command.split(' ');
  }

  String getNextToken() {
    if (tokens.isEmpty) {
      return '';
    }
    return tokens.removeAt(0);
  }
}

abstract class Expression {
  void execute(Player player);
}

class MoveExpression extends Expression {
  String direction;

  MoveExpression(this.direction);

  @override
  void execute(Player player) {
    final movingState = switch (direction) {
      'up' => MovingState.up,
      'down' => MovingState.down,
      'left' => MovingState.left,
      'right' => MovingState.right,
      _ => MovingState.up
    };
    final command = MoveCommand(movingState);
    command.execute(player);
  }
}

class PlaceBombExpression extends Expression {
  PlaceBombExpression();

  @override
  void execute(Player player) {
    player.placeBomb();
  }
}

// Parser class to parse the tokens into an AST
class CommandParser {
  Tokenizer tokenizer;

  CommandParser(this.tokenizer);

  Expression? parse() {
    String command = tokenizer.getNextToken();

    if (command == 'move') {
      String direction = tokenizer.getNextToken();
      return MoveExpression(direction);
    } else if (command == 'place') {
      return PlaceBombExpression();
    } else {
      throw Exception('Invalid command');
    }
  }
}
