import 'package:bomberman/enums/game_theme.dart';
import 'package:bomberman/menu/bloc/game_settings_bloc.dart';
import 'package:bomberman/menu/memento/settings_caretaker.dart';
import 'package:bomberman/menu/memento/settings_memento.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//* MEMENTO PATTERN
class EditSettingsBloc extends Cubit<GameSettingsState> {
  final GameSettingsBloc _gameSettingsBloc;
  final SettingsCaretaker _caretaker = SettingsCaretaker();

  EditSettingsBloc(this._gameSettingsBloc)
      : super(GameSettingsState(
          theme: _gameSettingsBloc.state.theme,
          volume: _gameSettingsBloc.state.volume,
          isMuted: _gameSettingsBloc.state.isMuted,
        )) {
    _saveState();
  }

  void setTheme(GameTheme theme) {
    emit(state.copyWith(theme: theme));
  }

  void setVolume(double volume) {
    emit(state.copyWith(volume: volume));
  }

  void setIsMuted(bool isMuted) {
    emit(state.copyWith(isMuted: isMuted));
  }

  void saveSettings() {
    _saveState();
    _gameSettingsBloc.updateSettings(state);
  }

  void revertSettings() {
    final previousMemento = _caretaker.undo();
    if (previousMemento != null) {
      previousMemento.restore();
      _gameSettingsBloc.updateSettings(
        state,
      );
    }
  }

  void _saveState() {
    final memento = SettingsMemento.fromState(
      state,
      this,
    );
    _caretaker.saveMemento(memento);
  }

  void restoreFromMemento(GameSettingsState state) {
    emit(state);
  }

  bool get canRevert => _caretaker.canUndo;
}
