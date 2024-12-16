import 'package:bomberman/enums/game_theme.dart';
import 'package:bomberman/utils/key_value/key_value_storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class GameSettingsBloc extends Cubit<GameSettingsState> {
  GameSettingsBloc() : super(const GameSettingsState()) {
    init();
  }
  final IGameSettings settings = PersistentGameSettings(GameSettings());

  Future<void> init() async {
    await settings.loadInitialSettings();
    emit(settings.state);
  }

  void updateSettings(GameSettingsState newState) {
    settings.updateSettings(
      theme: newState.theme,
      volume: newState.volume,
      isMuted: newState.isMuted,
    );
    emit(settings.state);
  }
}

//* [PATTERN] Proxy Pattern
abstract class IGameSettings {
  Future<void> loadInitialSettings();
  void updateSettings({GameTheme? theme, double? volume, bool? isMuted});
  GameSettingsState get state;
}

class GameSettings implements IGameSettings {
  GameSettingsState _state = const GameSettingsState();

  @override
  Future<void> loadInitialSettings() async {}

  @override
  void updateSettings({
    GameTheme? theme,
    double? volume,
    bool? isMuted,
  }) {
    _state = _state.copyWith(
      theme: theme,
      volume: volume,
      isMuted: isMuted,
    );
  }

  @override
  GameSettingsState get state {
    return _state;
  }
}

class PersistentGameSettings implements IGameSettings {
  final GameSettings _gameSettings;
  final KeyValueStorageService _storageService =
      GetIt.I<KeyValueStorageService>();

  PersistentGameSettings(this._gameSettings) : super() {
    loadInitialSettings();
  }

  @override
  Future<void> loadInitialSettings() async {
    final theme = await _loadTheme();
    final volume = await _loadVolume();
    final isMuted = await _loadIsMuted();

    _gameSettings.updateSettings(
      theme: theme,
      volume: volume,
      isMuted: isMuted,
    );
  }

  @override
  void updateSettings({GameTheme? theme, double? volume, bool? isMuted}) {
    _gameSettings.updateSettings(
      theme: theme,
      volume: volume,
      isMuted: isMuted,
    );
    if (theme != null) {
      _saveTheme(theme);
    }
    if (volume != null) {
      _saveVolume(volume);
    }
    if (isMuted != null) {
      _saveIsMuted(isMuted);
    }
  }

  @override
  GameSettingsState get state {
    return _gameSettings.state;
  }

  Future<GameTheme> _loadTheme() async {
    final theme = await _storageService.get(KVKeys.theme);
    final index = theme.getOrElse(() => '0');
    if (index.isNotEmpty) {
      return GameTheme.values[int.parse(index)];
    }
    return GameTheme.comic;
  }

  Future<double?> _loadVolume() async {
    final volume = await _storageService.get(KVKeys.volume);
    return volume.map(double.tryParse).getOrElse(() => 0.5);
  }

  Future<bool?> _loadIsMuted() async {
    final isMuted = await _storageService.getBool(KVKeys.isMuted);
    return isMuted.getOrElse(() => false);
  }

  Future<void> _saveTheme(GameTheme theme) async {
    await _storageService.set(KVKeys.theme, theme.index.toString());
  }

  Future<void> _saveVolume(double volume) async {
    await _storageService.set(KVKeys.volume, volume.toString());
  }

  Future<void> _saveIsMuted(bool isMuted) async {
    await _storageService.setBool(KVKeys.isMuted, isMuted);
  }
}

class GameSettingsState {
  const GameSettingsState({
    this.theme = GameTheme.comic,
    this.volume = 1,
    this.isMuted = false,
  });

  final GameTheme theme;
  final double volume;
  final bool isMuted;

  GameSettingsState copyWith({
    GameTheme? theme,
    double? volume,
    bool? isMuted,
  }) {
    return GameSettingsState(
      theme: theme ?? this.theme,
      volume: volume ?? this.volume,
      isMuted: isMuted ?? this.isMuted,
    );
  }
}
