import 'package:bomberman/game/rendering/performance_monitor.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

//* FLYWEIGHT PATTERN
class SpriteSheetCache {
  static final Map<String, SpriteSheet> _cache = {};
  static final Map<String, Future<SpriteSheet>> _loading = {};
  static bool _enabled = true;

  static void enable() => _enabled = true;
  static void disable() => _enabled = false;
  static bool get isEnabled => _enabled;

  static Future<SpriteSheet> getSpriteSheet(
    String path,
    Vector2 srcSize,
  ) async {
    SpriteSheetPerformanceMonitor.recordLoad(path);

    if (!_enabled) {
      final image = await Flame.images.load(path);
      return SpriteSheet(
        image: image,
        srcSize: srcSize,
      );
    }

    // Return cached sprite sheet if available
    if (_cache.containsKey(path)) {
      return _cache[path]!;
    }

    // Wait for existing load operation if one is in progress
    if (_loading.containsKey(path)) {
      return await _loading[path]!;
    }

    // Start new load operation
    _loading[path] = _loadSpriteSheet(path, srcSize);
    final spriteSheet = await _loading[path]!;

    // Cache the result and clean up loading state
    _cache[path] = spriteSheet;
    _loading.remove(path);

    return spriteSheet;
  }

  static Future<SpriteSheet> _loadSpriteSheet(
      String path, Vector2 srcSize) async {
    final image = await Flame.images.load(path);
    return SpriteSheet(
      image: image,
      srcSize: srcSize,
    );
  }

  static void clearCache() {
    _cache.clear();
    _loading.clear();
  }

  static int getCacheSize() => _cache.length;
}
