import 'package:bomberman/game/board_object/board_object.dart';
import 'package:bomberman/game/map/game_start_map_builder.dart';
import 'package:bomberman/game/map/normal_game_map_builder.dart';
import 'package:flame/components.dart';

class GameMap extends Component {
  final List<String> asciiMap;

  GameMap({required this.asciiMap});

  static const int tileSize = 32;
  static const int mapWidth = 15;
  static const int mapHeight = 11;

  static final Vector2 gameSize =
      Vector2(mapWidth * tileSize.toDouble(), mapHeight * tileSize.toDouble());

  late final List<List<BoardObject?>> grid;
  final List<BoardObject> startComponents = [];

  void initStart() {
    final mapBuilder =
        GameStartMapBuilder(tileSize: tileSize, asciiMap: asciiMap);

    final map = mapBuilder.build();
    final objects = map.objects;
    grid = List.generate(
      asciiMap.length,
      (y) => List.generate(asciiMap[0].length, (x) => null),
    );

    for (var object in objects) {
      add(object);
      startComponents.add(object);

      Vector2 gridPos = object.getGridPosition(tileSize);
      grid[gridPos.y.toInt()][gridPos.x.toInt()] = object;
    }
  }

  void initGame() {
    for (var component in startComponents) {
      remove(component);
    }
    startComponents.clear();
    final mapBuilder =
        NormalGameMapBuilder(tileSize: tileSize, asciiMap: asciiMap);
    final map = mapBuilder.build();
    final objects = map.objects;
    grid = List.generate(
      asciiMap.length,
      (y) => List.generate(asciiMap[0].length, (x) => null),
    );

    for (var object in objects) {
      add(object);
      Vector2 gridPos = object.getGridPosition(tileSize);
      grid[gridPos.y.toInt()][gridPos.x.toInt()] = object;
    }
  }
}
