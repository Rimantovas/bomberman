import 'states/audio_state.dart';
import 'states/audio_states.dart';

//* STATE PATTERN
class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;

  late AudioContext _context;
  bool _initialized = false;

  AudioManager._internal() {
    _context = AudioContext();
  }

  Future<void> initialize() async {
    if (!_initialized) {
      await _context.soloud.init();
      _initialized = true;
    }
  }

  Future<void> loadAudio(String assetPath) async {
    if (_context.currentSource != null) {
      await _context.soloud.disposeSource(_context.currentSource!);
    }

    final source = await _context.soloud.loadAsset(assetPath);
    _context.currentSource = source;
    await _context.changeState(AudioLoadingState(_context));
  }

  Future<void> playEffect(String assetPath) async {
    final source = await _context.soloud.loadAsset(assetPath);
    await _context.soloud.play(source);
  }

  Future<void> play() async => await _context.play();
  Future<void> pause() async => await _context.pause();
  Future<void> mute() async => await _context.mute();
  Future<void> unmute() async => await _context.unmute();
  Future<void> stop() async => await _context.stop();

  Future<void> setVolume(double volume) async {
    _context.volume = volume.clamp(0.0, 1.0);
    if (_context.currentHandle != null && !_context.isMuted) {
      _context.soloud.setVolume(_context.currentHandle!, _context.volume);
    }
  }

  Future<void> dispose() async {
    if (_context.currentSource != null) {
      await _context.soloud.disposeSource(_context.currentSource!);
    }
    await _context.soloud.disposeAllSources();
  }
}
