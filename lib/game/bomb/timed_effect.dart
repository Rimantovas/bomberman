import 'package:flame/components.dart';

abstract class TimedEffect extends PositionComponent {
  final double duration;
  double _timeAlive = 0;

  TimedEffect({required Vector2 position, required this.duration})
      : super(position: position, size: Vector2(32, 32));

  double get timeAlive => _timeAlive;

  @override
  void update(double dt) {
    super.update(dt);
    _timeAlive += dt;
    if (_timeAlive >= duration) {
      removeFromParent();
    }
  }
}
