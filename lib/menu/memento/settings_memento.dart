import 'dart:convert';

import 'package:bomberman/enums/game_theme.dart';
import 'package:bomberman/menu/bloc/edit_settings_bloc.dart';
import 'package:bomberman/menu/bloc/game_settings_bloc.dart';

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
      GameSettingsState state, EditSettingsBloc originator) {
    final stateMap = {
      'theme': state.theme.index,
      'volume': state.volume,
      'isMuted': state.isMuted,
    };
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
    final volume = stateMap['volume'] as double;
    final isMuted = stateMap['isMuted'] as bool;
    _originator.restoreFromMemento(
      GameSettingsState(theme: theme, volume: volume, isMuted: isMuted),
    );
  }

  DateTime get createdAt => _createdAt;
}
