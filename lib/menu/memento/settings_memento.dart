import 'dart:convert';

import 'package:bomberman/enums/game_theme.dart';
import 'package:bomberman/menu/bloc/edit_settings_bloc.dart';

//* MEMENTO PATTERN
class SettingsMemento {
  final String _encryptedState;
  final EditSettingsBloc _originator;
  final DateTime _createdAt = DateTime.now();

  SettingsMemento._({
    required String encryptedState,
    required EditSettingsBloc originator,
  })  : _encryptedState = encryptedState,
        _originator = originator;

  factory SettingsMemento.fromState(
      GameTheme theme, EditSettingsBloc originator) {
    final stateMap = {'theme': theme.index};
    final encoded = base64.encode(utf8.encode(json.encode(stateMap)));
    return SettingsMemento._(
      encryptedState: encoded,
      originator: originator,
    );
  }

  // Only the originator can restore its state
  void restore() {
    final decoded = utf8.decode(base64.decode(_encryptedState));
    final stateMap = json.decode(decoded) as Map<String, dynamic>;
    final theme = GameTheme.values[stateMap['theme'] as int];
    _originator.restoreFromMemento(theme);
  }

  DateTime get createdAt => _createdAt;
}
