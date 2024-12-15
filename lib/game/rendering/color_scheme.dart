// Abstraction
import 'package:bomberman/game/rendering/sprite_sheet_cache.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

abstract class ColorScheme {
  final ColorImplementor implementor;

  ColorScheme(this.implementor);

  Future<SpriteSheet> getSprite(String assetPath) async {
    final spriteSheet = await SpriteSheetCache.getSpriteSheet(
      assetPath,
      Vector2(32, 32),
    );

    // Apply color tinting to a copy of the sprites to avoid modifying cached version
    final sprites = spriteSheet.sprites;
    for (final sprite in sprites) {
      sprite.paint.colorFilter = implementor.getColorFilter();
    }

    return spriteSheet;
  }
}

// Refined Abstractions
class PlayerColorScheme extends ColorScheme {
  PlayerColorScheme(super.implementor);
}

class BombColorScheme extends ColorScheme {
  BombColorScheme(super.implementor);
}

// Implementor
abstract class ColorImplementor {
  ColorFilter getColorFilter();
}

// Concrete Implementors
class RedColorImplementor implements ColorImplementor {
  @override
  ColorFilter getColorFilter() {
    return ColorFilter.mode(
      Colors.red.withOpacity(0.5),
      BlendMode.srcATop,
    );
  }
}

class BlueColorImplementor implements ColorImplementor {
  @override
  ColorFilter getColorFilter() {
    return ColorFilter.mode(
      Colors.blue.withOpacity(0.5),
      BlendMode.srcATop,
    );
  }
}

class BlackColorImplementor implements ColorImplementor {
  @override
  ColorFilter getColorFilter() {
    return ColorFilter.mode(
      Colors.black.withOpacity(0.5),
      BlendMode.srcATop,
    );
  }
}

extension SpriteSheetExtension on SpriteSheet {
  List<Sprite> get sprites {
    final rows = this.rows;
    final columns = this.columns;
    final sprites = <Sprite>[];
    for (var row = 0; row < rows; row++) {
      for (var column = 0; column < columns; column++) {
        sprites.add(getSprite(row, column));
      }
    }
    return sprites;
  }
}
