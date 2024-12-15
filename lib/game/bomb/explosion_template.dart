import 'package:bomberman/game.dart';
import 'package:flame/components.dart';

//* TEMPLATE PATTERN
abstract class BombExplosionTemplate {
  final BombermanGame gameRef;
  final Vector2 position;
  final int strength;
  final int branching;

  BombExplosionTemplate({
    required this.gameRef,
    required this.position,
    required this.strength,
    required this.branching,
  });

  // Template method that defines the algorithm's skeleton
  void execute() {
    final explosionTiles = determineExplosionPath();
    createExplosions(explosionTiles);
    applyDamage(explosionTiles);
    cleanup();
  }

  // Abstract methods to be implemented by concrete classes
  List<Vector2> determineExplosionPath();
  void createExplosions(List<Vector2> explosionTiles);
  void applyDamage(List<Vector2> explosionTiles);
  void cleanup();
}
