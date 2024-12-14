import 'package:bomberman/enums/game_theme.dart';
import 'package:bomberman/menu/bloc/game_settings_bloc.dart';
import 'package:bomberman/menu/memento/settings_caretaker.dart';
import 'package:bomberman/menu/memento/settings_memento.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//* MEMENTO PATTERN
class EditSettingsBloc extends Cubit<EditSettingsState> {
  final GameSettingsBloc _gameSettingsBloc;
  final SettingsCaretaker _caretaker = SettingsCaretaker();

  EditSettingsBloc(this._gameSettingsBloc)
      : super(EditSettingsState(theme: _gameSettingsBloc.state.theme)) {
    _saveState();
  }

  void setTheme(GameTheme theme) {
    emit(state.copyWith(theme: theme));
  }

  void saveSettings() {
    _saveState();
    _gameSettingsBloc.updateSettings(state.theme);
  }

  void revertSettings() {
    final previousMemento = _caretaker.undo();
    if (previousMemento != null) {
      previousMemento.restore();
      _gameSettingsBloc.updateSettings(state.theme);
    }
  }

  void _saveState() {
    final memento = SettingsMemento.fromState(state.theme, this);
    _caretaker.saveMemento(memento);
  }

  void restoreFromMemento(GameTheme theme) {
    emit(state.copyWith(theme: theme));
  }

  bool get canRevert => _caretaker.canUndo;
}

class EditSettingsState extends Equatable {
  final GameTheme theme;

  const EditSettingsState({
    required this.theme,
  });

  EditSettingsState copyWith({
    GameTheme? theme,
  }) {
    return EditSettingsState(
      theme: theme ?? this.theme,
    );
  }

  @override
  List<Object?> get props => [theme];
}
