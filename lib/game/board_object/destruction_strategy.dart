import 'package:bomberman/game.dart';
import 'package:bomberman/game/board_object/destroyable.dart';
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
    final boardObject = gameRef.gameMap.grid[gridY][gridX];
    final clonedDestroyable = (boardObject! as Destroyable).clone();
    gameRef.gameMap.remove(gameRef.gameMap.grid[gridY][gridX]!);
    gameRef.gameMap.grid[gridY][gridX] = null;

    gameRef.add(
      TimerComponent(
        period: 500,
        onTick: () {
          gameRef.add(clonedDestroyable);
          gameRef.gameMap.grid[gridY][gridX] = clonedDestroyable;
        },
      ),
    );
  }
}
