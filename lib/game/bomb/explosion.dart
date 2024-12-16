import 'dart:math' as math;

import 'package:bomberman/game/bomb/timed_effect.dart';
import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class Explosion extends TimedEffect {
  Explosion({required super.position, required this.damage})
      : super(duration: 0.5) {
    add(RectangleHitbox());
  }
  final int damage;

  @override
  void render(Canvas canvas) {
    final rect = size.toRect();
    final paint = Paint()
      ..color =
          Colors.orange.withOpacity(math.max(0, 1 - (timeAlive / duration)));
    canvas.drawRect(rect, paint);
  }

  Vector2 getGridPosition(int tileSize) {
    return Vector2(
      (position.x / tileSize).floor().toDouble(),
      (position.y / tileSize).floor().toDouble(),
    );
  }
}
