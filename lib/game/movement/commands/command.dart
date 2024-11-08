import 'package:bomberman/game/player/player.dart';

//* [PATTERN] Command Pattern
abstract class Command {
  void execute(Player player);
  void undo(Player player);
}
