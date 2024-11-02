import 'package:flame/components.dart';

import '../../utils/app_asset.dart';
import 'board_object.dart';

abstract class Destroyable extends BoardObject with HasGameRef {
  Destroyable({required super.position}) : super(size: Vector2(32, 32));

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
    sprite = await gameRef.loadSprite(
      AppAsset.destroyableBox, //todo change to comic theme
      srcSize: Vector2(32, 32),
    );
  }
}

class RetroThemeDestroyable extends Destroyable {
  RetroThemeDestroyable({required super.position}) : super();
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite(
      AppAsset.destroyableBox, //todo change to retro theme
      srcSize: Vector2(32, 32),
    );
  }
}
