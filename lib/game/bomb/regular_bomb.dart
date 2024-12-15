import 'package:bomberman/game/bomb/bomb.dart';
import 'package:bomberman/game/bomb/regular_bomb_explosion.dart';
import 'package:bomberman/utils/app_asset.dart';

class RegularBomb extends Bomb {
  RegularBomb({
    required super.primaryModifier,
    required super.secondaryModifier,
    required super.colorScheme,
    super.explosionDelay = 3.0,
    required super.position,
  })  : strength = primaryModifier * 3,
        branching = secondaryModifier * 1;

  final int strength;
  final int branching;

  @override
  String get spritePath => AppAsset.bombDynamite;

  @override
  void execute() {
    final explosion = RegularBombExplosion(
      gameRef: gameRef,
      position: position,
      strength: strength,
      branching: branching,
    );
    explosion.execute();
    gameRef.remove(this);
  }
}
