import 'package:bomberman/game/rendering/sprite_sheet_cache.dart';
import 'package:bomberman/utils/app_asset.dart';
import 'package:flame/components.dart';

import 'board_object.dart';

abstract class Ground extends BoardObject with HasGameRef {
  Ground({required super.position}) : super(size: Vector2(32, 32));

  @override
  bool canBeDestroyed() {
    return false;
  }

  @override
  bool canBeWalkedOn() {
    return true;
  }
}

class ComicThemeGround extends Ground {
  ComicThemeGround({required super.position}) : super();
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final spriteSheet = await SpriteSheetCache.getSpriteSheet(
      AppAsset.grass,
      Vector2(32, 32),
    );
    sprite = spriteSheet.getSprite(0, 0);
  }
}

class RetroThemeGround extends Ground {
  RetroThemeGround({required super.position}) : super();
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final spriteSheet = await SpriteSheetCache.getSpriteSheet(
      AppAsset.grass,
      Vector2(32, 32),
    );
    sprite = spriteSheet.getSprite(0, 0);
  }
}
