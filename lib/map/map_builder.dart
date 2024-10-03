import 'package:flame/components.dart';

import '../board_object/bedrock.dart';
import '../board_object/board_object.dart';
import '../board_object/destroyable.dart';

class MapBuilder {
  final int tileSize;
  final List<String> asciiMap;

  MapBuilder({required this.tileSize, required this.asciiMap});

  List<BoardObject> build() {
    List<BoardObject> objects = [];
    for (int y = 0; y < asciiMap.length; y++) {
      for (int x = 0; x < asciiMap[y].length; x++) {
        Vector2 position =
            Vector2(x * tileSize.toDouble(), y * tileSize.toDouble());
        switch (asciiMap[y][x]) {
          case '#':
            objects.add(Bedrock(position: position));
            break;
          case 'D':
            objects.add(Destroyable(position: position));
            break;
          // Add more cases for other object types as needed
        }
      }
    }
    return objects;
  }
}
