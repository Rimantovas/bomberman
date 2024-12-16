import 'package:bomberman/enums/game_theme.dart';
import 'package:bomberman/game/board_object/board_object_factory.dart';
import 'package:bomberman/game/board_object/destroyable.dart';
import 'package:bomberman/game/board_object/destruction_strategy_factory.dart';
import 'package:bomberman/game/map/map.dart';
import 'package:flame/components.dart';

import '../board_object/board_object.dart';

//* [PATTERN] Builder Pattern
class MapBuilder {
  final int tileSize;
  final List<String> asciiMap;

  MapClass? _map;

  BoardObjectFactory _boardObjectFactory = RetroThemeBoardObjectFactory();
  final DestructionStrategyFactory _destructionStrategyFactory =
      DestructionStrategyFactory();

  MapBuilder({required this.tileSize, required this.asciiMap});

  List<BoardObject> getObjectsByChar(String char) {
    List<BoardObject> objects = [];
    for (int y = 0; y < asciiMap.length; y++) {
      for (int x = 0; x < asciiMap[y].length; x++) {
        String key = asciiMap[y][x];
        Vector2 position =
            Vector2(x * tileSize.toDouble(), y * tileSize.toDouble());
        if (key == char) {
          switch (char) {
            case ' ':
              objects.add(_boardObjectFactory.createGround(position));
              break;
            case 'D':
              final destroyable =
                  _boardObjectFactory.createDestroyable(position);
              (destroyable as Destroyable)
                  .setDestructionStrategy(_destructionStrategyFactory.create());
              objects.add(destroyable);
              break;
            case '#':
              objects.add(_boardObjectFactory.createBedrock(position));
              break;
          }
        }
      }
    }
    return objects;
  }

  void init() {
    _map ??= MapClass();
  }

  void setTheme(GameTheme theme) {
    switch (theme) {
      case GameTheme.comic:
        _boardObjectFactory = ComicThemeBoardObjectFactory();
        break;
      case GameTheme.retro:
        _boardObjectFactory = RetroThemeBoardObjectFactory();
        break;
    }
  }

  void buildGround() {
    init();
    final grounds = getObjectsByChar(' ');
    _map!.addAll(grounds);
  }

  void buildDestroyable() {
    init();
    final destroyables = getObjectsByChar('D');
    _map!.addAll(destroyables);
  }

  void buildBedrock() {
    init();
    final bedrocks = getObjectsByChar('#');
    _map!.addAll(bedrocks);
  }

  MapClass getMap() {
    init();
    final returnable = _map!;
    _map = null;
    return returnable;
  }

  MapClass build() {
    return getMap();
  }
}

class GameStartMapBuilder extends MapBuilder {
  GameStartMapBuilder({required super.tileSize, required super.asciiMap});

  @override
  MapClass build() {
    buildGround();
    buildBedrock();
    return getMap();
  }
}

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
