import 'package:bomberman/game/map/map.dart';
import 'package:bomberman/game/map/map_builder.dart';

//* [PATTERN] Builder Pattern
class NormalGameMapBuilder extends MapBuilder {
  NormalGameMapBuilder({required super.tileSize, required super.asciiMap});

  @override
  MapClass build() {
    buildGround();
    buildBedrock();
    buildDestroyable();
    return getMap();
  }
}
