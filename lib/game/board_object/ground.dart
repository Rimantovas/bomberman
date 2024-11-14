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
    sprite = await gameRef.loadSprite(
      AppAsset.grass, //todo change to comic theme
      srcSize: Vector2(32, 32),
    );
  }
}

class RetroThemeGround extends Ground {
  RetroThemeGround({required super.position}) : super();
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite(
      AppAsset.grass, //todo change to comic theme
      srcSize: Vector2(32, 32),
    );
  }
}
