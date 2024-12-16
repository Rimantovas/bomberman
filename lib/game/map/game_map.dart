import 'package:bomberman/enums/game_theme.dart';
import 'package:bomberman/game/board_object/board_object.dart';
import 'package:bomberman/game/map/map_builder.dart';
import 'package:flame/components.dart';

//* [PATTERN] Implements Iterator Pattern
class GameMap extends Component implements Iterator<BoardObject> {
  final List<String> asciiMap;
  final GameTheme theme;

  GameMap({required this.asciiMap, required this.theme});

  static const int tileSize = 32;
  static const int mapWidth = 15;
  static const int mapHeight = 11;

  static final Vector2 gameSize =
      Vector2(mapWidth * tileSize.toDouble(), mapHeight * tileSize.toDouble());

  late List<List<BoardObject?>> grid;
  final List<BoardObject> startComponents = [];
  int _rowIndex = 0;
  int _colIndex = -1;

  Future<void> initStart() async {
    final mapBuilder =
        GameStartMapBuilder(tileSize: tileSize, asciiMap: asciiMap)
          ..setTheme(theme);

    final map = mapBuilder.build();

    grid = List.generate(
      asciiMap.length,
      (y) => List.generate(asciiMap[0].length, (x) => null),
    );

    while (map.moveNext()) {
      final object = map.current;
      await add(object);
      startComponents.add(object);
      Vector2 gridPos = object.getGridPosition(tileSize);
      grid[gridPos.y.toInt()][gridPos.x.toInt()] = object;
    }
    map.resetIterator();
  }

  Future<void> initGame() async {
    for (var component in startComponents) {
      remove(component);
    }
    startComponents.clear();
    final mapBuilder =
        NormalGameMapBuilder(tileSize: tileSize, asciiMap: asciiMap)
          ..setTheme(theme);
    final map = mapBuilder.build();
    grid = List.generate(
      asciiMap.length,
      (y) => List.generate(asciiMap[0].length, (x) => null),
    );

    while (map.moveNext()) {
      final object = map.current;
      await add(object);
      startComponents.add(object);
      Vector2 gridPos = object.getGridPosition(tileSize);
      grid[gridPos.y.toInt()][gridPos.x.toInt()] = object;
    }
    map.resetIterator();
  }

  @override
  BoardObject get current {
    return grid[_rowIndex][_colIndex]!;
  }

  @override
  bool moveNext() {
    _colIndex++;
    if (_colIndex >= grid[_rowIndex].length) {
      _colIndex = 0;
      _rowIndex++;
    }

    if (_rowIndex >= grid.length) {
      return false;
    }

    return true;
  }
}
