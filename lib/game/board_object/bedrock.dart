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
    sprite = await gameRef.loadSprite(
      AppAsset.bedrockWall, //todo change to retro theme
      srcSize: Vector2(32, 32),
    );
  }
}

class ComicThemeBedrock extends Bedrock {
  ComicThemeBedrock({required super.position}) : super();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite(
      AppAsset.bedrockWall, //todo change to comic theme
      srcSize: Vector2(32, 32),
    );
  }
}
