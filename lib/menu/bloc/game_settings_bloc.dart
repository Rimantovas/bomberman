import 'package:bomberman/enums/game_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameSettingsBloc extends Cubit<GameSettingsState> {
  GameSettingsBloc() : super(const GameSettingsState());

  void updateSettings(GameTheme theme) {
    emit(GameSettingsState(theme: theme));
  }
}

class GameSettingsState {
  const GameSettingsState({
    this.theme = GameTheme.comic,
  });

  final GameTheme theme;
}
