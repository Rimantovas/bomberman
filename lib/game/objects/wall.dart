import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Wall extends PositionComponent {
  Wall({required Vector2 position})
      : super(position: position, size: Vector2(50, 50));

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), Paint()..color = Colors.grey);
  }
}
