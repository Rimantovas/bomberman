import 'package:bomberman/game/board_object/board_object.dart';
import 'package:bomberman/game/map/map_builder.dart';
import 'package:flame/components.dart';

class GameMap extends Component {
  final List<String> asciiMap;

  GameMap({required this.asciiMap});

  static const int tileSize = 32;
  static const int mapWidth = 15;
  static const int mapHeight = 11;

  static final Vector2 gameSize =
      Vector2(mapWidth * tileSize.toDouble(), mapHeight * tileSize.toDouble());

  late final MapBuilder mapBuilder;
  late final List<List<BoardObject?>> grid;

  void init() {
    mapBuilder = MapBuilder(tileSize: tileSize, asciiMap: asciiMap);
    grid = List.generate(
      asciiMap.length,
      (y) => List.generate(asciiMap[0].length, (x) => null),
    );

    for (var object in mapBuilder.build()) {
      add(object);
      Vector2 gridPos = object.getGridPosition(tileSize);
      grid[gridPos.y.toInt()][gridPos.x.toInt()] = object;
    }
  }
}
