import 'dart:async';

import 'package:bomberman/src/player/models/player.dart';
import 'package:bomberman/src/player/models/player_move_request.dart';
import 'package:bomberman/src/player/repositories/player_repository.dart';
import 'package:flame/game.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class PlayerManagerState {
  final List<PlayerModel> otherPlayers;
  final bool isLoading;

  PlayerManagerState({this.otherPlayers = const [], this.isLoading = false});
}

class PlayerManagerBloc extends Cubit<PlayerManagerState> {
  final PlayerRepository _playerRepository;
  final String _myPlayerId;
  StreamSubscription? _playerSubscription;

  PlayerManagerBloc(
    this._myPlayerId,
  )   : _playerRepository = PlayerRepository(),
        super(PlayerManagerState());

  void startListening(List<PlayerModel> initialPlayers) {
    final otherPlayers =
        initialPlayers.where((player) => player.id != _myPlayerId).toList();
    emit(PlayerManagerState(isLoading: true, otherPlayers: otherPlayers));
    // Dart client
    io.Socket socket = io.io('ws://localhost:7777',
        io.OptionBuilder().setTransports(['websocket']).build());

    socket.on('player_moved', (data) {
      print('player_moved');
      final json = data as Map<String, dynamic>;
      final id = json['id'];
      final positionX = json['position_x'];
      final positionY = json['position_y'];
      final oldPlayers = List<PlayerModel>.from(state.otherPlayers);
      emit(PlayerManagerState(
          otherPlayers: oldPlayers.map((e) {
        if (e.id == id) {
          return e.copyWith(
            positionX: positionX,
            positionY: positionY,
          );
        }
        return e;
      }).toList()));
    });
    socket.on('player_joined', (data) {
      final player = PlayerModelMapper.fromMap(data);
      if (player.id == _myPlayerId) {
        return;
      }
      if (!state.otherPlayers.any((p) => p.id == player.id)) {
        emit(PlayerManagerState(
          otherPlayers: [...state.otherPlayers, player],
          isLoading: false,
        ));
      }
    });
    socket.on('player_left', (data) {
      final id = (data as Map<String, dynamic>)['id'];
      final oldPlayers = List<PlayerModel>.from(state.otherPlayers);

      emit(PlayerManagerState(
        otherPlayers: oldPlayers
            .where((player) => player.id != id)
            .toList(growable: false),
        isLoading: false,
      ));
    });
  }

  Future<void> updateMyPosition(Vector2 newPosition) async {
    print('updateMyPosition');
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
