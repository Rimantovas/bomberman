import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Explosion extends PositionComponent {
  static const double _duration = 0.5;
  double _timeAlive = 0;

  Explosion({required Vector2 position})
      : super(position: position, size: Vector2(32, 32));

  @override
  void update(double dt) {
    super.update(dt);
    _timeAlive += dt;
    if (_timeAlive >= _duration) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final rect = size.toRect();
    final paint = Paint()
      ..color =
          Colors.orange.withOpacity(math.max(0, 1 - (_timeAlive / _duration)));
    canvas.drawRect(rect, paint);
  }

  Vector2 getGridPosition(int tileSize) {
    return Vector2(
      (position.x / tileSize).floor().toDouble(),
      (position.y / tileSize).floor().toDouble(),
    );
  }
}
