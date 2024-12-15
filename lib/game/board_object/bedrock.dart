import 'package:bomberman/game/rendering/sprite_sheet_cache.dart';
import 'package:flame/components.dart';

import '../../utils/app_asset.dart';
import 'board_object.dart';

abstract class Bedrock extends BoardObject with HasGameRef {
  Bedrock({required super.position}) : super(size: Vector2(32, 32));
}

class RetroThemeBedrock extends Bedrock {
  RetroThemeBedrock({required super.position}) : super();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final spriteSheet = await SpriteSheetCache.getSpriteSheet(
      AppAsset.bedrockWall,
      Vector2(32, 32),
    );
    sprite = spriteSheet.getSprite(0, 0);
  }
}

class ComicThemeBedrock extends Bedrock {
  ComicThemeBedrock({required super.position}) : super();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final spriteSheet = await SpriteSheetCache.getSpriteSheet(
      AppAsset.bedrockWall,
      Vector2(32, 32),
    );
    sprite = spriteSheet.getSprite(0, 0);
  }
}
