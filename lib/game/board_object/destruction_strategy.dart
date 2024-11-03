import 'dart:math';

import 'package:bomberman/enums/game_theme.dart';
import 'package:bomberman/game.dart';
import 'package:bomberman/game/board_object/board_object_factory.dart';
import 'package:bomberman/game/bomb/bomb.dart';
import 'package:bomberman/game/bomb/bomb_factory.dart';
import 'package:bomberman/game/rendering/color_scheme.dart';
import 'package:flame/components.dart';

//top level function

//* [PATTERN] Strategy Pattern

abstract class DestructionStrategy {
  void destroy(Vector2 position, BombermanGame gameRef, int gridY, int gridX);
}

class DefaultDestructionStrategy implements DestructionStrategy {
  @override
  void destroy(
    Vector2 position,
    BombermanGame gameRef,
    int gridY,
    int gridX,
  ) {
    gameRef.gameMap.remove(gameRef.gameMap.grid[gridY][gridX]!);
    gameRef.gameMap.grid[gridY][gridX] = null;
  }
}

class DelayedDestructionStrategy implements DestructionStrategy {
  @override
  void destroy(
    Vector2 position,
    BombermanGame gameRef,
    int gridY,
    int gridX,
  ) {
    gameRef.add(
      TimerComponent(
        period: 500,
        onTick: () {
          gameRef.gameMap.remove(gameRef.gameMap.grid[gridY][gridX]!);
          gameRef.gameMap.grid[gridY][gridX] = null;
        },
      ),
    );
  }
}

class BombAppearDestructionStrategy implements DestructionStrategy {
  @override
  void destroy(
    Vector2 position,
    BombermanGame gameRef,
    int gridY,
    int gridX,
  ) {
    //todo maybe somehow refactor
    final bomb = BombFactory.createBomb(
      BombType.regular,
      position: position.clone(),
      colorScheme: BombColorScheme(BlackColorImplementor()),
      primaryModifier: 0,
      secondaryModifier: 0,
    );
    gameRef.add(bomb);

    gameRef.add(
      TimerComponent(
        period: bomb.explosionDelay,
        onTick: () {
          bomb.execute();
          gameRef.remove(bomb);
        },
      ),
    );
  }
}

class DestroyableAppearDestructionStrategy implements DestructionStrategy {
  @override
  void destroy(
    Vector2 position,
    BombermanGame gameRef,
    int gridY,
    int gridX,
  ) {
    gameRef.gameMap.remove(gameRef.gameMap.grid[gridY][gridX]!);
    gameRef.gameMap.grid[gridY][gridX] = null;

    gameRef.add(
      TimerComponent(
        period: 500,
        onTick: () {
          final theme = gameRef.gameMap.theme;
          final boardObjectFactory = switch (theme) {
            GameTheme.comic => ComicThemeBoardObjectFactory(),
            GameTheme.retro => RetroThemeBoardObjectFactory(),
          };
          final destroyable = boardObjectFactory.createDestroyable(position);
          gameRef.add(destroyable);
          gameRef.gameMap.grid[gridY][gridX] = destroyable;
        },
      ),
    );
  }
}

DestructionStrategy getRandomDestructionStrategy() {
  //weighted random
  //0.5 - default
  //0.2 - delayed
  //0.1 - bomb appear
  //0.2 - destroyable appear
  final random = Random().nextDouble();
  if (random < 0.5) {
    return DefaultDestructionStrategy();
  } else if (random < 0.7) {
    return DelayedDestructionStrategy();
  } else if (random < 0.8) {
    return BombAppearDestructionStrategy();
  } else {
    return DestroyableAppearDestructionStrategy();
  }
}