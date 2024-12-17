import 'package:bomberman/audio/audio_manager.dart';

//* [PATTERN] Composite Pattern
abstract class AudioComponent {
  final String assetPath;

  AudioComponent({required this.assetPath});

  void play();
}

class SoundEffect extends AudioComponent {
  SoundEffect({required super.assetPath});

  @override
  void play() {
    AudioManager().playEffect(assetPath);
  }
}

class SoundGroup extends AudioComponent {
  final List<AudioComponent> audios;

  SoundGroup({required super.assetPath, required this.audios});

  @override
  void play() {
    for (final audio in audios) {
      audio.play();
    }
  }
}
