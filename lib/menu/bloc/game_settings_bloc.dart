import 'package:bomberman/enums/game_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameSettingsBloc extends Cubit<GameSettingsState> {
  GameSettingsBloc() : super(const GameSettingsState());

  void updateSettings(GameSettingsState state) {
    emit(state);
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
