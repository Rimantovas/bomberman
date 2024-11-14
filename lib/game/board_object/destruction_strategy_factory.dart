import 'dart:math';

import 'package:bomberman/game/board_object/destruction_strategy.dart';

//* [PATTERN] Factory Method Pattern
class DestructionStrategyFactory {
  DestructionStrategy create() {
    const double defaultWeight = 0.5;
    const double delayedWeight = 0.2;
    const double bombAppearWeight = 0.1;

    final random = Random().nextDouble();

    if (random < defaultWeight) {
      return DefaultDestructionStrategy();
    } else if (random < defaultWeight + delayedWeight) {
      return DelayedDestructionStrategy();
    } else if (random < defaultWeight + delayedWeight + bombAppearWeight) {
      return BombAppearDestructionStrategy();
    } else {
      return DestroyableAppearDestructionStrategy();
    }
  }
}