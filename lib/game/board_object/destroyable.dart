import 'package:bomberman/game.dart';
import 'package:bomberman/game/board_object/destruction_strategy.dart';
import 'package:bomberman/game/rendering/sprite_sheet_cache.dart';
import 'package:flame/components.dart';

import '../../utils/app_asset.dart';
import 'board_object.dart';

//* [PATTERN] Prototype Pattern
mixin Prototype<T> {
  T clone();
}

//* [PATTERN] Has Strategy Pattern
abstract class Destroyable extends BoardObject
    with HasGameRef, Prototype<Destroyable> {
  Destroyable({
    required super.position,
  }) : super(size: Vector2(32, 32));

  DestructionStrategy? destructionStrategy = DefaultDestructionStrategy();

  void setDestructionStrategy(DestructionStrategy destructionStrategy) {
    this.destructionStrategy = destructionStrategy;
  }

  void executeDestruction(BombermanGame gameRef, int gridY, int gridX) {
    destructionStrategy?.destroy(position, gameRef, gridY, gridX);
    destructionStrategy = null;
  }

  @override
  bool canBeDestroyed() {
    return true;
  }
}

class ComicThemeDestroyable extends Destroyable {
  ComicThemeDestroyable({required super.position}) : super();
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final spriteSheet = await SpriteSheetCache.getSpriteSheet(
      AppAsset.destroyableBox,
      Vector2(32, 32),
    );
    sprite = spriteSheet.getSprite(0, 0);
  }

  @override
  Destroyable clone() {
    return ComicThemeDestroyable(position: Vector2(position.x, position.y));
  }
}

class RetroThemeDestroyable extends Destroyable {
  RetroThemeDestroyable({required super.position}) : super();
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final spriteSheet = await SpriteSheetCache.getSpriteSheet(
      AppAsset.destroyableBox,
      Vector2(32, 32),
    );
    sprite = spriteSheet.getSprite(0, 0);
  }

  @override
  Destroyable clone() {
    return RetroThemeDestroyable(position: Vector2(position.x, position.y));
  }
}
