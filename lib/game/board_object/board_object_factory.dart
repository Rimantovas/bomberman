import 'package:bomberman/game/board_object/bedrock.dart';
import 'package:bomberman/game/board_object/board_object.dart';
import 'package:bomberman/game/board_object/destroyable.dart';
import 'package:bomberman/game/board_object/ground.dart';
import 'package:flame/components.dart';

//* [PATTERN] Abstract Factory Pattern

abstract class BoardObjectFactory {
  BoardObject createGround(Vector2 position);
  BoardObject createBedrock(Vector2 position);
  BoardObject createDestroyable(Vector2 position);
}

class ComicThemeBoardObjectFactory implements BoardObjectFactory {
  @override
  BoardObject createGround(Vector2 position) {
    return ComicThemeGround(position: position);
  }

  @override
  BoardObject createBedrock(Vector2 position) {
    return ComicThemeBedrock(position: position);
  }

  @override
  BoardObject createDestroyable(Vector2 position) {
    return ComicThemeDestroyable(position: position);
  }
}

class RetroThemeBoardObjectFactory implements BoardObjectFactory {
  @override
  BoardObject createGround(Vector2 position) {
    return RetroThemeGround(position: position);
  }

  @override
  BoardObject createBedrock(Vector2 position) {
    return RetroThemeBedrock(position: position);
  }

  @override
  BoardObject createDestroyable(Vector2 position) {
    return RetroThemeDestroyable(position: position);
  }
}
