import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game/board_object/board_object.dart';
import 'game/map/map_builder.dart';
import 'game/movement/keyboard_handler.dart';
import 'game/player/player.dart';

class BombermanGame extends FlameGame
    with HasCollisionDetection, KeyboardEvents {
  static const int tileSize = 32;
  static const int mapWidth = 15;
  static const int mapHeight = 11;

  static final Vector2 gameSize =
      Vector2(mapWidth * tileSize.toDouble(), mapHeight * tileSize.toDouble());

  late Player player;
  late List<List<BoardObject?>> grid;
  late MapBuilder mapBuilder;
  late AppKeyboardHandler keyboardHandler;

  BombermanGame()
      : super(
            camera: CameraComponent.withFixedResolution(
                width: gameSize.x, height: gameSize.y));

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    List<String> asciiMap = [
      "###############",
      "#P            #",
      "# D D D D D D #",
      "#  ###   ###  #",
      "# D D D D D D #",
      "#  ###   ###  #",
      "# D D D D D D #",
      "#  ###   ###  #",
      "# D D D D D D #",
      "#             #",
      "###############",
    ];

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

    Vector2 playerPosition = Vector2(tileSize.toDouble(), tileSize.toDouble());
    player = Player(position: playerPosition);
    add(player);

    keyboardHandler = AppKeyboardHandler(player);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final command = keyboardHandler.handleKeyEvent(event);
    if (command != null) {
      command.execute(player);
      return KeyEventResult.handled;
    }
    return KeyEventResult.handled;
  }
}
