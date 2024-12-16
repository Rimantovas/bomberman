import 'package:bomberman/audio/audio_manager.dart';
import 'package:bomberman/game/board_object/board_object.dart';
import 'package:bomberman/game/bomb/bomb.dart';
import 'package:bomberman/game/bomb/explosion.dart';
import 'package:bomberman/game/player/player.dart';
import 'package:bomberman/game/useless/objects/power_up.dart';

//* [Pattern] Visitor Pattern
abstract class CollisionVisitor {
  void visitWall(Player player, BoardObject wall);
  void visitBomb(Player player, Bomb bomb);
  void visitExplosion(Player player, Explosion explosion);
  void visitPowerUp(Player player, PowerUp powerUp);
}

class CollisionSoundVisitor implements CollisionVisitor {
  final AudioManager audioManager = AudioManager();
  final Map<String, DateTime> _lastPlayed = {};

  final Duration cooldown = const Duration(milliseconds: 300);

  bool _canPlaySound(String key) {
    final now = DateTime.now();
    if (_lastPlayed[key] == null ||
        now.difference(_lastPlayed[key]!) > cooldown) {
      _lastPlayed[key] = now;
      return true;
    }
    return false;
  }

  @override
  void visitWall(Player player, BoardObject wall) {
    // if (_canPlaySound('wall')) {
    //   audioManager.playEffect('assets/audio/collide_wall.mp3');
    // }
  }

  @override
  void visitBomb(Player player, Bomb bomb) {
    if (_canPlaySound('bomb')) {
      audioManager.playEffect('assets/audio/colide_bomb.mp3');
    }
  }

  @override
  void visitExplosion(Player player, Explosion explosion) {
    if (_canPlaySound('explosion')) {
      audioManager.playEffect('assets/audio/colide_explosion.mp3');
    }
  }

  @override
  void visitPowerUp(Player player, PowerUp powerUp) {
    if (_canPlaySound('power_up')) {
      audioManager.playEffect('assets/audio/colide_powerup.mp3');
    }
  }
}
