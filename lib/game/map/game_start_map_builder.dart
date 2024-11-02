import 'package:bomberman/game/map/map.dart';
import 'package:bomberman/game/map/map_builder.dart';

//* [PATTERN] Builder Pattern
class GameStartMapBuilder extends MapBuilder {
  GameStartMapBuilder({required super.tileSize, required super.asciiMap});

  @override
  MapClass build() {
    buildGround();
    buildBedrock();
    return getMap();
  }
}
