import 'dart:developer';
import 'dart:io' show ProcessInfo;

import 'package:bomberman/game/rendering/sprite_sheet_cache.dart';

//* FLYWEIGHT PATTERN
class SpriteSheetPerformanceMonitor {
  static int _loadCount = 0;
  static final Stopwatch _stopwatch = Stopwatch();
  static final Map<String, int> _assetLoadFrequency = {};
  static bool _hasLoadedLastAsset = false;
  static int? _initialMemory;

  static void startMonitoring() {
    _loadCount = 0;
    _hasLoadedLastAsset = false;
    _stopwatch.reset();
    _stopwatch.start();
    _assetLoadFrequency.clear();

    // Capture initial memory state
    _initialMemory = _getCurrentMemory();
  }

  static int _getCurrentMemory() {
    return ProcessInfo.currentRss;
  }

  static void recordLoad(String assetPath) {
    _loadCount++;
    _assetLoadFrequency[assetPath] = (_assetLoadFrequency[assetPath] ?? 0) + 1;

    // Check if this is the last asset
    if (assetPath.contains('death-front.png') && !_hasLoadedLastAsset) {
      _hasLoadedLastAsset = true;
      printStats();
    }
  }

  static Map<String, dynamic> getStats() {
    _stopwatch.stop();
    final currentMemory = _getCurrentMemory();
    final memoryDelta =
        _initialMemory != null ? currentMemory - _initialMemory! : 0;

    return {
      'totalLoads': _loadCount,
      'totalTimeMs': _stopwatch.elapsedMilliseconds,
      'cacheEnabled': SpriteSheetCache.isEnabled,
      'cacheSize': SpriteSheetCache.getCacheSize(),
      'assetLoadFrequency': _assetLoadFrequency,
      'initialMemoryKB': (_initialMemory ?? 0) ~/ 1024,
      'currentMemoryKB': currentMemory ~/ 1024,
      'memoryDeltaKB': memoryDelta ~/ 1024,
    };
  }

  static void printStats() {
    final stats = getStats();
    log('=== Sprite Sheet Loading Stats ===');
    log('Total Loads: ${stats['totalLoads']}');
    log('Total Time: ${stats['totalTimeMs']}ms');
    log('Cache Enabled: ${stats['cacheEnabled']}');
    log('Cache Size: ${stats['cacheSize']}');
    log('\nMemory Usage:');
    log('  Initial: ${stats['initialMemoryKB']}KB');
    log('  Current: ${stats['currentMemoryKB']}KB');
    log('  Delta: ${stats['memoryDeltaKB']}KB');
    log('\nAsset Load Frequency:');
    stats['assetLoadFrequency'].forEach((asset, count) {
      log('  $asset: $count times');
    });
    log('===============================');
  }
}



/// Results from testing:
/// 
/// [Cache Enabled]
/// === Sprite Sheet Loading Stats ===
/// Total Loads: 146
/// Total Time: 217ms
/// Cache Enabled: true
/// Cache Size: 10

/// Memory Usage:
/// - Initial: 263632KB
/// - Current: 269744KB
/// - Delta: 6112KB
///
///
/// [Cache Disabled]
/// === Sprite Sheet Loading Stats ===
/// Total Loads: 146
/// Total Time: 172ms
/// Cache Enabled: false
/// Cache Size: 0
///
/// Memory Usage:
/// - Initial: 215408KB
/// - Current: 229024KB
/// - Delta: 13616KB
