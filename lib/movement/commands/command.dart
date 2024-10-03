import 'package:bomberman/player/player.dart';

abstract class Command {
  void execute(Player player);
}
