import 'dart:ui';

import 'package:bomberman/game/rendering/performance_monitor.dart';
import 'package:flame/game.dart';

mixin HasSpriteLoadingTracker on Game {
  bool _isTracking = false;
  bool _hasRendered = false;
  final _stopwatch = Stopwatch();

  void startTrackingSpriteLoading() {
    _isTracking = true;
    _hasRendered = false;
    _stopwatch.reset();
    _stopwatch.start();
    SpriteSheetPerformanceMonitor.startMonitoring();
  }

  void stopTrackingSpriteLoading() {
    if (!_isTracking) return;

    _stopwatch.stop();
    _isTracking = false;

    print('\n=== Sprite Loading Performance ===');
    print('Total Loading Time: ${_stopwatch.elapsedMilliseconds}ms');
    SpriteSheetPerformanceMonitor.printStats();
  }

  @override
  Future<void> onLoad() async {
    startTrackingSpriteLoading();
    await super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (_isTracking && !_hasRendered) {
      _hasRendered = true;
      stopTrackingSpriteLoading();
    }
  }
}
