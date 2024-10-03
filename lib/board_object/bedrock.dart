import 'package:flame/components.dart';

import '../utils/app_asset.dart';
import 'board_object.dart';

class Bedrock extends BoardObject with HasGameRef {
  Bedrock({required super.position}) : super(size: Vector2(32, 32));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite(
      AppAsset.bedrockWall,
      srcSize: Vector2(32, 32),
    );
  }
}
