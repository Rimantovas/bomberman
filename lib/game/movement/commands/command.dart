import 'package:bomberman/game/player/player.dart';

abstract class Command {
  void execute(Player player);
  void undo(Player player);
}
