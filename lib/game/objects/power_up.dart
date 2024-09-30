import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class PowerUp extends PositionComponent {
  PowerUp({required Vector2 position})
      : super(position: position, size: Vector2(25, 25));

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), Paint()..color = Colors.green);
  }
}
