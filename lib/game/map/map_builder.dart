import 'package:bomberman/game/map/map.dart';
import 'package:flame/components.dart';

import '../board_object/bedrock.dart';
import '../board_object/board_object.dart';
import '../board_object/destroyable.dart';

//* [PATTERN] Builder Pattern
class MapBuilder {
  final int tileSize;
  final List<String> asciiMap;
  Map<String, List<BoardObject>> objectMap = {
    '#': [],
    'D': [],
    ' ': [],
  };
  MapClass? _map;

  MapBuilder({required this.tileSize, required this.asciiMap}) {
    for (int y = 0; y < asciiMap.length; y++) {
      for (int x = 0; x < asciiMap[y].length; x++) {
        String key = asciiMap[y][x];
        Vector2 position =
            Vector2(x * tileSize.toDouble(), y * tileSize.toDouble());
        switch (key) {
          case '#':
            objectMap['#']!.add(Bedrock(position: position));
            break;
          case 'D':
            objectMap['D']!.add(Destroyable(position: position));
            break;
          default:
            objectMap[' ']!.add(Bedrock(position: position));
            break;
        }
      }
    }
  }

  void init() {
    _map ??= MapClass();
  }

  void buildGround() {
    init();
    final grounds = objectMap[' '];
    if (grounds != null) {
      _map!.addAll(grounds);
    }
  }

  void buildDestroyable() {
    init();
    final destroyables = objectMap['D'];
    if (destroyables != null) {
      _map!.addAll(destroyables);
    }
  }

  void buildBedrock() {
    init();
    final bedrocks = objectMap['#'];
    if (bedrocks != null) {
      _map!.addAll(bedrocks);
    }
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
