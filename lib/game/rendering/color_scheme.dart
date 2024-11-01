// Abstraction
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

abstract class ColorScheme {
  final ColorImplementor implementor;

  ColorScheme(this.implementor);

  Future<SpriteSheet> getSprite(String assetPath);
}

// Refined Abstractions
class PlayerColorScheme extends ColorScheme {
  PlayerColorScheme(super.implementor);

  @override
  Future<SpriteSheet> getSprite(String assetPath) {
    return implementor.tintSprite(assetPath);
  }
}

class BombColorScheme extends ColorScheme {
  BombColorScheme(super.implementor);

  @override
  Future<SpriteSheet> getSprite(String assetPath) {
    return implementor.tintSprite(assetPath);
  }
}

// Implementor
abstract class ColorImplementor {
  Future<SpriteSheet> tintSprite(String assetPath);
}

// Concrete Implementors
class RedColorImplementor implements ColorImplementor {
  @override
  Future<SpriteSheet> tintSprite(String assetPath) async {
    final image = await Flame.images.load(assetPath);
    final spriteSheet = SpriteSheet(
      image: image,
      srcSize: Vector2(32, 32),
    );

    final sprites = spriteSheet.sprites;
    for (final sprite in sprites) {
      sprite.paint.colorFilter = ColorFilter.mode(
        Colors.red.withOpacity(0.5),
        BlendMode.srcATop,
      );
    }

    return spriteSheet;
  }
}

class BlueColorImplementor implements ColorImplementor {
  @override
  Future<SpriteSheet> tintSprite(String assetPath) async {
    final image = await Flame.images.load(assetPath);
    final spriteSheet = SpriteSheet(
      image: image,
      srcSize: Vector2(32, 32),
    );

    final sprites = spriteSheet.sprites;
    for (final sprite in sprites) {
      sprite.paint.colorFilter = ColorFilter.mode(
        Colors.blue.withOpacity(0.5),
        BlendMode.srcATop,
      );
    }

    return spriteSheet;
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
