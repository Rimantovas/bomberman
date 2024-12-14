import 'package:bomberman/audio/states/audio_states.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

//* STATE PATTERN
abstract class AudioState {
  Future<void> play();
  Future<void> pause();
  Future<void> mute();
  Future<void> unmute();
  Future<void> stop();
}

class AudioContext {
  late AudioState _state;
  final SoLoud _soloud = SoLoud.instance;
  AudioSource? currentSource;
  SoundHandle? currentHandle;
  bool isMuted = false;
  double volume = 1.0;

  AudioContext() {
    _state = AudioLoadingState(this);
  }

  Future<void> changeState(AudioState state) async {
    _state = state;
  }

  Future<void> play() async => await _state.play();
  Future<void> pause() async => await _state.pause();
  Future<void> mute() async => await _state.mute();
  Future<void> unmute() async => await _state.unmute();
  Future<void> stop() async => await _state.stop();

  // Getters
  SoLoud get soloud => _soloud;
}
