import 'audio_state.dart';

//* STATE PATTERN
class AudioPlayingState extends AudioState {
  final AudioContext context;

  AudioPlayingState(this.context);

  @override
  Future<void> play() async {
    // Already playing
  }

  @override
  Future<void> pause() async {
    if (context.currentHandle != null) {
      context.soloud.setPause(context.currentHandle!, true);
      await context.changeState(AudioPausedState(context));
    }
  }

  @override
  Future<void> mute() async {
    if (context.currentHandle != null) {
      context.isMuted = true;
      context.soloud.setVolume(context.currentHandle!, 0);
      await context.changeState(AudioMutedState(context));
    }
  }

  @override
  Future<void> unmute() async {
    // Already playing and unmuted
  }

  @override
  Future<void> stop() async {
    if (context.currentHandle != null) {
      await context.soloud.stop(context.currentHandle!);
      await context.changeState(AudioLoadingState(context));
    }
  }
}

class AudioPausedState extends AudioState {
  final AudioContext context;

  AudioPausedState(this.context);

  @override
  Future<void> play() async {
    if (context.currentHandle != null) {
      context.soloud.setPause(context.currentHandle!, false);
      await context.changeState(AudioPlayingState(context));
    }
  }

  @override
  Future<void> pause() async {
    // Already paused
  }

  @override
  Future<void> mute() async {
    if (context.currentHandle != null) {
      context.isMuted = true;
      context.soloud.setVolume(context.currentHandle!, 0);
      await context.changeState(AudioMutedState(context));
    }
  }

  @override
  Future<void> unmute() async {
    // Not relevant in paused state
  }

  @override
  Future<void> stop() async {
    if (context.currentHandle != null) {
      await context.soloud.stop(context.currentHandle!);
      await context.changeState(AudioLoadingState(context));
    }
  }
}

class AudioMutedState extends AudioState {
  final AudioContext context;

  AudioMutedState(this.context);

  @override
  Future<void> play() async {
    // Stay muted but playing
    if (context.currentHandle != null) {
      context.soloud.setPause(context.currentHandle!, false);
    }
  }

  @override
  Future<void> pause() async {
    if (context.currentHandle != null) {
      context.soloud.setPause(context.currentHandle!, true);
      await context.changeState(AudioPausedState(context));
    }
  }

  @override
  Future<void> mute() async {
    // Already muted
  }

  @override
  Future<void> unmute() async {
    if (context.currentHandle != null) {
      context.isMuted = false;
      context.soloud.setVolume(context.currentHandle!, context.volume);
      await context.changeState(AudioPlayingState(context));
    }
  }

  @override
  Future<void> stop() async {
    if (context.currentHandle != null) {
      await context.soloud.stop(context.currentHandle!);
      await context.changeState(AudioLoadingState(context));
    }
  }
}

class AudioLoadingState extends AudioState {
  final AudioContext context;

  AudioLoadingState(this.context);

  @override
  Future<void> play() async {
    if (context.currentSource != null) {
      final handle = await context.soloud.play(context.currentSource!);
      context.currentHandle = handle;
      await context.changeState(AudioPlayingState(context));
    }
  }

  @override
  Future<void> pause() async {
    // Cannot pause while loading
  }

  @override
  Future<void> mute() async {
    context.isMuted = true;
  }

  @override
  Future<void> unmute() async {
    context.isMuted = false;
  }

  @override
  Future<void> stop() async {
    // Already stopped/loading
  }
}
