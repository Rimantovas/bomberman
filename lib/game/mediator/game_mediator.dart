import 'package:bomberman/game/bomb/explosion.dart';
import 'package:bomberman/game/player/player.dart';
import 'package:bomberman/game/useless/objects/power_up.dart';

//* [Pattern] Mediator Pattern
abstract class Mediator {
  final Player player;
  final Explosion? explosion;
  final PowerUp? powerup;

  Mediator(this.player, this.explosion, this.powerup);

  void notify(GameEvent event);
}

class GameMediator extends Mediator {
  GameMediator(super.player, super.bomb, super.powerup);

  @override
  void notify(GameEvent event) {
    switch (event) {
      case GameEvent.explosion:
        if (explosion == null) return;
        player.takeDamage(explosion!.damage);
        break;
      case GameEvent.powerupCollect:
        if (powerup == null) return;
        player.collectPowerup(powerup!);
        break;
    }
  }
}

enum GameEvent { explosion, powerupCollect }
