import 'package:flame/components.dart';

import 'board_object.dart';

class Ground extends BoardObject with HasGameRef {
  Ground({required super.position}) : super(size: Vector2(32, 32));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  @override
  bool canBeDestroyed() {
    return false;
  }

  @override
  bool canBeWalkedOn() {
    return true;
  }
}
