import 'package:bomberman/game/rendering/sprite_sheet_cache.dart';
import 'package:bomberman/utils/app_asset.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class PowerUp extends SpriteComponent {
  PowerUp({required Vector2 position})
      : super(position: position, size: Vector2(32, 32)) {
    add(RectangleHitbox());
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final spriteSheet = await SpriteSheetCache.getSpriteSheet(
      AppAsset.powerUp,
      Vector2(32, 32),
    );
    sprite = spriteSheet.getSprite(0, 0);
  }
}
