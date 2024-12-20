import 'dart:async';

import 'package:bomberman/src/player/models/player.dart';
import 'package:bomberman/src/player/models/player_move_request.dart';
import 'package:bomberman/src/player/repositories/player_repository.dart';
import 'package:bomberman/websocket_observer.dart';
import 'package:flame/game.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerManagerState {
  final List<PlayerModel> otherPlayers;
  final bool isLoading;
  final int myHealth;

  PlayerManagerState(
      {this.otherPlayers = const [],
      this.isLoading = false,
      this.myHealth = 100});
}

class PlayerManagerBloc extends Cubit<PlayerManagerState>
    implements WebSocketObserver {
  final PlayerRepository _playerRepository;
  final String _myPlayerId;
  final WebSocketService _webSocketService;

  PlayerManagerBloc(
    this._myPlayerId,
  )   : _playerRepository = PlayerRepository(),
        _webSocketService = WebSocketService(),
        super(PlayerManagerState());

  void startListening(List<PlayerModel> initialPlayers) {
    final otherPlayers =
        initialPlayers.where((player) => player.id != _myPlayerId).toList();
    emit(PlayerManagerState(isLoading: true, otherPlayers: otherPlayers));

    _webSocketService.addObserver(this);
  }

  @override
  void onPlayerMoved(String id, int positionX, int positionY) {
    final oldPlayers = List<PlayerModel>.from(state.otherPlayers);
    emit(PlayerManagerState(
      myHealth: state.myHealth,
      otherPlayers: oldPlayers.map((e) {
        if (e.id == id) {
          return e.copyWith(
            positionX: positionX,
            positionY: positionY,
          );
        }
        return e;
      }).toList(),
    ));
  }

  @override
  void onPlayerJoined(PlayerModel player) {
    if (player.id == _myPlayerId) return;

    if (!state.otherPlayers.any((p) => p.id == player.id)) {
      emit(PlayerManagerState(
        myHealth: state.myHealth,
        otherPlayers: [...state.otherPlayers, player],
        isLoading: false,
      ));
    }
  }

  @override
  void onPlayerLeft(String id) {
    final oldPlayers = List<PlayerModel>.from(state.otherPlayers);
    emit(PlayerManagerState(
      myHealth: state.myHealth,
      otherPlayers:
          oldPlayers.where((player) => player.id != id).toList(growable: false),
      isLoading: false,
    ));
  }

  Future<void> updateMyPosition(Vector2 newPosition) async {
    try {
      await _playerRepository.move(
          PlayerMoveRequest(
            newPosition.x.toInt(),
            newPosition.y.toInt(),
          ),
          _myPlayerId);
    } catch (e) {}
  }

  void updatePlayerHealth(String id, int health) {
    if (id == _myPlayerId) {
      emit(PlayerManagerState(
          myHealth: health, otherPlayers: state.otherPlayers));
      return;
    }
    final oldPlayers = List<PlayerModel>.from(state.otherPlayers);
    emit(PlayerManagerState(
      myHealth: state.myHealth,
      otherPlayers: oldPlayers.map((e) {
        if (e.id == id) {
          return e.copyWith();
        }
        return e;
      }).toList(),
    ));
  }

  @override
  Future<void> close() {
    _webSocketService.removeObserver(this);
    return super.close();
  }
}
