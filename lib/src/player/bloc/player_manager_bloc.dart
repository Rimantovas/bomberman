import 'dart:async';

import 'package:bomberman/src/player/models/player.dart';
import 'package:bomberman/src/player/repositories/player_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerManagerState {
  final List<PlayerModel> otherPlayers;
  final bool isLoading;

  PlayerManagerState({this.otherPlayers = const [], this.isLoading = false});
}

class PlayerManagerBloc extends Cubit<PlayerManagerState> {
  final PlayerRepository _playerRepository;
  final String _myPlayerId;
  StreamSubscription? _playerSubscription;

  PlayerManagerBloc(this._myPlayerId)
      : _playerRepository = PlayerRepository(),
        super(PlayerManagerState());

  void startListening(String sessionId) {
    emit(PlayerManagerState(isLoading: true));
    _playerSubscription = _playerRepository.getPlayersStream(sessionId).listen(
      (players) {
        final otherPlayers =
            players.where((player) => player.id != _myPlayerId).toList();
        emit(PlayerManagerState(otherPlayers: otherPlayers, isLoading: false));
      },
      onError: (error) {
        // Handle error
        emit(PlayerManagerState(isLoading: false));
      },
    );
  }

  @override
  Future<void> close() {
    _playerSubscription?.cancel();
    return super.close();
  }
}
