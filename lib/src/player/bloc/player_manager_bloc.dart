import 'dart:async';

import 'package:bomberman/src/player/models/player.dart';
import 'package:bomberman/src/player/models/player_move_request.dart';
import 'package:bomberman/src/player/repositories/player_repository.dart';
import 'package:flame/game.dart';
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
    print('START LISTENING $sessionId');
    emit(PlayerManagerState(isLoading: true));
    _playerSubscription = _playerRepository.getPlayersStream(sessionId).listen(
      (players) {
        print('STREAM LISTENING ${players.length}');
        final otherPlayers =
            players.where((player) => player.id != _myPlayerId).toList();
        emit(PlayerManagerState(otherPlayers: otherPlayers, isLoading: false));
      },
      onError: (error) {
        print('STREAM ERROR $error');
        // Handle error
        emit(PlayerManagerState(isLoading: false));
      },
    );
  }

  Future<void> updateMyPosition(Vector2 newPosition) async {
    await _playerRepository.move(PlayerMoveRequest(
      newPosition.x.toInt(),
      newPosition.y.toInt(),
    ));
  }

  @override
  Future<void> close() {
    _playerSubscription?.cancel();
    return super.close();
  }
}
