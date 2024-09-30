import 'package:flame/components.dart';

import '../app_asset.dart';
import 'board_object.dart';

class Destroyable extends BoardObject with HasGameRef {
  Destroyable({required super.position}) : super(size: Vector2(32, 32));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite(
      AppAsset.destroyableBox,
      srcSize: Vector2(32, 32),
    );
  }

  @override
  bool canBeDestroyed() {
    return true;
  }
}
